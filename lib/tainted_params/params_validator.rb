module TaintedParams

  class CoercionError < RuntimeError
  end

  class ParamTypeConstraint
    attr_reader :types

    def initialize(types)
      raise(ArgumentError, "Invalid types: #{types.inspect}") unless types.is_a?(Array)
      @types = types
    end

    def call(value)
      if @types.any?{ |t| value.is_a?(t) }
        value
      else
        :error
      end
    end
  end

  class CoercingParamTypeConstraint < ParamTypeConstraint

    attr_reader :coercion

    def initialize(type, coercion:)
      super(type)
      @coercion = coercion || raise(ArgumentError)
    end

    def call(value)
      val = coercion.call(value)

      super(value)
    rescue CoercionError
      :error
    end
  end

  class ParamConstraint
    attr_reader :name, :type, :nested

    def initialize(name:, required:, type:, nested: nil)
      raise ArgumentError unless type.is_a?(ParamTypeConstraint)

      @name = name || raise(ArgumentError)
      @required = required
      @type = type
      @nested = nested
    end

    def required?
      @required
    end

    def validate(hash)
      raise(ArgumentError, "Invalid hash: #{hash.inspect}") unless hash.is_a?(Hash)

      if v = hash[@name]
        return :error if !type.call(v) == :error
        return nested.map{ |c|
          c.validate(v)
        } if nested
        return hash.slice([@name])
      else
        return :error if required?
      end
    end

    def ==(other)
      case other
        when ParamConstraint then name == other.name
        else false
      end
    end
  end

  BOOLEAN_TYPE_CONSTRAINT = CoercingParamTypeConstraint.new([TrueClass, FalseClass], coercion: ->(val) {
    case val
      when *%w{true 1 yes} then true
      when *%w{false 0 no} then false
      else raise CoercionError
    end
  })

  INTEGER_TYPE_CONSTRAINT = CoercingParamTypeConstraint.new([Integer], coercion: ->(val) {
    Integer(val) rescue raise CoercionError
  })

  DEFAULT_TYPE_CONSTRAINTS = {
    :Boolean  => BOOLEAN_TYPE_CONSTRAINT,
    :Integer  => INTEGER_TYPE_CONSTRAINT,
    :Hash     => ParamTypeConstraint.new([Hash]),
    :String   => ParamTypeConstraint.new([String])
  }.freeze


  class ValidationResult

    attr_reader :valid, :invalid, :missing, :unpermitted

    def initialize(valid:, invalid:, missing:, unpermitted:)
      @valid = valid
      @invalid = invalid
      @missing = missing
      @unpermitted = unpermitted
    end

  end

  class ParamsValidator
    def initialize(validations)
      @validations = validations
    end

    # def validate(params)
    #   #unpermitted = params.slice(params.keys - @validations.keys)
    #   # unpermitted = StringKeyHash.new({})
    #   # invalid = StringKeyHash.new({})
    #   # missing = StringKeyHash.new({})
    #   unpermitted = {}
    #   invalid = {}
    #   missing = {}
    #   valid = {}

    #   @validations.each do |validator|
    #     #value = params[validator.name]
    #     res = validator.validate(params)

    #     case res
    #       when :error then invalid[validator.name] = :error
    #     end
    #   end

    #   ValidationResult.new(valid: valid, invalid: invalid, missing: missing, unpermitted: unpermitted)
    # end

    def validate(params)
      _validate(@validations, params)
    end

    def _validate(validations, params)
      unpermitted = params.except(validations.map(&:name))
      invalid = {}
      missing = {}
      valid = {}

      validations.each do |validation|

        if v = params[validation.name]
          if !validation.type.call(v) == :error
            invalid[validation.name] = v
          elsif validation.nested
            res = _validate(validation.nested, v)

            valid[validation.name]        = res.valid
            invalid[validation.name]      = res.invalid
            missing[validation.name]      = res.missing
            unpermitted[validation.name]  = res.unpermitted
          else
            valid[validation.name] = v
          end
        else
          if validation.required?
            missing[validation.name] = nil
          end
        end

      end

      ValidationResult.new(valid: valid, invalid: invalid, missing: missing, unpermitted: unpermitted)
    end
  end
end

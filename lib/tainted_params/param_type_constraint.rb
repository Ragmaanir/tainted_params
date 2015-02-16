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

      super(val)
    rescue CoercionError
      :error
    end

  end

  BOOLEAN_TYPE_CONSTRAINT = CoercingParamTypeConstraint.new([TrueClass, FalseClass], coercion: ->(val) {
    case val
      when true, *%w{true 1 yes} then true
      when false, *%w{false 0 no} then false
      else raise CoercionError
    end
  }).freeze

  INTEGER_TYPE_CONSTRAINT = CoercingParamTypeConstraint.new([Integer], coercion: ->(val) {
    Integer(val) rescue raise CoercionError
  }).freeze

end

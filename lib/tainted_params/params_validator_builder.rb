module TaintedParams

  DEFAULT_TYPE_CONSTRAINTS = {
    :Boolean  => BOOLEAN_TYPE_CONSTRAINT,
    :Integer  => INTEGER_TYPE_CONSTRAINT,
    :Hash     => ParamTypeConstraint.new([Hash]),
    :String   => ParamTypeConstraint.new([String])
  }.freeze

  class ParamsValidatorBuilder
    def initialize(type_constraints = DEFAULT_TYPE_CONSTRAINTS, &block)
      @type_constraints = type_constraints
      @validations = []
      @stack = [@validations]
      instance_eval(&block)
      @validations
    end

    def required(name, type, &block)
      validation(name, true, type, &block)
    end

    def permitted(name, type, &block)
      validation(name, false, type, &block)
    end

    def validation(name, required, type, &block)
      raise(ArgumentError, "Key registered twice: #{name}") if @stack.last.map(&:name).include?(name)

      type_constraint = @type_constraints[type] || raise(ArgumentError, "Could not find constraint for type #{type.inspect}")
      args = {name: name, type: type_constraint, required: required}

      if block
        nested = []
        @stack.last << ParamConstraint.new(args.merge(nested: nested))
        @stack << nested
        instance_eval(&block)
        @stack.pop
      else
        @stack.last << ParamConstraint.new(args)
      end
    end

    def raw_validations
      @validations
    end

    def result
      ParamsValidator.new(@validations)
    end
  end

end

module TaintedParams

  class ParamConstraint

    attr_reader :name, :type, :nested

    def initialize(name:, required:, type:, nested: nil)
      raise ArgumentError unless type.is_a?(ParamTypeConstraint)

      @name     = name || raise(ArgumentError)
      @required = required
      @type     = type
      @nested   = nested
    end

    def required?
      @required
    end

    def ==(other)
      case other
        when ParamConstraint then name == other.name
        else false
      end
    end

  end

end

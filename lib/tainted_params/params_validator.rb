module TaintedParams

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

    def validate(params)
      _validate(@validations, params)
    end

  private

    def _validate(validations, params)
      raise ArgumentError unless validations.is_a?(Array)
      raise ArgumentError unless params.is_a?(Hash)

      unpermitted = params.except(validations.map(&:name))
      invalid     = {}
      missing     = {}
      valid       = {}

      validations.each do |validation|

        if v = params[validation.name]
          res = validation.type.call(v)

          if res == :error
            invalid[validation.name] = v
          elsif validation.nested
            res = _validate(validation.nested, v)

            valid[validation.name]        = res.valid unless res.valid.empty?
            invalid[validation.name]      = res.invalid unless res.invalid.empty?
            missing[validation.name]      = res.missing unless res.missing.empty?
            unpermitted[validation.name]  = res.unpermitted unless res.unpermitted.empty?
          else
            valid[validation.name] = res
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

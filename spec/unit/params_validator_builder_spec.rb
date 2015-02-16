describe TaintedParams::ParamsValidatorBuilder do

  TC = TaintedParams::DEFAULT_TYPE_CONSTRAINTS

  it '' do
    b = described_class.new do
      required :id, :Integer
      permitted :options, :Hash do
        permitted :name, :String
        permitted :active, :Boolean
      end
    end

    result = [
      TaintedParams::ParamConstraint.new(name: :id, type: TC[:Integer], required: true),
      TaintedParams::ParamConstraint.new(name: :options, type: TC[:Hash], required: false, nested: [
        TaintedParams::ParamConstraint.new(name: :name, type: TC[:String], required: false),
        TaintedParams::ParamConstraint.new(name: :active, type: TC[:Boolean], required: false)
      ])
    ]

    assert{ b.raw_validations == result }
  end

end

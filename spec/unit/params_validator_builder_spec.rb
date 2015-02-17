describe TaintedParams::ParamsValidatorBuilder do

  TC = TaintedParams::DEFAULT_TYPE_CONSTRAINTS

  it 'constructs a tree out of constraints' do
    b = described_class.new do
      required :id, :Integer
      optional :options, :Hash do
        optional :name, :String
        optional :active, :Boolean
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

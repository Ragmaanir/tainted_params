describe TaintedParams::ParamsValidator do

  it '' do
    b = TaintedParams::ParamsValidatorBuilder.new do
      required :id, :Integer
      permitted :options, :Hash do
        permitted :name, :String
        permitted :active, :Boolean
      end
    end

    v = b.result

    res = v.validate(id: 1337, unpermitted: 1)

    assert{ res.is_a?(TaintedParams::ValidationResult) }
    assert{ res.valid == {id: 1337} }
    assert{ res.unpermitted == {unpermitted: 1} }
  end

end

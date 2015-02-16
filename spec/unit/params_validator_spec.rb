describe TaintedParams::ParamsValidator do

  it '' do
    val = TaintedParams::ParamsValidatorBuilder.new do
      required :id, :Integer
    end.result

    res = val.validate(id: 1337)

    assert{ res.valid       == {id: 1337} }
    assert{ res.invalid     == {} }
    assert{ res.missing     == {} }
    assert{ res.unpermitted == {} }
  end

  it '' do
    val = TaintedParams::ParamsValidatorBuilder.new do
      required :id, :Integer
    end.result

    res = val.validate(id: '1337')

    assert{ res.valid       == {id: 1337} }
    assert{ res.invalid     == {} }
    assert{ res.missing     == {} }
    assert{ res.unpermitted == {} }
  end

  it '' do
    val = TaintedParams::ParamsValidatorBuilder.new do
      required :id, :Integer
    end.result

    res = val.validate({})

    assert{ res.valid       == {} }
    assert{ res.invalid     == {} }
    assert{ res.missing     == {id: nil} }
    assert{ res.unpermitted == {} }
  end

  it '' do
    val = TaintedParams::ParamsValidatorBuilder.new do
    end.result

    res = val.validate({unpermitted: 'test'})

    assert{ res.valid       == {} }
    assert{ res.invalid     == {} }
    assert{ res.missing     == {} }
    assert{ res.unpermitted == {unpermitted: 'test'} }
  end

  it '' do
    val = TaintedParams::ParamsValidatorBuilder.new do
      required :id, :Integer
      required :age, :Integer
      required :secret, :String
      permitted :options, :Hash do
        permitted :name, :String
        permitted :active, :Boolean
      end
    end.result

    res = val.validate(id: 1337, age: 'lol', unpermitted: 1)

    assert{ res.valid       == { id: 1337       } }
    assert{ res.invalid     == { age: 'lol'     } }
    assert{ res.unpermitted == { unpermitted: 1 } }
    assert{ res.missing     == { secret: nil    } }
  end

end

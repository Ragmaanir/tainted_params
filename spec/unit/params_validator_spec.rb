describe TaintedParams::ParamsValidator do

  it 'puts valid params in the valid-hash' do
    val = TaintedParams::ParamsValidatorBuilder.new do
      required :id, :Integer
    end.result

    res = val.validate(id: 1337)

    assert{ res.valid       == {id: 1337} }
    assert{ res.invalid     == {} }
    assert{ res.missing     == {} }
    assert{ res.unpermitted == {} }
  end

  it 'does type-coercion' do
    val = TaintedParams::ParamsValidatorBuilder.new do
      required :id, :Integer
    end.result

    res = val.validate(id: '1337')

    assert{ res.valid       == {id: 1337} }
    assert{ res.invalid     == {} }
    assert{ res.missing     == {} }
    assert{ res.unpermitted == {} }
  end

  it 'puts invalid params in the invalid-hash' do
    val = TaintedParams::ParamsValidatorBuilder.new do
      required :id, :Integer
    end.result

    res = val.validate(id: 'hundred')

    assert{ res.valid       == {} }
    assert{ res.invalid     == {id: 'hundred'} }
    assert{ res.missing     == {} }
    assert{ res.unpermitted == {} }
  end

  it 'puts missing params in the missing-hash' do
    val = TaintedParams::ParamsValidatorBuilder.new do
      required :id, :Integer
    end.result

    res = val.validate({})

    assert{ res.valid       == {} }
    assert{ res.invalid     == {} }
    assert{ res.missing     == {id: nil} }
    assert{ res.unpermitted == {} }
  end

  it 'puts unpermitted params in the unpermitted-hash' do
    val = TaintedParams::ParamsValidatorBuilder.new do
    end.result

    res = val.validate({unpermitted: 'test'})

    assert{ res.valid       == {} }
    assert{ res.invalid     == {} }
    assert{ res.missing     == {} }
    assert{ res.unpermitted == {unpermitted: 'test'} }
  end

  it 'does not require optional params' do
    val = TaintedParams::ParamsValidatorBuilder.new do
      permitted :id, :Integer
    end.result

    res = val.validate({})

    assert{ res.valid       == { } }
    assert{ res.invalid     == { } }
    assert{ res.unpermitted == { } }
    assert{ res.missing     == { } }
  end

  it 'does not validate hash-contents if not specified' do
    val = TaintedParams::ParamsValidatorBuilder.new do
      permitted :options, :Hash
    end.result

    res = val.validate(options: {anything: 123})

    assert{ res.valid       == { options: { anything: 123 } } }
    assert{ res.invalid     == { } }
    assert{ res.unpermitted == { } }
    assert{ res.missing     == { } }
  end

  it 'does validate sub-hashes if specified' do
    val = TaintedParams::ParamsValidatorBuilder.new do
      permitted :options, :Hash do
        required :id, :Integer
      end
    end.result

    res = val.validate(options: {id: 'lol'})

    assert{ res.valid       == { } }
    assert{ res.invalid     == { options: { id: 'lol' } } }
    assert{ res.unpermitted == { } }
    assert{ res.missing     == { } }
  end

  it 'does not require sub-hash if its optional but contains required params' do
    val = TaintedParams::ParamsValidatorBuilder.new do
      permitted :options, :Hash do
        required :id, :Integer
      end
    end.result

    res = val.validate({})

    assert{ res.valid       == { } }
    assert{ res.invalid     == { } }
    assert{ res.unpermitted == { } }
    assert{ res.missing     == { } }
  end

  it 'it puts valid, invalid, permitted and missing params in sub-hashes in the result' do
    val = TaintedParams::ParamsValidatorBuilder.new do
      required :options, :Hash do
        required :missing, :Integer
        permitted :valid, :Integer
        permitted :invalid, :String
      end
    end.result

    res = val.validate({options: { valid: 1, invalid: 1, unpermitted: 1 } })

    assert{ res.valid       == { options: { valid: 1 } } }
    assert{ res.invalid     == { options: { invalid: 1 } } }
    assert{ res.unpermitted == { options: { unpermitted: 1 } } }
    assert{ res.missing     == { options: { missing: nil } } }
  end

  # it '' do
  #   val = TaintedParams::ParamsValidatorBuilder.new do
  #     required :id, :Integer
  #     required :age, :Integer
  #     required :secret, :String
  #     permitted :options, :Hash do
  #       permitted :name, :String
  #       permitted :active, :Boolean
  #     end
  #   end.result

  #   res = val.validate(id: 1337, age: 'lol', unpermitted: 1)

  #   assert{ res.valid       == { id: 1337       } }
  #   assert{ res.invalid     == { age: 'lol'     } }
  #   assert{ res.unpermitted == { unpermitted: 1 } }
  #   assert{ res.missing     == { secret: nil    } }
  # end

end

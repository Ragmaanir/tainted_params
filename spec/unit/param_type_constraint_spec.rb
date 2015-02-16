describe TaintedParams::ParamTypeConstraint do

  it 'returns the value if it matches the String-type, :error otherwise' do
    c = described_class.new([String])

    assert{ c.call('') == '' }
    assert{ c.call('some string') == 'some string' }
    assert{ c.call(1) == :error }
  end

  it 'returns the value if it matches the Integer-type, :error otherwise' do
    c = described_class.new([Integer])

    assert{ c.call('') == :error }
    assert{ c.call(1337) == 1337 }
    assert{ c.call(1.337) == :error }
  end

  it 'returns the value if it matches Integer OF Float, :error otherwise' do
    c = described_class.new([Integer, Float])

    assert{ c.call('') == :error }
    assert{ c.call(1337) == 1337 }
    assert{ c.call(1.337) == 1.337 }
  end

  it 'returns the value if it is true or false, :error otherwise' do
    c = described_class.new([TrueClass, FalseClass])

    assert{ c.call(true) == true }
    assert{ c.call(false) == false }
    assert{ c.call(1) == :error }
  end

end

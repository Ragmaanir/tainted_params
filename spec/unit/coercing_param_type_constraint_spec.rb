describe TaintedParams::CoercingParamTypeConstraint do

  describe TaintedParams::INTEGER_TYPE_CONSTRAINT do
    it 'attempts to convert strings to integers' do
      c = TaintedParams::INTEGER_TYPE_CONSTRAINT

      assert{ c.call('')      == :error }
      assert{ c.call('-123')  == -123 }
      assert{ c.call(123)     == 123 }
    end
  end

  describe TaintedParams::BOOLEAN_TYPE_CONSTRAINT do
    it 'attempts to convert strings to booleans' do
      c = TaintedParams::BOOLEAN_TYPE_CONSTRAINT

      assert{ c.call('')      == :error }
      assert{ c.call('-123')  == :error }
      assert{ c.call(123)     == :error }

      assert{ c.call('yes')   == true }
      assert{ c.call('1')     == true }
      assert{ c.call('true')  == true }
      assert{ c.call(true)    == true }
    end
  end

end

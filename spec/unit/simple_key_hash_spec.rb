describe TaintedParams::SimpleKeyHash do

  it '' do
    h = described_class.new(symbol: 1, 'string' => 2)
    assert{ h['symbol'] == 1 }
    assert{ h[:string] == 2 }
  end

end

describe TaintedParams::StringKeyHash do

  let(:h) { described_class.new(symbol: 1, 'string' => 2) }

  it '' do
    assert{ h['symbol'] == 1 }
    assert{ h[:string] == 2 }
  end

  it '' do
    h2 = h.merge(newsymbol: 3)
    assert{ h2['newsymbol'] == 3 }
  end

  it '' do
    assert{ h.keys == ['symbol', 'string'] }
  end

end

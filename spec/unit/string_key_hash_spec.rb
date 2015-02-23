describe TaintedParams::StringKeyHash do

  let(:h) { described_class.new(symbol: 1, 'string' => 2) }

  it '#respond_to?' do
    %w{
      fetch [] key? member? include? has_key? shift
      each
      length size empty? any?
      map select reject map collect
      values_at merge keys rassoc dup ==}.each do |meth|
      assert{ h.respond_to?(meth) }
    end
  end

  it '#[]' do
    assert{ h['symbol'] == 1 }
    assert{ h[:string] == 2 }
  end

  it '#each' do
    res = {}
    h.each do |k,v|
      res[k] = v
    end

    assert{ res == {'symbol' => 1, 'string' => 2} }
  end

  it '#select' do
    res = h.select{ |k,v| v > 1 }
    assert{ res == [['string', 2]] }
  end

  it '#map' do
    res = h.map{ |k,v| [k, v + 1] }
    assert{ res == [['symbol', 2], ['string', 3]] }
  end

  it '#values_at' do
    assert{ h.values_at(:symbol, 'string') == [1,2] }
  end

  it '#merge' do
    h2 = h.merge(newsymbol: 3)
    assert{ h2.is_a?(described_class) }
    assert{ h2['newsymbol'] == 3 }
  end

  it '#keys' do
    assert{ h.keys == ['symbol', 'string'] }
  end

  it '#rassoc' do
    assert{ h.rassoc(1) == ['symbol', 1] }
  end

  it '#==' do
    assert{ h == {symbol: 1, 'string' => 2} }
    assert{ h == {'symbol' => 1, 'string' => 2} }
  end

end

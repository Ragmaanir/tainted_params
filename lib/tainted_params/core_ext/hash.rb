class Hash
  def map_pairs
    return enum_for(:map_pairs) unless block_given?

    result = self.class.new
    each do |key, value|
      k, v = *yield(key, value)
      result[k] = v
    end
    result
  end

  # def map_keys
  #   map_pairs do |k, v|
  #     [yield(k), v]
  #   end
  # end

  # def slice(keys)
  #   select{ |k,_| keys.include?(k) }
  # end

  #alias_method :only, :slice

  def except(*keys)
    select{ |k,_| !keys.include?(k) }
  end
end

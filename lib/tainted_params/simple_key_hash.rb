require 'delegate'

module TaintedParams
  class SimpleKeyHash < Hash#< SimpleDelegator

    def self.stringify_keys(hash)
      hash.map_pairs{ |k,v|
        [k.to_s, v]
      }
    end

    def initialize(hash)
      raise ArgumentError unless hash.is_a?(Hash)
      #super(self.class.stringify_keys(hash))
      super()
      update(self.class.stringify_keys(hash))
    end

    def default(key = nil)
      case key
        when String, nil then super
        when Symbol then self[key.to_s]
        else raise ArgumentError
      end
    end

    # def fetch(key, *extras)
    #   super(convert_key(key), *extras)
    # end

    # def values_at(*indices)
    #   indices.collect { |key| self[convert_key(key)] }
    # end

  private

    def convert_key(key)
      case key
        when Symbol then key.to_s
        when String then key
        else raise ArgumentError
      end
    end

  end
end

require 'delegate'
require 'forwardable'

module TaintedParams
  class StringKeyHash# < SimpleDelegator
    extend Forwardable
    include Enumerable

    def self.stringify_keys(hash)
      hash.map_pairs{ |k,v|
        [k.to_s, v]
      }
    end

    def initialize(hash)
      raise ArgumentError unless hash.is_a?(Hash)
      @hash = self.class.stringify_keys(hash).freeze
    end

    def_delegators :@hash, :fetch, :each, :map_pairs, :values_at, :keys, :values

    def [](key)
      @hash[convert_key(key)]
    end

    def merge(hash, &block)
      self.class.new(self.to_hash.merge(hash, &block))
    end

    def dup
      self.class.new(self)
    end

    def to_hash
      @hash
    end

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

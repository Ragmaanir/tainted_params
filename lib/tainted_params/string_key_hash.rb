require 'delegate'
require 'forwardable'

module TaintedParams
  class StringKeyHash# < SimpleDelegator
    extend Forwardable
    include Enumerable

    def self.stringify_keys(hash)
      #hash.map_pairs{ |k,v|
      #  [k.to_s, v]
      #}
      hash.transform_keys do |k|
        k.to_s
      end
    end

    def initialize(hash)
      raise ArgumentError unless hash.is_a?(Hash)
      @hash = self.class.stringify_keys(hash).freeze
    end

    def_delegators :@hash, *%w{
      fetch
      keys values rassoc shift
      each transform_keys
      length size empty?
    }

    def key?(k)
      @hash.key?(convert_key(k))
    end

    alias_method :include?, :key?
    alias_method :has_key?, :key?
    alias_method :member?, :key?

    def [](key)
      @hash[convert_key(key)]
    end

    def values_at(*args)
      args.map{ |k| self[k] }
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

    def ==(other)
      case other
        when Hash then self == self.class.new(other)
        when self.class then to_hash == other.to_hash
        else false
      end
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

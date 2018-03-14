require 'Forwardable'
require './ga_chromosome.rb'

class Bitstring < GAChromosome
  extend Forwardable
  def_delegators :@bits, :size, :each, :[], :[]=, :to_s
  
  def post_initialize(args)
    @bits = Array.new(args[:length], 0)
    
    randomize
  end

  def initialize_copy(origin)
    super

    @bits = origin.bits.clone
  end
  
  def cross_over!(other)
     if (rand < cross_over_prob)
      range = rand(bits.size)..bits.size - 1
           
      bits[range], other[range] = other[range], bits[range]
    end
  end
  
  def mutate!
    bits.map! do |bit|  
      if (rand < mutation_prob)
        bit == 0 ? 1 : 0
      end
    end    
  end
  
  def randomize
    bits.map! { |bit| rand(2) }
  end
  
  def ==(other) 
    return true if other.equal?(self)
    return false unless other.instance_of?(self.class)
    bits == other.bits
  end
  
  def to_a
    bits.clone
  end
  
  protected
    attr_accessor  :bits
end

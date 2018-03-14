require 'set'
require './ga_chromosome.rb'

# A chromosome with discrete values, the order of the values represents the encoding
# As the last item of an ordered sequence is uniquely determined by the other elements, 
# only (length - 1) elements are stored, starting with element 1, i.e. element 0 is not used!
class OrderedChromosome < GAChromosome
  def post_initialize(args)
    @genes = (1..args[:length] - 1).to_a.shuffle!

    print @genes

    @genes
  end

  def initialize_copy(origin)
    super

    @genes = origin.genes.clone
  end
  
  def size
    genes.size + 1
  end
  
  def each
    yield(0)
    
    genes.each { |gene| yield(gene) }
  end
  
  def [](index)
    @genes[index]
  end
  
  def mutate!
    genes.each_index do |index|
      if rand < mutation_prob
        other_gene = rand(genes.size)
        
        genes[index], genes[other_gene] = genes[other_gene], genes[index]
      end
    end
  end
  
  def cross_over!(other)
    if rand < cross_over_prob
      range = select_range
    
      genes[range] = other.subsequence(values_in_range(range))
      other.genes[range] = subsequence(other.values_in_range(range))
    end
  end
  
  def to_a
    [0] + genes.clone
  end
  
  def to_s
    genes.inject('0') { |s, gene| s + gene.to_s }
  end
  
  def ==(other) 
    return true if other.equal?(self)
    return false unless other.instance_of?(self.class)
    genes == other.genes
  end
  
  protected
    attr_accessor :genes
  
    def subsequence(values)
      genes.select { |gene| values.include?(gene) }
    end
  
    def values_in_range(range)
      Set.new(genes[range])
    end
  
    def select_range
      last = rand(1..genes.size - 1)
      first = rand(0..last - 1)
    
      first..last
    end
end

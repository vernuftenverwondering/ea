
# Base class for chromosomes that are constructed using a fixed parameter such as length
class GAChromosome
  attr_accessor :mutation_prob, :cross_over_prob
  
  def initialize(args)
    @mutation_prob = args[:mutation_prob] || defaults[:mutation_prob]
    @cross_over_prob = args[:cross_over_prob] || defaults[:cross_over_prob]
    
    post_initialize(args)
  end
  
  def post_initialize(args)
    raise NotImplementedError
  end
  
  def defaults
    { mutation_prob: 0.1, cross_over_prob: 0.7 }
  end
  
  def recombine(other)
    first_child = self.clone
    second_child = other.clone
    
    first_child.cross_over!(second_child)
    
    first_child.mutate!
    second_child.mutate!
    
    [first_child, second_child]
  end
end

# Factory for fixed length chromosomes as used in Genetic Algorithms
class GA 
  def initialize(chromosome_class, args)
    @chromosome_class = chromosome_class
    @args = args
  end
  
  def create
    [@chromosome_class.new(@args)]
  end
end

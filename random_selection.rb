require './population'

class RandomSelection
  attr_reader :population
  
  def initialize(population)
    @population = population
  end
  
  def select
    population[select_index]
  end
  
  def select_index
    rand(population.size)
  end
end


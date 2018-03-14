class RouletteWheelSelection
  def initialize(population)
    @population = population
    
    cumulative_fitness = 0.0
    
    @wheel = @population.map_fitness do |fitness|
      cumulative_fitness += fitness
    end
    
    normalize(cumulative_fitness)
  end
  
  def select 
    @population[select_index]
  end
  
  def select_index
    fitness = rand 
    wheel.index {|i| i >= fitness}
  end
  
  def normalize(cumulative_fitness)
    wheel.map! do |fitness|
      fitness / cumulative_fitness
    end
    
    wheel[-1] = 1.0;
  end
  
private
  attr_reader :wheel
end

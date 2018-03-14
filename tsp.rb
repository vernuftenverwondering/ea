# simple Travelling Sales Person optimization to demonstrate EA

require './population.rb'
require './chromosome_factory.rb'
require './ordered_chromosome.rb'

class TSP_Fitness

  def initialize(network, multiplication_factor = 1.0, constant_factor = 1.0)
    @network = network
    @multiplication_factor = multiplication_factor
    @constant_factor = constant_factor
  end
  
  def distance(chromosome)
    dist = 0.0
    
    prev = chromosome[-1]
    
    chromosome.each do |gene|
      dist += @network[prev][gene]
      prev = gene
    end

    dist
  end

  def fitness(chromosome)
    @multiplication_factor / (distance(chromosome) + @constant_factor)
  end
end

##### TSP ####################################################################

class TSP
  class TSP_observer
    def update(population)
      puts '********'
      population.each do |chromosome, fitness| 
        print chromosome.to_s, ' : ', fitness, "\n"
      end
      puts
    end
  end

  def initialize(network, number_of_chromosomes, number_of_generations)
    population = Population.new(TSP_Fitness.new(network), GA.new(OrderedChromosome, {length: network.size}), number_of_chromosomes)
    
    population.add_observer(TSP_observer.new)
    
    population.each do |chromosome, fitness| 
      print chromosome.to_s, ' : ', fitness, "\n"
    end

    population.evolve { |p| p.generation == number_of_generations}
    
    print "\n\nresult:",  population.best_chromosome.to_s, "\n"
  end
end


network = [
  [0, 3, 1, 3], 
  [2, 0, 2, 2],
  [2, 3, 0, 2],
  [2, 1, 3, 0]
]

tsp = TSP.new(network, 30, 10)


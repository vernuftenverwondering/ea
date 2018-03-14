require 'observer'
require './recombination.rb'
require './roulette_wheel_selection.rb'


# methods related to initialization and evolution
class Population
  include Observable

  attr_accessor :fitness_function
  attr_reader :generation, :settings

  def initialize(fitness_function = nil, chromosome_factory = nil, size = nil)
    @fitness_function = fitness_function
  
    @chromosomes = []
    @generation = 0
  
    init(chromosome_factory, size) if chromosome_factory
    
    @settings = defaults
    change_settings(chromosome_factory.settings) if chromosome_factory.respond_to?(:settings)
  end
  
  def defaults
    { 
     multiplier: 1, selection_mechanism: RouletteWheelSelection, recombination: PairwiseRecombination,
     number_of_iterations: 100, elitism: 0, combine_generations: false, merge_mechanism: nil
    }
  end
  
  def change_settings(args)
    settings.merge!(args) if args
  end
  
  def init(chromosome_factory, required_size) 
    insert(chromosome_factory.create) until size >= required_size
    
    changed
    notify_observers(self)
  end
  
  def next_generation(args = nil)
    change_settings(args)
  
    multiplier = settings[:multiplier]
    selection_mechanism = settings[:selection_mechanism]
    recombination = settings[:recombination]
    
    new_population = Population.new(fitness_function, recombination.new(selection_mechanism.new(self)), size * multiplier)
    
    merge(new_population)
    @generation += 1
    
    changed
    notify_observers(self)
  end
  
  def evolve(args = nil) 
    change_settings(args)
  
    if block_given?
      next_generation until yield(self)
    else
      number_of_iterations = settings[:number_of_iterations]
      number_of_iterations.times { next_generation }
    end
  end
  
  def merge(other)
    elitism = settings[:elitism]
    combine_generations = settings[:combine_generations]
    merge_mechanism = settings[:merge_mechanism]
  
    chromosomes.sort! unless elitism == 0
    
    if combine_generations
      other.chromosomes.concat(chromosomes[elitism..-1])
      other.sort!
    end
    
    if merge_mechanism 
      merge_by_selection(other, elitism, merge_mechanism)
    else
      merge_by_replacement(other, elitism)
    end
  end
  
  def merge_by_selection(other, offset = 0, selection_mechanism)
    required_size = chromosomes.size
    chromosomes.slice(offset..-1)
    
    selection = selection_mechanism.new(other)
    
    required_size.times do
      index = selection.select_index
      chromosomes.insert_chromosome(other[index], other.fitness(index))
    end
  end
  
  def merge_by_replacement(other, offset = 0)
    chromosomes[offset..-1] = other.chromosomes[0..-1-offset]
  end
end

require 'Forwardable'

# methods related to storage and retrieval of chromosomes
class Population 
  extend Forwardable
  def_delegators :@chromosomes, :size, :empty?, :sort!

  Member = Struct.new(:fitness, :chromosome) do
    include Comparable
  
    def <=>(other)
      other.fitness <=> fitness #sort descending, first is best!
    end
  end
  
  attr_accessor :elitism
  
  def [](index)
    chromosomes[index].chromosome
  end
  
  def fitness(index)
    chromosomes[index].fitness
  end
  
  def best_chromosome
    chromosomes.max_by {|c| c.fitness}.chromosome
  end
  
  def insert(chromosomes)
    chromosomes.each do |chromosome| 
      insert_chromosome(chromosome)
    end
  end
  
  def insert_chromosome(chromosome, fitness_value = nil)
    fitness = fitness_value || fitness_function.fitness(chromosome)

    chromosomes << Member.new(fitness, chromosome)
  end
  
  def each
    chromosomes.each { |member| yield(member.chromosome, member.fitness) }
  end
  
  def each_fitness
    chromosomes.each { |member| yield(member.fitness) }
  end
  
  def map_fitness
    chromosomes.map { |member| yield(member.fitness) }
  end
  
  def inject_fitness(accumulator)
    chromosomes.inject(accumulator) { |accu, member| yield(accu, member.fitness) }
  end
  
  protected
    attr_accessor :chromosomes
end

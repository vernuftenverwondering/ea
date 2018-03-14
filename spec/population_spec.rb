require './population.rb'

describe Population::Member do  
    before :each do
      @member = Population::Member.new(1.0, 1)
    end
    
    it {is_expected.to respond_to(:fitness) }
    it {is_expected.to respond_to(:chromosome) }
    it {is_expected.to respond_to(:<=>) }
  
    it 'holds on to its fitness' do
      expect(@member.fitness).to eql(1.0) 
    end
  
    it 'holds on to its chromosome' do
     expect(@member.chromosome).to eql(1)
    end
end

shared_examples 'Behaves as Evolvable' do
  it { is_expected.to respond_to(:init) }
  it { is_expected.to respond_to(:next_generation) }
  it { is_expected.to respond_to(:evolve) }
  
  it { is_expected.to respond_to(:defaults) }
  
  it { is_expected.to respond_to(:settings) }
  it { is_expected.to respond_to(:change_settings) }
  
  it { is_expected.to respond_to(:merge) }
  
  it { is_expected.to respond_to(:generation) }
  
  it { is_expected.to respond_to(:fitness_function) }
  it { is_expected.to respond_to(:fitness_function=) }
end

shared_examples 'Behaves as Population' do
  it { is_expected.to respond_to(:insert) }
  it { is_expected.to respond_to(:insert_chromosome) }
  
  it { is_expected.to respond_to(:[]) }
  it { is_expected.to respond_to(:fitness) }
  it { is_expected.to respond_to(:best_chromosome) }
  it { is_expected.to respond_to(:size) }
  it { is_expected.to respond_to(:empty?) }
  
  it { is_expected.to respond_to(:each) }
  it { is_expected.to respond_to(:each_fitness) }
  it { is_expected.to respond_to(:map_fitness) }
  it { is_expected.to respond_to(:inject_fitness) }
  
  it { is_expected.to respond_to(:sort!) }
end

describe Population do  
  include_examples 'Behaves as Evolvable'
  include_examples 'Behaves as Population'
  
  describe 'behavior:' do
    before :each do 
      @population = Population.new
    
      @population.insert_chromosome(1, 1.0)
      @population.insert_chromosome(3, 3.1)
      @population.insert_chromosome(2, 2.4)
    end
  
    it 'size equals the number of inserted elements' do
      expect(@population.size).to eq(3)
    end
    
    it 'returns the chromosome at a given index' do
      expect(@population[2]).to eq(2)
    end
    
    it 'returns the fitness of the chromosome at a given index' do
      expect(@population.fitness(2)).to eq(2.4)
    end

    it 'iterates over its members' do
      result = []
      @population.each { |chromosome, fitness| result << chromosome << fitness }
      expect(result).to eq([1, 1.0, 3, 3.1, 2, 2.4])
    end
    
    it 'iterates over the fitness values' do
      expect { |f| @population.each_fitness(&f) }.to yield_successive_args(1.0, 3.1, 2.4)
    end
    
    it 'maps fitness values to an array' do
      result = @population.map_fitness { |f| f * 2}
      expect(result).to eq([2.0, 6.2, 4.8])
    end
    
    it 'accumulates fitness values' do
      result = @population.inject_fitness(0.0) { |accu, fitness|  accu + fitness}
      expect(result).to eq(6.5)
    end
    
    it 'returns the chromosome with the highest fitness' do
      expect(@population.best_chromosome).to eq(3)
    end
    
    it 'sorts its members based on descending fitness' do
      @population.sort!
      expect { |f| @population.each_fitness(&f) }.to yield_successive_args(3.1, 2.4, 1.0)
    end
    
    describe 'merge' do
      before :each do
        new_population = Population.new
        new_population.insert_chromosome(8, 8.1)
        new_population.insert_chromosome(9, 9.2)
        new_population.insert_chromosome(7, 7.3)
        
        @population.merge(new_population)
      end
      
      it 'does not change the number of chromosomes' do
        expect(@population.size).to eq(3)
      end
      
      it 'replaces the old population' do
        expect { |f| @population.each_fitness(&f) }.to yield_successive_args(8.1, 9.2, 7.3)
      end
    end
  end
end

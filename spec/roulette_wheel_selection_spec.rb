require './roulette_wheel_selection.rb'

describe RouletteWheelSelection do
  before :each do
    @population = double('population')
    @population.stub(:map_fitness) do |&arg|
      ary = []
      ary << arg.call(2.0)
      ary << arg.call(1.0)
      ary << arg.call(3.0)
      
      ary
    end 
    
    @selection_mechanism = RouletteWheelSelection.new(@population) 
  end

  specify {expect(@selection_mechanism).to respond_to(:select)}
  specify {expect(@selection_mechanism).to respond_to(:select_index)}
      
  it 'selects an element from the population' do
    @population.stub(:[]).and_return('A')
    expect(@selection_mechanism.select).to eq 'A'
  end
  
  context 'selection' do
    before :each do
      @count = [0, 0, 0]
      @trials = 10000
      
      @trials.times do 
        @count[@selection_mechanism.select_index] += 1
      end
    end
    
    it 'selects indices within [0, population.size)' do
      expect(@count[0] + @count[1] + @count[2]).to eq(@trials) 
    end
  
    describe 'the chance of selection is proportional to the fitness' do
      before :each do
       @count.map! {|c| c / @trials.to_f}
      end
  
      specify { expect(@count[0]).to be_within(0.05).of(0.33) }
      specify { expect(@count[1]).to be_within(0.05).of(0.16) }
      specify { expect(@count[2]).to be_within(0.05).of(0.5) }
    end
  end
end

require './random_selection.rb'

describe RandomSelection do
  let (:population) { %w{a b c d} }
  let (:selection_mechanism) {RandomSelection.new(population)}
  
  subject {selection_mechanism}
  
  it {is_expected.to respond_to(:select)}
  it {is_expected.to respond_to(:select_index)}
  
  it 'selects an element from the population' do
      expect(population).to include(selection_mechanism.select)
  end
  
end

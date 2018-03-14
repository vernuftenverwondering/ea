require './ordered_chromosome.rb'

describe OrderedChromosome do 
  let(:chromosome) { OrderedChromosome.new({length: 10}) }
  
  subject {chromosome}

  it { is_expected.to respond_to(:recombine) }

  it { is_expected.to respond_to(:mutation_prob, :mutation_prob=)}
  it { is_expected.to respond_to(:cross_over_prob, :cross_over_prob=)} 
  it { is_expected.to respond_to(:cross_over!, :mutate!) }
  it { is_expected.to respond_to(:size, :each) }
  it { is_expected.to respond_to(:cross_over!) }
  
  it 'has a size equal to the length specified on initialization' do
    expect(chromosome.size).to eq(10)
  end
  
  describe 'each gene' do
    it 'is an integer label in [0, size) and appears exactly once' do
     expect(chromosome.to_a).to include(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
    end
  end
  
  describe 'a clone' do
    let (:clone) {chromosome.clone} 
  
    it 'has the same content' do
      expect(clone).to eq chromosome
    end
    
    it 'is not the same object' do
      expect(clone).not_to eql chromosome
    end
  end
  
  describe 'recombination' do
    let (:other)  { OrderedChromosome.new({length: 10}) }
    
    before :each do
      @old_chromosome = chromosome.clone
      @old_other = other.clone
    end
    
    describe 'does not change the parents' do
       before :each do         
         chromosome.recombine(other)
       end
       
       specify {expect(chromosome).to eq(@old_chromosome) }
       specify {expect(other).to eq(@old_other) }
    end
    
    describe 'cross-over does result in chromosomes' do   
      before :each do
        chromosome.cross_over!(other)
      end
    
      describe 'with the same size' do
        specify { expect(chromosome.size).to eq(10) }
        specify { expect(other.size).to eq(10) }
      end
    
      specify 'that reuse the same set of genes' do
        old_genes = @old_chromosome.to_a + @old_other.to_a
        new_genes = chromosome.to_a + other.to_a

        old_genes.sort!        
        new_genes.sort!

        
        expect(new_genes).to eq(old_genes)
      end
    end
  end
  
  describe 'mutation' do
    before :each do
      chromosome.mutate!
    end
  
    it 'does not change the number of genes' do
      expect(chromosome.size).to eq(10)
    end
  end
end

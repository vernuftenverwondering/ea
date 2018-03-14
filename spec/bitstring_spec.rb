require './bitstring.rb'

RSpec::Matchers.define :be_binary do 
  match do |bit|
    bit == 1 || bit == 0
  end
end

describe Bitstring do 
  let(:bitstring) { @bitstring = Bitstring.new({length: 10}) }
  
  subject {bitstring}

  it { is_expected.to respond_to(:recombine) }

  it { is_expected.to respond_to(:mutation_prob, :mutation_prob=)}
  it { is_expected.to respond_to(:cross_over_prob, :cross_over_prob=)} 
  it { is_expected.to respond_to(:cross_over!, :mutate!) }
  it { is_expected.to respond_to(:size, :each, :[], :[]=) }
  it { is_expected.to respond_to(:randomize) }
  
  describe "each bit" do
      10.times do |i|
         
         it 'is binary' do
           expect(bitstring[i]).to be_binary
         end
      end
  end
  
   
  describe 'recombination' do
    let (:other)  { Bitstring.new({length: 10}) }
    
    before :each do
      @old_bitstring = bitstring.clone
      @old_other = other.clone
    end
    
    describe 'does not change the parents' do
       before :each do         
         bitstring.recombine(other)
       end
       
       specify {expect(bitstring).to eq(@old_bitstring) }
       specify {expect(other).to eq(@old_other) }
    end
    
    describe 'cross-over does result in chromosomes' do
      before :each do
        bitstring.cross_over!(other)
      end
    
      describe 'with the same size' do
        specify { expect(bitstring.size).to eq(10) }
        specify { expect(other.size).to eq(10) }     
      end
    
      specify 'that reuse the same set of bits' do
        old_bits = @old_bitstring.to_a + @old_other.to_a
        new_bits = bitstring.to_a + other.to_a
        
        old_bits.sort!
        new_bits.sort!
        
        expect(new_bits).to eq(old_bits)
      end
    end
  end
  
  describe 'mutation' do
    before :each do
      bitstring.mutate!
    end
  
    it 'does not change the number of bits' do
      expect(bitstring.size).to eq(10)
    end
  end
end

class PairwiseRecombination
  def initialize(selection)
    @selection = selection
  end

  def create
    x = @selection.select
    x.recombine(@selection.select)
  end
end

class MutationOnly
	def initialize(selection)
		@selection = selection
	end

	def create
		[@selection.select]
	end
end

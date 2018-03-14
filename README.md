# An Evolutionary Algorithms framework for Ruby

Core of the framework is a generic Population class that consists of a set of chromosomes that is evolved.

Different types of chromosomes can be used. The framework currently provides Bitstring, the standard representation of 0 en 1's used in Genetic Algorithms and OrderedChromosome that arranges a fixed number of elements in a particular order. Any class that acts like a chromosome can be used, as long as it also comes with a corresponding chromosome factory (for many cases the default GA chromosome factory will do).

Population is highly configurable. The methods of selection (default: roulette wheel selection), recombination (default: pairwise) and merging of generations (default: replace) can be changed. Elitism can be enabled and the size of the new generation can differ from the size of the old generation.

`Population` requires a fitness function, i.e. an object with a `fitness` method that takes a chromosome as an argument and returns a fitness value.

For an example of a fitness function and the usage of `Population` see `tsp.rb`.




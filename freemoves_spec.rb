require 'rspec'
require_relative 'nfa'
require_relative 'fa_rule'
require 'set'

my_rulebook = NFARulebook.new([
  FARule.new(1, nil, 2), FARule.new(1, nil, 4),
  FARule.new(2, 'a', 3), 
  FARule.new(3, 'a', 2),
  FARule.new(4, 'a', 5),
  FARule.new(5, 'a', 6),
  FARule.new(6, 'a', 4)
  ])

describe NFARulebook do
  describe "#next_states" do
    it "{1} -- nil --> {2, 4}" do
      expect(my_rulebook.next_states(Set[1], nil)).to eq Set[2, 4]
    end 
  end
  describe "#follow_free_moves" do
    it "{1} -- free moves --> {1, 2, 4}" do
      expect(my_rulebook.follow_free_moves(Set[1])).to eq Set[1, 2, 4]
    end    
  end
end
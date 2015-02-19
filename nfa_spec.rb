require 'rspec'
require_relative 'nfa'
require_relative 'fa_rule'
require 'set'

my_rulebook = NFARulebook.new([
 FARule.new(1, 'a', 1), FARule.new(1, 'b', 1), FARule.new(1, 'b', 2),
 FARule.new(2, 'a', 3), FARule.new(2, 'b', 3),
 FARule.new(3, 'a', 4), FARule.new(3, 'b', 4)
])

describe NFARulebook do
  context "with my_rulebook" do
    it "next states for {1} with 'b' are {1, 2}" do
      expect(my_rulebook.next_states(Set[1], 'b')).to eq Set[1, 2]
    end

    it "next states for {1, 2} with 'a' is {1, 3}" do
      expect(my_rulebook.next_states(Set[1, 2], 'a')).to eq Set[1, 3]
    end

    it "next states for {1, 3} with 'b' is {1, 2, 4}" do
      expect(my_rulebook.next_states(Set[1, 3], 'b')).to eq Set[1, 2, 4]
    end

  end 
end

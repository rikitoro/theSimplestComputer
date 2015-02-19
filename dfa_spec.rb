require 'rspec'
require_relative 'dfa'

my_rulebook = DFARulebook.new([
 FARule.new(1, 'a', 2), FARule.new(1, 'b', 1),
 FARule.new(2, 'a', 2), FARule.new(2, 'b', 3),
 FARule.new(3, 'a', 3), FARule.new(3, 'b', 3)
])

describe DFARulebook do
  context "with my_rulebook" do
    it "next state of 1 with 'a' is 2" do
      expect(my_rulebook.next_state(1, 'a')).to eq 2
    end

    it "next state of 1 with 'b' is 1" do
      expect(my_rulebook.next_state(1, 'b')).to eq 1
    end

    it "next state of 2 with 'b' is 3" do
      expect(my_rulebook.next_state(2, 'b')).to eq 3
    end
  end 
end

describe DFA do
  context "with my_rulebook" do
    describe "#accepting?" do
      it "return true when the current state is included in the accept states" do |variable|
        expect(DFA.new(1, [1, 3], my_rulebook).accepting?).to eq true
      end

      it "return false when the current state is NOT included in the accept states" do |variable|
        expect(DFA.new(1, [3], my_rulebook).accepting?).to eq false
      end
    end
  end
end
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
        expect(DFA.new(1, [1, 3], my_rulebook)).to be_accepting
      end

      it "return false when the current state is NOT included in the accept states" do |variable|
        expect(DFA.new(1, [3], my_rulebook)).not_to be_accepting
      end
    end

    describe "#read_character" do
      context "dfa with initial state is 1, accect states are [3]" do
        it "with no characters, not to be accepting" do
          dfa = DFA.new(1, [3], my_rulebook)
          expect(dfa).not_to be_accepting
        end

        it "after read_character 'b', NOT to be accepting" do
          dfa = DFA.new(1, [3], my_rulebook)
          dfa.read_character('b')
          expect(dfa).not_to be_accepting        
        end

        it "after read_character 'b', 'a', 'a', 'a', NOT to be accepting" do
          dfa = DFA.new(1, [3], my_rulebook)
          dfa.read_character('b')
          3.times { dfa.read_character('a') }
          expect(dfa).not_to be_accepting        
        end

        it "after read_character 'b', 'a', 'a', 'a', 'b', to be accepting" do
          dfa = DFA.new(1, [3], my_rulebook)
          dfa.read_character('b')
          3.times { dfa.read_character('a') }
          dfa.read_character('b')
          expect(dfa).to be_accepting        
        end
      end
    end

    describe "#read_string" do
      context "dfa with initial state is 1, accect states are [3]" do
        it "dfa NOT accept ''" do
          dfa = DFA.new(1, [3], my_rulebook)
          expect(dfa).not_to be_accepting
        end

        it "dfa accepts 'baaab'" do
          dfa = DFA.new(1, [3], my_rulebook)
          dfa.read_string('baaab')
          expect(dfa).to be_accepting
        end
      end       
    end
  end
end
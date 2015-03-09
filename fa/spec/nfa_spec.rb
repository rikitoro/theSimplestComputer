require 'rspec'
require_relative '../nfa'
require_relative '../fa_rule'
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

describe NFA do
  context "with my_rulebook" do
    describe "#accepting?" do
      it "when any current states are NOT included in accept states, NOT to be accepting" do |variable|
        expect(NFA.new(Set[1], [4], my_rulebook)).not_to be_accepting
      end

      it "when sme current states are NOT included in accept states, NOT to be accepting" do |variable|
        expect(NFA.new(Set[1, 2, 4], [4], my_rulebook)).to be_accepting
      end      
    end

    describe "#read_character" do
      context "a set of initial states is {1}, accect states is {4}" do
        it "with no characters, not to be accepting" do
          nfa = NFA.new(Set[1], [4], my_rulebook)
          expect(nfa).not_to be_accepting
        end

        it "after read_character 'b', NOT to be accepting" do
          nfa = NFA.new(Set[1], [4], my_rulebook)
          nfa.read_character('b')
          expect(nfa).not_to be_accepting        
        end

        it "after read_character 'b', 'a', NOT to be accepting" do
          nfa = NFA.new(Set[1], [4], my_rulebook)
          nfa.read_character('b')
          nfa.read_character('a')
          expect(nfa).not_to be_accepting        
        end

        it "after read_character 'b', 'a', 'b', to be accepting" do
          nfa = NFA.new(Set[1], [4], my_rulebook)
          nfa.read_character('b')
          nfa.read_character('a')
          nfa.read_character('b')
          expect(nfa).to be_accepting        
        end
      end
    end

    describe "#read_string" do
      context "a set of initial states is {1}, accect states is {4}" do
        it "NOT accept ''" do
          nfa = NFA.new(Set[1], [4], my_rulebook)
          expect(nfa).not_to be_accepting
        end

        it "NOT accept 'aabb'" do
          nfa = NFA.new(Set[1], [4], my_rulebook)
          nfa.read_string('aabb')
          expect(nfa).not_to be_accepting
        end

        it "accept 'bbbbba'" do
          nfa = NFA.new(Set[1], [4], my_rulebook)
          nfa.read_string('bbbbba')
          expect(nfa).to be_accepting
        end        
      end       
    end
  end
end

describe NFADesign do
  context "with my_rulebook" do
    context "start state is 1, and accept states are {4}" do
      it "NOT to accept 'bbabb'" do
        nfa_design = NFADesign.new(1, [4], my_rulebook)
        expect(nfa_design).not_to be_accepts('bbabb')
      end

      it "accept 'bbbbb'" do
        nfa_design = NFADesign.new(1, [3], my_rulebook)
        expect(nfa_design).to be_accepts('bbbbb')
      end

      it "accept 'bab'" do
        nfa_design = NFADesign.new(1, [4], my_rulebook)
        expect(nfa_design).to be_accepts('bab')
      end
    end
  end
end
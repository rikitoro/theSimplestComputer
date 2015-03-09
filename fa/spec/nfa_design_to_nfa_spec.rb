require 'rspec'

require_relative '../nfa'
require_relative '../fa_rule'

rulebook = NFARulebook.new([
  FARule.new(1, 'a', 1), FARule.new(1, 'a', 2), FARule.new(1, nil, 2),
  FARule.new(2, 'b', 3),
  FARule.new(3, 'b', 1), FARule.new(3, nil, 2)
])

describe NFADesign do
  context "with rulebook" do
    describe "#to_nfa" do
      before do
        @nfa_design = NFADesign.new(1, [3], rulebook)
      end

      it "with default args, current_states -> {1, 2}" do
        expect(@nfa_design.to_nfa.current_states).to eq Set[1, 2]
      end

      it "with {2}, current_states -> {2}" do
        expect(@nfa_design.to_nfa(Set[2]).current_states).to eq Set[2]
      end

      it "with {3}, current_states -> {2, 3}" do
        expect(@nfa_design.to_nfa(Set[3]).current_states).to eq Set[2, 3]
      end

      it "with {2, 3}, read_character 'b', then current_states -> {1, 2, 3}" do
        nfa = @nfa_design.to_nfa(Set[2, 3])
        nfa.read_character('b')
        expect(nfa.current_states).to eq Set[1, 2, 3]
      end
    end
  end
end
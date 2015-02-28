require 'rspec'

require_relative 'nfa_simulation'
require_relative 'nfa'
require_relative 'fa_rule'

rulebook = NFARulebook.new([
  FARule.new(1, 'a', 1), FARule.new(1, 'a', 2), FARule.new(1, nil, 2),
  FARule.new(2, 'b', 3),
  FARule.new(3, 'b', 1), FARule.new(3, nil, 2)
])

nfa_design = NFADesign.new(1, [3], rulebook)

describe NFASimulation do
  context "with rulebook" do
    describe "#next_state" do
      before do
        @simulation = NFASimulation.new(nfa_design)
      end

      it "{1, 2} -- 'a' --> {1, 2}" do
        expect(@simulation.next_state(Set[1, 2], 'a')).to eq Set[1, 2] 
      end

      it "{1, 2} -- 'b' --> {2, 3}" do
        expect(@simulation.next_state(Set[1, 2], 'b')).to eq Set[2, 3]         

      end

      it "{3, 2} -- 'b' --> {1, 2, 3}" do
        expect(@simulation.next_state(Set[3, 2], 'b')).to eq Set[1, 2, 3]         
      end

      it "{2, 3} -- 'a' --> {}" do
        expect(@simulation.next_state(Set[2, 3], 'a')).to eq Set[]         
      end

      it "{1, 2, 3} -- 'b' --> {1, 2, 3}" do
        expect(@simulation.next_state(Set[1, 2, 3], 'b')).to eq Set[1, 2, 3]         
      end

      it "{1, 2, 3} -- 'a' --> {1, 2}" do
        expect(@simulation.next_state(Set[1, 2, 3], 'b')).to eq Set[1, 2, 3]         
      end
    end    
  end
end
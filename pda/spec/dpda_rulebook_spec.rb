require 'rspec/given'
require_relative '../pda_rule'
require_relative '../dpda'
require_relative '../stack'

describe DPDARulebook do
  Given(:rulebook) {
    DPDARulebook.new([
      PDARule.new(1, '(', 2, '$', ['b', '$']),
      PDARule.new(2, '(', 2, 'b', ['b', 'b']),
      PDARule.new(2, ')', 2, 'b', []),
      PDARule.new(2, nil, 1, '$', ['$']),      
      ])
  }

  describe "#next_configulation" do
    Given(:configulation) { PDAConfigulation.new(1, Stack.new(['$'])) }

    When(:first_next_configulation) { rulebook.next_configulation(configulation, '(') }
    Then { first_next_configulation.state == 2 }
    Then { first_next_configulation.stack.top == 'b'}
    Then { first_next_configulation.stack.pop.top == '$'}

    When(:second_next_configulation) { rulebook.next_configulation(first_next_configulation, '(') }
    Then { second_next_configulation.state == 2 }
    Then { second_next_configulation.stack.top == 'b' }
    Then { second_next_configulation.stack.pop.top == 'b' }
    Then { second_next_configulation.stack.pop.pop.top == '$' }

    When(:third_next_configulation) { rulebook.next_configulation(second_next_configulation, ')') }
    Then { third_next_configulation.state == 2 }
    Then { third_next_configulation.stack.top == 'b' }
    Then { third_next_configulation.stack.pop.top == '$' }    
  end

  describe "#follow_free_moves" do
    Given(:configulation) { PDAConfigulation.new(2, Stack.new(['$'])) }
    When(:configulation_by_free) { rulebook.follow_free_moves(configulation) }
    Then { configulation_by_free.state == 1}
    Then { configulation_by_free.stack.top == '$'}    
  end
end
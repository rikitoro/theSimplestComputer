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

  describe "#next_configuration" do
    Given(:configuration) { PDAConfiguration.new(1, Stack.new(['$'])) }

    When(:first_next_configuration) { rulebook.next_configuration(configuration, '(') }
    Then { first_next_configuration.state == 2 }
    Then { first_next_configuration.stack.top == 'b'}
    Then { first_next_configuration.stack.pop.top == '$'}

    When(:second_next_configuration) { rulebook.next_configuration(first_next_configuration, '(') }
    Then { second_next_configuration.state == 2 }
    Then { second_next_configuration.stack.top == 'b' }
    Then { second_next_configuration.stack.pop.top == 'b' }
    Then { second_next_configuration.stack.pop.pop.top == '$' }

    When(:third_next_configuration) { rulebook.next_configuration(second_next_configuration, ')') }
    Then { third_next_configuration.state == 2 }
    Then { third_next_configuration.stack.top == 'b' }
    Then { third_next_configuration.stack.pop.top == '$' }    
  end

  describe "#follow_free_moves" do
    Given(:configuration) { PDAConfiguration.new(2, Stack.new(['$'])) }
    When(:configuration_by_free) { rulebook.follow_free_moves(configuration) }
    Then { configuration_by_free.state == 1}
    Then { configuration_by_free.stack.top == '$'}    
  end
end
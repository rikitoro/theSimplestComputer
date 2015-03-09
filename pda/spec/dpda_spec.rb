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
  Given(:dpda) { DPDA.new(PDAConfigulation.new(1, Stack.new(['$'])), [1], rulebook)}

  describe "initial state" do
    Then { dpda.accepting? == true }
  end

  describe "after read_string '(()'" do
    When { dpda.read_string('(()') }
    Then { dpda.accepting? == false }
    Then { dpda.current_configulation.state == 2}
    Then { dpda.current_configulation.stack.top == 'b'}
    Then { dpda.current_configulation.stack.pop.top == '$'}
  end
end
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

  subject(:subject) { DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook) }

  context "initial state" do
    Then { subject.accepting? == true }
  end

  context "after read_string '(()'" do
    When { subject.read_string('(()') }
    Then { subject.accepting? == false }
    Then { subject.current_configuration.state == 2}
    Then { subject.current_configuration.stack.top == 'b'}
    Then { subject.current_configuration.stack.pop.top == '$'}
  end

  context "after read_string '(()('" do
    When { subject.read_string('(()(') }
    Then { subject.accepting? == false }
    Then { subject.current_configuration.state == 2}
    Then { subject.current_configuration.stack.top == 'b'}
    Then { subject.current_configuration.stack.pop.top == 'b'}
    Then { subject.current_configuration.stack.pop.pop.top == '$'}
  end

  context "after read_string '()()'" do
    When { subject.read_string('()()') }
    Then { subject.accepting? == true }
    Then { subject.current_configuration.state == 1}
    Then { subject.current_configuration.stack.top == '$'}
  end

end
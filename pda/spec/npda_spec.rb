require 'rspec/given'
require_relative '../npda'
require_relative '../npda_rulebook'
require_relative '../pda_rule'
require_relative '../stack'

describe NPDA do
  Given(:rulebook) {
    NPDARulebook.new([
      PDARule.new(1, 'a', 1, '$', ['a', '$']),
      PDARule.new(1, 'a', 1, 'a', ['a', 'a']),
      PDARule.new(1, 'a', 1, 'b', ['a', 'b']),
      PDARule.new(1, 'b', 1, '$', ['b', '$']),
      PDARule.new(1, 'b', 1, 'a', ['b', 'a']),
      PDARule.new(1, 'b', 1, 'b', ['b', 'b']),
      PDARule.new(1, nil, 2, '$', ['$']),
      PDARule.new(1, nil, 2, 'a', ['a']),
      PDARule.new(1, nil, 2, 'b', ['b']),
      PDARule.new(2, 'a', 2, 'a', []),
      PDARule.new(2, 'b', 2, 'b', []),
      PDARule.new(2, nil, 3, '$', ['$']),
    ])
  }
  Given(:configuration) { PDAConfiguration.new(1, Stack.new(['$'])) }

  subject(:subject) { NPDA.new(Set[configuration], [3], rulebook) }

  context "initial state" do
    Then { subject.accepting? == true }
  end

  context "after read_string 'abb'" do
    When { subject.read_string('abb') }
    Then { subject.accepting? == false }
  end

  context "after read_string 'abb' and read_character 'a'" do
    When { subject.read_string('abb') }
    When { subject.read_character('a') } 
    Then { subject.accepting? == true }   
  end
end
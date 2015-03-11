require 'rspec/given'
require_relative '../pda_rule'
require_relative '../stack'

describe PDARule do
  Given(:rule) { PDARule.new(1, '(', 2, '$', ['b', '$']) }
  Given(:configuration1) { PDAconfiguration.new(1, Stack.new(['$'])) }
  Given(:configuration2) { PDAconfiguration.new(1, Stack.new(['b', '$'])) }
  describe "#applies_to?" do
    Then { rule.applies_to?(configuration1, '(') == true }
    Then { rule.applies_to?(configuration1, ')') == false }
    Then { rule.applies_to?(configuration2, '(') == false }    
  end

  describe "#follow" do
    When(:next_configuration) { rule.follow(configuration1) } 
    Then { next_configuration.stack.top == 'b' } 
    Then { next_configuration.stack.pop.top == '$' }  
  end

end
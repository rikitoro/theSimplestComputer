require 'rspec/given'
require_relative '../pda_rule'
require_relative '../stack'

describe PDARule do
  Given(:rule) { PDARule.new(1, '(', 2, '$', ['b', '$']) }
  Given(:configulation1) { PDAConfigulation.new(1, Stack.new(['$'])) }
  Given(:configulation2) { PDAConfigulation.new(1, Stack.new(['b', '$'])) }
  describe "#applies_to?" do
    Then { rule.applies_to?(configulation1, '(') == true }
    Then { rule.applies_to?(configulation1, ')') == false }
    Then { rule.applies_to?(configulation2, '(') == false }    
  end

  describe "#follow" do
    When(:next_configulation) { rule.follow(configulation1) } 
    Then { next_configulation.stack.top == 'b' } 
    Then { next_configulation.stack.pop.top == '$' }  
  end

end
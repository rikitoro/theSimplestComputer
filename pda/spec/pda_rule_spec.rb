require 'rspec/given'
require_relative '../pda_rule'
require_relative '../stack'

describe PDARule do
  Given(:rule) { PDARule.new(1, '(', 2, '$', ['b', '$']) }
  
  When(:configulation1) { PDAConfigulation.new(1, Stack.new(['$'])) }
  Then { rule.applies_to?(configulation1, '(') == true }
  Then { rule.applies_to?(configulation1, ')') == false }

  When(:configulation2) { PDAConfigulation.new(1, Stack.new(['b', '$'])) }
  Then { rule.applies_to?(configulation2, '(') == false }
  
end
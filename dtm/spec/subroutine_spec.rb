require 'rspec/given'
require_relative '../dtm'
require_relative '../tm_configuration'
require_relative '../tape'
require_relative '../dtm_rulebook'
require_relative '../tm_rule'


def increment_rules(start_state, return_state)
  incrementing = start_state
  finishing = Object.new
  finished = return_state

  [
    TMRule.new(incrementing, '0', finishing,    '1', :right),
    TMRule.new(incrementing, '1', incrementing, '0', :left),
    TMRule.new(incrementing, '_', finishing,    '1', :right),
    TMRule.new(finishing,    '0', finishing,    '0', :right),
    TMRule.new(finishing,    '1', finishing,    '1', :right),
    TMRule.new(finishing,    '_', finished,     '_', :left)
  ]
end


describe DTM do
  Given(:added_zero)  { 0 }
  Given(:added_one)   { 1 }
  Given(:added_two)   { 2 }
  Given(:added_three) { 3 }

  Given(:rulebook) {
    DTMRulebook.new(
      increment_rules(added_zero, added_one) +
      increment_rules(added_one, added_two) +
      increment_rules(added_two, added_three)
    )
  }
  Given(:tape) { Tape.new(['1', '0', '1'], '1', [], '_')}

  subject(:subject) { 
    DTM.new(TMConfiguration.new(added_zero, tape), [added_three], rulebook) }
 
  context "initial state" do
    Then { subject.current_configuration.tape.inspect == "#<Tape 101(1)>"}
  end

  context "after run" do
    When { subject.run }
    Then { subject.current_configuration.tape.inspect == "#<Tape 111(0)_>"}
  end

end
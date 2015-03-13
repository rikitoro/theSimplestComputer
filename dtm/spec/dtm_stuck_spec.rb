require 'rspec/given'
require_relative '../dtm'
require_relative '../tm_configuration'
require_relative '../tape'
require_relative '../dtm_rulebook'
require_relative '../tm_rule'

describe DTM do

  Given(:rulebook) {
    DTMRulebook.new([
      TMRule.new(1, '0', 2, '1', :right),
      TMRule.new(1, '1', 1, '0', :left),
      TMRule.new(1, '_', 2, '1', :right),
      TMRule.new(2, '0', 2, '0', :right),
      TMRule.new(2, '1', 2, '1', :right),
      TMRule.new(2, '_', 3, '_', :left)
    ])
  }  
  subject(:subject) { DTM.new(TMConfiguration.new(1, tape), [3], rulebook) }

  context "for invalid input(tape), after run" do
    When(:tape) { Tape.new(['1', '2', '1'], '1', [], '_') }
    When { subject.run }
    Then { subject.current_configuration.state == 1 }
    Then { subject.current_configuration.tape.inspect == "#<Tape 1(2)00>"}
    Then { subject.accepting? == false }
    Then { subject.stuck? }
  end
end
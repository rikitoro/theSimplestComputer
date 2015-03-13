require 'rspec/given'
require_relative '../dtm'
require_relative '../tm_configuration'
require_relative '../tape'
require_relative '../dtm_rulebook'
require_relative '../tm_rule'

describe DTM do

  Given(:tape) { Tape.new(['1', '0', '1'], '1', [], '_') }
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

  context "initial state" do
    Then { subject.current_configuration.state == 1 }
    Then { subject.current_configuration.tape.inspect == "#<Tape 101(1)>"}
    Then { subject.accepting? == false }
  end

  context "after one step" do
    When { subject.step }
    Then { subject.current_configuration.state == 1 }
    Then { subject.current_configuration.tape.inspect == "#<Tape 10(1)0>"}
    Then { subject.accepting? == false }
  end

  context "after run" do
    When { subject.run }
    Then { subject.current_configuration.state == 3 }
    Then { subject.current_configuration.tape.inspect == "#<Tape 110(0)_>"}
    Then { subject.accepting? == true }    
  end
end
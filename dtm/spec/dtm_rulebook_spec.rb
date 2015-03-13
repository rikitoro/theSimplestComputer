require 'rspec/given'
require_relative '../dtm_rulebook'
require_relative '../tm_rule'
require_relative '../tape'
describe DTMRulebook do
  subject(:subject) { 
    DTMRulebook.new([
      TMRule.new(1, '0', 2, '1', :right),
      TMRule.new(1, '1', 1, '0', :left),
      TMRule.new(1, '_', 2, '1', :right),
      TMRule.new(2, '0', 2, '0', :right),
      TMRule.new(2, '1', 2, '1', :right),
      TMRule.new(2, '_', 3, '_', :left)
    ])
  }
  Given(:tape) { Tape.new(['1', '0', '1'], '1', [], '_') }
  Given(:configuration) { TMConfiguration.new(1, tape)}

  context "first next configuration" do
    When(:configuration1) { subject.next_configuration(configuration) }
    Then { configuration1.state == 1 }
    Then { configuration1.tape.inspect == "#<Tape 10(1)0>" }
  end

  context "2nd next configuration" do
    When(:configuration2) { 
      c = subject.next_configuration(configuration)
      subject.next_configuration(c)
    }
    Then { configuration2.state == 1 }
    Then { configuration2.tape.inspect == "#<Tape 1(0)00>" }
  end

  context "3rd next configuration" do
    When(:configuration3) { 
      c = subject.next_configuration(configuration)
      c = subject.next_configuration(c)
      subject.next_configuration(c)
    }
    Then { configuration3.state == 2 }
    Then { configuration3.tape.inspect == "#<Tape 11(0)0>" }
  end

end
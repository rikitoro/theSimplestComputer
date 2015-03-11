require 'rspec/given'
require_relative '../dpda_design'

describe DPDADesign do
  Given(:rulebook) {
    DPDARulebook.new([
      PDARule.new(1, 'a', 1, '$', ['a', '$']),
      PDARule.new(1, 'a', 1, 'a', ['a', 'a']),
      PDARule.new(1, 'a', 1, 'b', ['a', 'b']),
      PDARule.new(1, 'b', 1, '$', ['b', '$']),
      PDARule.new(1, 'b', 1, 'a', ['b', 'a']),
      PDARule.new(1, 'b', 1, 'b', ['b', 'b']),
      PDARule.new(1, 'm', 2, '$', ['$']),
      PDARule.new(1, 'm', 2, 'a', ['a']),
      PDARule.new(1, 'm', 2, 'b', ['b']),
      PDARule.new(2, 'a', 2, 'a', []),
      PDARule.new(2, 'b', 2, 'b', []),
      PDARule.new(2, nil, 3, '$', ['$'])
    ])
  }

  subject(:subject) { DPDADesign.new(1, '$', [3], rulebook) }

  Then { subject.accepts?('abmba') == true }
  Then { subject.accepts?('babbamabbab') == true }
  Then { subject.accepts?('abmb') == false }
  Then { subject.accepts?('baambaa') == false }

end
require 'rspec/given'
require_relative '../dpda_design'

describe DPDADesign do
  Given(:rulebook) {
    DPDARulebook.new([
      PDARule.new(1, '(', 2, '$', ['b', '$']),
      PDARule.new(2, '(', 2, 'b', ['b', 'b']),
      PDARule.new(2, ')', 2, 'b', []),
      PDARule.new(2, nil, 1, '$', ['$']),      
      ])
  }

  subject(:subject) { DPDADesign.new(1, '$', [1], rulebook) }

  Then { subject.accepts?('(((((((((())))))))))') == true }
  Then { subject.accepts?('()(())((()))(()(()))') == true }
  Then { subject.accepts?('(()(()(()()(()()))()') == false }

  Then { subject.accepts?('())') == false }
end
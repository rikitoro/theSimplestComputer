require 'rspec/given'
require_relative '../lexical_analyzer'

describe LexicalAnalyzer do
  subject(:subject) { LexicalAnalyzer.new(simple_code) }
  describe "#analyze" do
    context "y = x * 7" do
      When(:simple_code) { 'y = x * 7' }
      Then { subject.analyze == ['v', '=', 'v', '*', 'n'] }
    end
    context "while (x < 5) { x = x * 3 }" do
      When(:simple_code) { 'while (x < 5) { x = x * 3 }' }
      Then { subject.analyze == ['w', '(', 'v', '<', 'n', ')', 
        '{', 'v', '=', 'v', '*', 'n', '}'] }
    end
    context "if ( x < 10) { y = true; x = 0 } else { do-nothing }" do
      When(:simple_code) { 'if ( x < 10) { y = true; x = 0 } else { do-nothing }' }      
      Then { subject.analyze == ['i', '(', 'v', '<', 'n', ')', 
        '{', 'v', '=', 'b', ';', 'v', '=', 'n', '}',
        'e', '{', 'd', '}'] }
    end
  end
end
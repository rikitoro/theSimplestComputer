require 'rspec/given'
require_relative '../pda_rule'
require_relative '../lexical_analyzer'
require_relative '../npda_rulebook'
require_relative '../npda_design'

describe "recognizing valid programs" do
  Given(:start_rule) { PDARule.new(1, nil, 2, '$', ['S', '$']) }
  Given(:symbol_rules) {
    [
      # <statement> ::= <while> | <assign>
      PDARule.new(2, nil, 2, 'S', ['W']),
      PDARule.new(2, nil, 2, 'S', ['A']),
      # <while> ::= 'w' '(' <expression> ')' '{' <statement> '}'
      PDARule.new(2, nil, 2, 'W', ['w', '(', 'E', ')', '{', 'S', '}']),
      # <assign> ::= 'v' '=' <expression>
      PDARule.new(2, nil, 2, 'A', ['v', '=', 'E']),
      # <expression> ::= <less-than>
      PDARule.new(2, nil, 2, 'E', ['L']),
      # <less-than> ::= <multiply> '<' <less-than> | <multiply>
      PDARule.new(2, nil, 2, 'L', ['M', '<', 'L']),
      PDARule.new(2, nil, 2, 'L', ['M']),
      # <multiply> ::= <term> '*' <multiply> | <term>
      PDARule.new(2, nil, 2, 'M', ['T', '*', 'M']),
      PDARule.new(2, nil, 2, 'M', ['T']),
      # <term> ::= 'n' | 'v'
      PDARule.new(2, nil, 2, 'T', ['n']),
      PDARule.new(2, nil, 2, 'T', ['v'])
    ]
  }
  Given(:token_rules) { 
    LexicalAnalyzer::GRAMMAR.map { |rule| 
      PDARule.new(2, rule[:token], 2, rule[:token], [])
    }
  }
  Given(:stop_rule) { PDARule.new(2, nil, 3, '$', ['$']) }
  Given(:rulebook) {
    NPDARulebook.new([start_rule, stop_rule] + symbol_rules + token_rules)
  }

  subject(:subject) { NPDADesign.new(1, '$', [3], rulebook) }

  context "valid program" do
    When(:valid_token_string) { 
      LexicalAnalyzer.new('while (x < 5) { x = x * 3 }').analyze.join
    }
    Then { subject.accepts?(valid_token_string) == true }
  end

  context "invalid program" do
    When(:invalid_token_string) {
      LexicalAnalyzer.new('while (x < 5 x = x * 3}').analyze.join
    }
    Then { subject.accepts?(invalid_token_string) == false }
  end
end
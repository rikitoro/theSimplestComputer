require 'rspec/given'
require_relative '../dtm'
require_relative '../tm_configuration'
require_relative '../tape'
require_relative '../dtm_rulebook'
require_relative '../tm_rule'

describe DTM do
  Given(:rulebook) {
    DTMRulebook.new([
      # state 1: scan right looking for a
      TMRule.new(1, 'X', 1, 'X', :right), # skip X
      TMRule.new(1, 'a', 2, 'X', :right), # cross out a, go to state 2
      TMRule.new(1, '_', 6, '_', :left),  # find blank, go to state 6 (accept)

      # state 2: scan right looking for b
      TMRule.new(2, 'a', 2, 'a', :right), # skip a
      TMRule.new(2, 'X', 2, 'X', :right), # skip X
      TMRule.new(2, 'b', 3, 'X', :right), # cross out b, go to state 3

      # state 3: scan right looking for c
      TMRule.new(3, 'b', 3, 'b', :right), # skip b
      TMRule.new(3, 'X', 3, 'X', :right), # skip X
      TMRule.new(3, 'c', 4, 'X', :right), # cross out c, go to state 3

      # state 4: scan right looking for end of string
      TMRule.new(4, 'c', 4, 'c', :right), # skip c
      TMRule.new(4, '_', 5, '_', :left),  # find blank, go to state 5

      # state 5: scan left looking for beginning of string
      TMRule.new(5, 'a', 5, 'a', :left),  # skip a
      TMRule.new(5, 'b', 5, 'b', :left),  # skip b
      TMRule.new(5, 'c', 5, 'c', :left),  # skip c
      TMRule.new(5, 'X', 5, 'X', :left),  # skip c
      TMRule.new(5, '_', 1, '_', :right), # find blank, go to state 1
    ])
  }


  subject(:subject) { DTM.new(TMConfiguration.new(1, tape), [6], rulebook) }
  context "For tape aaabbbccc" do
    When(:tape) { Tape.new([], 'a', ['a', 'a', 'b', 'b', 'b', 'c', 'c', 'c'], '_')}

    context "after 10 steps" do
      When { 10.times { subject.step} }
      Then { subject.current_configuration.state == 5 }
      Then { subject.current_configuration.tape.inspect == "#<Tape XaaXbbXc(c)_>" }
    end
    
    context "after 35 steps" do
      When { 35.times { subject.step} }
      Then { subject.current_configuration.state == 5 }
      Then { subject.current_configuration.tape.inspect == "#<Tape _XXa(X)XbXXc_>" }
    end

    context "after run" do
      When { subject.run }
      Then { subject.current_configuration.state == 6 }
      Then { subject.current_configuration.tape.inspect == "#<Tape _XXXXXXXX(X)_>" }
      Then { subject.accepting? == true }
    end
  end

  context "For tape aaabbbbccc" do
    When(:tape) { Tape.new([], 'a', ['a', 'a', 'b', 'b', 'b', 'b', 'c', 'c', 'c'], '_')}
    context "after run" do
      When { subject.run }
      Then { subject.accepting? == false }
      Then { subject.stuck? == true }
    end   
  end
end
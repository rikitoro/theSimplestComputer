# copy a character from the beginning of a string to the end

require 'rspec/given'
require_relative '../dtm'
require_relative '../tm_configuration'
require_relative '../tape'
require_relative '../dtm_rulebook'
require_relative '../tm_rule'

describe DTM do
  Given(:rulebook) {
    DTMRulebook.new([
      # state 1: read the first character from the tape
      TMRule.new(1, 'a', 2, 'a', :right), # remenber a
      TMRule.new(1, 'b', 3, 'b', :right), # remenber b
      TMRule.new(1, 'c', 4, 'c', :right), # remenber c

      # state 2: scan right looking for end of string (remenbering a)
      TMRule.new(2, 'a', 2, 'a', :right), # skip a
      TMRule.new(2, 'b', 2, 'b', :right), # skip b
      TMRule.new(2, 'c', 2, 'c', :right), # skip c
      TMRule.new(2, '_', 5, 'a', :right), # find blank, write a

      # state 3: scan right looking for end of string (remenbering b)
      TMRule.new(3, 'a', 3, 'a', :right), # skip a
      TMRule.new(3, 'b', 3, 'b', :right), # skip b
      TMRule.new(3, 'c', 3, 'c', :right), # skip c
      TMRule.new(3, '_', 5, 'b', :right), # find blank, write b

      # state 4: scan right looking for end of string (remenbering c)
      TMRule.new(4, 'a', 4, 'a', :right), # skip a
      TMRule.new(4, 'b', 4, 'b', :right), # skip b
      TMRule.new(4, 'c', 4, 'c', :right), # skip c
      TMRule.new(4, '_', 5, 'c', :right), # find blank, write c
    ])
  }


  subject(:subject) { DTM.new(TMConfiguration.new(1, tape), [6], rulebook) }
  context "For tape bcbca" do
    When(:tape) { Tape.new([], 'b', ['c', 'b', 'c', 'a'], '_')}

    context "initial state" do
      Then { subject.current_configuration.state == 1 }
      Then { subject.current_configuration.tape.inspect == "#<Tape (b)cbca>" }
    end
    
    context "after run" do
      When { subject.run }
      Then { subject.current_configuration.state == 5 }
      Then { subject.current_configuration.tape.inspect == "#<Tape bcbcab(_)>" }
    end
  end

  context "For tape aabca" do
    When(:tape) { Tape.new([], 'a', ['a', 'b', 'c', 'a'], '_')}

    context "initial state" do
      Then { subject.current_configuration.state == 1 }
      Then { subject.current_configuration.tape.inspect == "#<Tape (a)abca>" }
    end
    
    context "after run" do
      When { subject.run }
      Then { subject.current_configuration.state == 5 }
      Then { subject.current_configuration.tape.inspect == "#<Tape aabcaa(_)>" }
    end
  end


end
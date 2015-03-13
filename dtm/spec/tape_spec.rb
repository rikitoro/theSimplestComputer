require 'rspec/given'
require_relative '../tape'

describe Tape do
  subject(:subject) { Tape.new(['1', '0', '1'], '1', [], '_') }

  Then { subject.inspect == "#<Tape 101(1)>" }
  Then { subject.middle == '1' }
  Then { subject.move_head_left.inspect == "#<Tape 10(1)1>"}
  Then { subject.move_head_right.inspect == "#<Tape 1011(_)>"}
  Then { subject.move_head_right.write('0').inspect == "#<Tape 1011(0)>"}
end
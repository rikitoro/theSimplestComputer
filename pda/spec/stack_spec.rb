require 'rspec/given'
require_relative '../stack'

describe Stack do
  Given(:stack) { Stack.new(['a', 'b', 'c', 'd', 'e']) }

  Then { stack.top == 'a' }
  Then { stack.pop.pop.top == 'c' }
  Then { stack.push('x').push('y').top == 'y' }
  Then { stack.push('x').push('y').pop.top == 'x' }
  Then { stack.push('x').push('y').pop.pop.top == 'a' }

end
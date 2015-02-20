
class FARule < Struct.new(:state, :character, :next_state)
  def applies_to?(state, character)
    self.state == state && self.character == character
  end
  
  def follow
    next_state
  end

  def inspect
    "#<FARule #{state.inspect} --#{character.inspect}--> #{next_state.inspect}>"
  end
end
class PDAConfigulation < Struct.new(:state, :stack)
  STUCK_STATE = Object.new

  def stuck
    PDAConfigulation.new(STUCK_STATE, stack)
  end
  
  def stuck?
    state == STUCK_STATE
  end

end


class PDARule < Struct.new(:state, :character, :next_state, 
  :pop_character, :push_characters)
  
  def applies_to?(configulation, character)
    self.state == configulation.state &&
      self.pop_character == configulation.stack.top &&
      self.character == character
  end
  
  def follow(configulation)
    PDAConfigulation.new(next_state, next_stack(configulation))
  end

  def next_stack(configulation)
    popped_stack = configulation.stack.pop

    push_characters.reverse.inject(popped_stack) { |stack, character|
      stack.push(character)
    }
  end
end
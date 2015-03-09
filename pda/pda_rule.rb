class PDAConfigulation < Struct.new(:state, :stack)
end


class PDARule < Struct.new(:state, :character, :next_state, 
  :pop_character, :push_characters)
  
  def applies_to?(configulation, character)
    self.state == configulation.state &&
      self.pop_character == configulation.stack.top &&
      self.character == character
  end
  
  
end
class NPDA < Struct.new(
  :current_configurations, :accept_states, :rulebook)
  
  def accepting?
    current_configurations.any? { |confing|
      accept_states.include?(confing.state)
    }
  end

  def read_character(character)
    self.current_configurations =
      rulebook.next_configurations(current_configurations, character)
  end

  def read_string(string)
    string.chars.each do |character|
      read_character(character)
    end
  end

  def current_configurations
    rulebook.follow_free_moves(super)
  end
end
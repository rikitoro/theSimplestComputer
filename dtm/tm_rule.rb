class TMRule < Struct.new(
  :state, :character, :next_state, :write_character, :direction)
  def applies_to?(configuration)
    state == configuration.state &&
      character == configuration.tape.middle
  end
end

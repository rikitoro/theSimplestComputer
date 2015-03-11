require_relative 'stack'
require_relative 'pda_rule'
require_relative 'dpda'

class DPDADesign < Struct.new(
  :start_state, :bottom_character, :accept_states, :rulebook)
  
  def accepts?(string)
    to_dpda.tap { |dpda| dpda.read_string(string) }.accepting?
  end

  def to_dpda
    start_stack = Stack.new([bottom_character])
    start_configulation = PDAConfigulation.new(start_state, start_stack)
    DPDA.new(start_configulation, accept_states, rulebook)
  end  
end
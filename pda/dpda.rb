class DPDARulebook < Struct.new(:rules)
  def next_configulation(configulation, character)
    rule_for(configulation, character).follow(configulation)
  end

  def rule_for(configulation, character)
    rules.detect { |rule| rule.applies_to?(configulation, character) }
  end

  def applies_to?(configulation, character)
    !rule_for(configulation, character).nil?
  end

  def follow_free_moves(configulation)
    if applies_to?(configulation, nil)
      follow_free_moves(next_configulation(configulation, nil))      
    else
      configulation
    end
  end
end

class DPDA < Struct.new(:current_configulation, :accept_states, :rulebook)
  def current_configulation
    rulebook.follow_free_moves(super)
  end

  def accepting?
    accept_states.include?(current_configulation.state)
  end

  def read_character(character)
    self.current_configulation = next_configulation(character)
  end

  def read_string(string)
    string.chars.each do |character|
      read_character(character) unless stuck?
    end
  end

  def next_configulation(character)
    if rulebook.applies_to?(current_configulation, character)
      rulebook.next_configulation(current_configulation, character)
    else
      current_configulation.stuck
    end
  end

  def stuck?
    current_configulation.stuck?
  end
end

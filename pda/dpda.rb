class DPDARulebook < Struct.new(:rules)
  def next_configulation(configulation, character)
    rule_for(configulation, character).follow(configulation)
  end

  def rule_for(configulation, character)
    rules.detect { |rule| rule.applies_to?(configulation, character) }
  end
  
end
require 'rspec/given'
require_relative '../tm_rule'
require_relative '../tape'

describe TMRule do

  describe "#applies_to?" do
    subject(:subject) { TMRule.new(1, '0', 2, '1', :right) }
    
    context "状態とヘッド位置の文字がルールと一致" do
      When(:configuration) { TMConfiguration.new(1, Tape.new([], '0', [], '_')) }
      Then { subject.applies_to?(configuration) == true } 
    end 

    context "ヘッド位置の文字がルールと不一致" do
      When(:configuration) { TMConfiguration.new(1, Tape.new([], '1', [], '_')) }
      Then { subject.applies_to?(configuration) == false }     
    end

    context "状態がルールと不一致" do
      When(:configuration) { TMConfiguration.new(2, Tape.new([], '0', [], '_')) }
      Then { subject.applies_to?(configuration) == false }     
    end
  end

  describe "#follow" do
    subject(:subject) { TMRule.new(1, '0', 2, '1', :right) }
    When(:configuration) { TMConfiguration.new(1, Tape.new([], '0', [], '_')) }
    When(:next_configuration) { subject.follow(configuration) }
    Then { next_configuration.state == 2 }
    Then { next_configuration.tape.inspect == "#<Tape 1(_)>"}
  end
end
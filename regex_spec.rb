require 'rspec'
require_relative './regex'

describe "regex" do
  before do
    @pattern = 
      Repeat.new(
        Choose.new(
          Concatenate.new(Literal.new('a'), Literal.new('b')),
          Literal.new('a')
        )
      )
  end

  it "#inspect returns proper regex representation" do
    expect(@pattern.inspect).to eq '/(ab|a)*/'
  end
end

describe "#to_nfa_design" do
  describe "for Empty" do
    before do
      @nfa_design = Empty.new.to_nfa_design 
    end

    it "accepts ''" do
      expect(@nfa_design).to be_accepts ''
    end

    it "rejects 'a'" do
      expect(@nfa_design).not_to be_accepts 'a'
    end
  end

    describe "for Literal of 'a'" do
    before do
      @nfa_design = Literal.new('a').to_nfa_design 
    end

    it "rejects ''" do
      expect(@nfa_design).not_to be_accepts ''
    end

    it "accepts 'a'" do
      expect(@nfa_design).to be_accepts 'a'
    end

    it "rejects 'b'" do
      expect(@nfa_design).not_to be_accepts 'b'
    end

    it "rejects 'aa'" do
      expect(@nfa_design).not_to be_accepts 'aa'
    end
  end

end
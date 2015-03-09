require 'rspec'
require_relative '../regex'

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

describe "#matches?" do
  it "Empty matches ''" do
    expect(Empty.new).to be_matches ''
  end

  it "Empty does NOT match 'a'" do
    expect(Empty.new).not_to be_matches 'a'
  end

  it "Literal 'a' matches 'a'" do
    expect(Literal.new('a')).to be_matches 'a'
  end

  it "Literal 'a' does NOT match ''" do
    expect(Literal.new('a')).not_to be_matches ''
  end

  it "Literal 'a' does NOT matches 'b'" do
    expect(Literal.new('a')).not_to be_matches 'b'
  end

  it "Literal 'a' does NOT matches 'aa'" do
    expect(Literal.new('a')).not_to be_matches 'aa'
  end

  context "/ab/" do
    before do
      @pattern = Concatenate.new(Literal.new('a'), Literal.new('b'))
    end

    it "rejects 'a'" do
      expect(@pattern).not_to be_matches 'a'
    end

    it "accepts 'ab'" do
      expect(@pattern).to be_matches 'ab'
    end

    it "rejects 'abc'" do
      expect(@pattern).not_to be_matches 'abc'
    end
  end

  context "/abc/" do
    before do
      @pattern = Concatenate.new(
        Literal.new('a'),
        Concatenate.new(Literal.new('b'), Literal.new('c'))
        )
    end

    it "rejects 'a'" do
      expect(@pattern).not_to be_matches 'a'
    end

    it "rejects 'ab'" do
      expect(@pattern).not_to be_matches 'ab'
    end

    it "accepts 'abc'" do
      expect(@pattern).to be_matches 'abc'
    end
  end

  context "/a|b/" do
    before do
      @pattern = Choose.new(Literal.new('a'), Literal.new('b'))
    end

    it "accepts 'a'" do
      expect(@pattern).to be_matches 'a'
    end

    it "accepts 'b'" do
      expect(@pattern).to be_matches 'b'
    end

    it "rejects 'c'" do
      expect(@pattern).not_to be_matches 'c'
    end

    it "rejects 'ab'" do
      expect(@pattern).not_to be_matches 'ab'
    end
  end

  context "/a*/" do
    before do
      @pattern = Repeat.new(Literal.new('a'))      
    end

    it "accepts ''" do
      expect(@pattern).to be_matches ''
    end

    it "accepts 'a'" do
      expect(@pattern).to be_matches 'a'
    end

    it "accepts 'aaaa'" do
      expect(@pattern).to be_matches 'aaaa'
    end

    it "rejects 'b'" do
      expect(@pattern).not_to be_matches 'b'
    end
  end

  context "/(a(|b))*/" do
    before do
      @pattern = 
        Repeat.new(
          Concatenate.new(
            Literal.new('a'),
            Choose.new(Empty.new, Literal.new('b'))
          )
        )
    end

    it "accepts ''" do
      expect(@pattern).to be_matches ''
    end

    it "accepts 'a'" do
      expect(@pattern).to be_matches 'a'
    end

    it "accepts 'ab'" do
      expect(@pattern).to be_matches 'ab'
    end

    it "accepts 'aba'" do
      expect(@pattern).to be_matches 'aba'
    end

    it "accepts 'abab'" do
      expect(@pattern).to be_matches 'abab'
    end

    it "accepts 'abaab'" do
      expect(@pattern).to be_matches 'abaab'
    end

    it "rejects 'abba'" do
      expect(@pattern).not_to be_matches 'abba'
    end


  end

end
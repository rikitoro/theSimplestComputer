require 'rspec'
require 'treetop'
require_relative '../regex'

Treetop.load('pattern')

describe "PatternPaser" do
  context "parse '(a(|b))*'" do
    before do
      parse_tree = PatternParser.new.parse('(a(|b))*')
      @pattern = parse_tree.to_ast
    end

    it "to /(a(|b))*/" do
      expect(@pattern.inspect).to eq '/(a(|b))*/'
    end

    it "matches 'abaab'" do
      expect(@pattern).to be_matches 'abaab'
    end

    it "Not match 'abba'" do
      expect(@pattern).not_to be_matches 'abba'
    end    
  end
end
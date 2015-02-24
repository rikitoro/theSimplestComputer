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
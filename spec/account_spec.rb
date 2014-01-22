require "spec_helper"
require "banktools-de/account"

describe BankTools::DE::Account, "#normalize" do
  it "groups the number in threes" do
    expect_normalization "12", "12"
    expect_normalization "123", "123"
    expect_normalization "1234", "123 4"
    expect_normalization "1234567890", "123 456 789 0"
  end

  it "ignores previous whitespace" do
    expect_normalization " 1 23 4 ", "123 4"
  end

  it "ignores previous dashes" do
    expect_normalization " 1-2-3-4 ", "123 4"
  end

  it "leaves a bad format as-is" do
    expect_normalization "hej", "hej"
  end

  def expect_normalization(from, unto)
    expect(BankTools::DE::Account.new(from).normalize).to eq unto
  end
end

describe BankTools::DE::Account, "#valid?" do
  it "is true with no errors" do
    expect(BankTools::DE::Account.new("12").valid?).to be_true
  end

  it "is false with errors" do
    expect(BankTools::DE::Account.new("1").valid?).to be_false
  end
end

describe BankTools::DE::Account, "#errors" do
  Errors ||= BankTools::DE::Errors

  it "is empty when valid" do
    expect(BankTools::DE::Account.new(" 1-2 ").errors).to be_empty
  end

  it "includes TOO_SHORT if below 2 characters" do
    expect(BankTools::DE::Account.new("1").errors).to include(Errors::TOO_SHORT)
  end

  it "includes TOO_LONG if above 15 characters" do
    expect(BankTools::DE::Account.new("1234567890123456").errors).to include(Errors::TOO_LONG)
  end

  it "includes INVALID_CHARACTERS if there's other things than digits, whitespace and dashes" do
    expect(BankTools::DE::Account.new("1X").errors).to include(Errors::INVALID_CHARACTERS)
  end
end

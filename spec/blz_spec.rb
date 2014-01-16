require "spec_helper"
require "bank_tools/de/blz"

describe BankTools::DE::BLZ, "#normalize" do
  it "groups the number correctly" do
    expect_normalization "12345678", "123 456 78"
  end

  it "leaves a bad format as-is" do
    expect_normalization "123", "123"
    expect_normalization "123456789", "123456789"
    expect_normalization "hej", "hej"
  end

  def expect_normalization(from, unto)
    expect(BankTools::DE::BLZ.new(from).normalize).to eq unto
  end
end

describe BankTools::DE::BLZ, "#valid?" do
  it "is true with no errors" do
    expect(BankTools::DE::BLZ.new("123 456 78").valid?).to be_true
  end

  it "is false with errors" do
    expect(BankTools::DE::BLZ.new("1").valid?).to be_false
  end
end

describe BankTools::DE::BLZ, "#errors" do
  Errors ||= BankTools::DE::Errors

  it "is empty when valid" do
    expect(BankTools::DE::BLZ.new(" 123 456-78 ").errors).to be_empty
  end

  it "includes TOO_SHORT if below 8 characters" do
    expect(BankTools::DE::BLZ.new("1234567").errors).to include(Errors::TOO_SHORT)
  end

  it "includes TOO_LONG if above 8 characters" do
    expect(BankTools::DE::BLZ.new("123456789").errors).to include(Errors::TOO_LONG)
  end

  it "includes INVALID_CHARACTERS if there are non-digits" do
    expect(BankTools::DE::BLZ.new("1X").errors).to include(Errors::INVALID_CHARACTERS)
  end
end

describe BankTools::DE::BLZ, "#bank_name" do
  it "is provided if known" do
    expect(BankTools::DE::BLZ.new("10000000").bank_name).to eq "BBk Berlin"
  end

  it "is nil if unknown" do
    expect(BankTools::DE::BLZ.new("X").bank_name).to be_nil
  end
end

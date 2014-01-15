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

require "spec_helper"
require "banktools-de"

describe BankTools::DE, ".data_dir" do
  it "returns the data directory path" do
    expect(BankTools::DE.data_dir).to include "/data"
  end
end

require "spec_helper"
require "banktools-de/iban_bic"

describe BankTools::DE::IbanBicConverter, ".call" do
  it "returns the BIC and IBAN" do
    blz = "25050180"
    account = "39370089"

    actual = BankTools::DE::IbanBicConverter.call(blz: blz, account: account)

    expect(actual.iban).to eq("DE53250501800039370089")
    expect(actual.bic).to eq("SPKHDE2HXXX")
  end

  it "raises CouldNotConvertIbanError on iban conversion errors" do
    blz = "abc"
    account = "def"

    expect {
      BankTools::DE::IbanBicConverter.call(blz: blz, account: account)
    }.to raise_error(BankTools::DE::IbanBicConverter::CouldNotConvertIbanError)
  end

  it "raises CouldNotFindBicError on find bic errors" do
    blz = "21050171"
    account = "12345678"

    expect {
      BankTools::DE::IbanBicConverter.call(blz: blz, account: account)
    }.to raise_error(BankTools::DE::IbanBicConverter::CouldNotFindBicError)
  end
end

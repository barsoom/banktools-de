require "spec_helper"
require "banktools-de/iban_bic"

describe BankTools::DE::IBANBicConverter, ".run" do
  let(:valid_bank_code) { "abc" }
  let(:valid_account_number) { "def" }

  it "returns the BIC and IBAN" do
    iban = "iban"
    bic = "bic"

    allow(Ibanomat).to receive(:find).and_return(iban: iban, bic: bic, return_code: "00")

    actual = BankTools::DE::IBANBicConverter.run(bank_code: valid_bank_code, account_number: valid_account_number)

    expect(actual.iban).to eq(iban)
    expect(actual.bic).to eq(bic)
  end

  it "raises when the parameters are wrong" do
    invalid = "invalid"

    allow(Ibanomat).to receive(:find).and_return(return_code: "1")

    expect {
      BankTools::DE::IBANBicConverter.run(bank_code: invalid, account_number: invalid)
    }.to raise_error(BankTools::DE::IBANBicConverter::CouldNotConvertError)
  end

  it "raises when the service is down" do
    allow(Ibanomat).to receive(:find).and_raise(RestClient::RequestTimeout)

    expect {
      BankTools::DE::IBANBicConverter.run(bank_code: valid_bank_code, account_number: valid_account_number)
    }.to raise_error(BankTools::DE::IBANBicConverter::ServiceUnavailable)
  end

  it "raises when something else is wrong" do
    allow(Ibanomat).to receive(:find).and_raise("unknown error")

    expect {
      BankTools::DE::IBANBicConverter.run(bank_code: valid_bank_code, account_number: valid_account_number)
    }.to raise_error(BankTools::DE::IBANBicConverter::UnknownError)
  end
end

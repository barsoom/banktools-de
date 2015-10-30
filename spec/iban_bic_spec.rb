require "spec_helper"
require "banktools-de/iban_bic"

describe BankTools::DE::IbanBicConverter, ".call" do
  let(:blz) { "abc" }
  let(:account) { "def" }

  it "returns the BIC and IBAN" do
    allow(Ibanomat).to receive(:find).and_return(iban: "some iban", bic: "some bic", return_code: "00")

    actual = BankTools::DE::IbanBicConverter.call(blz: blz, account: account)

    expect(actual.iban).to eq("some iban")
    expect(actual.bic).to eq("some bic")
  end

  it "raises CouldNotConvertError on conversion errors" do
    allow(Ibanomat).to receive(:find).and_return(return_code: "1")

    expect {
      BankTools::DE::IbanBicConverter.call(blz: blz, account: account)
    }.to raise_error(BankTools::DE::IbanBicConverter::CouldNotConvertError)
  end

  it "raises ServiceUnavailable when the service is down" do
    allow(Ibanomat).to receive(:find).and_raise(RestClient::RequestTimeout)

    expect {
      BankTools::DE::IbanBicConverter.call(blz: blz, account: account)
    }.to raise_error(BankTools::DE::IbanBicConverter::ServiceUnavailable)
  end

  it "raises UnknownError on other errors" do
    allow(Ibanomat).to receive(:find).and_raise("unknown error")

    expect {
      BankTools::DE::IbanBicConverter.call(blz: blz, account: account)
    }.to raise_error(BankTools::DE::IbanBicConverter::UnknownError)
  end
end

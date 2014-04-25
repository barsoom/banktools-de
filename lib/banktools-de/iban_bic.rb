require "ibanomat"
require "attr_extras"

class BankTools::DE::IbanBicConverter
  class CouldNotConvertError < StandardError; end
  class ServiceUnavailable < StandardError; end
  class UnknownError < StandardError; end

  class IbanBic
    vattr_initialize :iban, :bic
  end

  method_object :run,
    [ :bank_code!, :account_number! ]

  def run
    account_data = get_account_data
    build_result(account_data)
  end

  private

  def get_account_data
    Ibanomat.find(bank_code: bank_code, bank_account_number: account_number)
  rescue RestClient::RequestTimeout
    raise ServiceUnavailable
  rescue
    raise UnknownError
  end

  def build_result(account_data)
    # Non-"00" values represent an Ibanomat warning or error.
    return_code = account_data.fetch(:return_code)
    raise CouldNotConvertError unless return_code == "00"

    iban = account_data.fetch(:iban)
    bic  = account_data.fetch(:bic)
    IbanBic.new(iban, bic)
  end
end

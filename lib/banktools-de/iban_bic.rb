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
    result = convert

    parse(result)
  end

  private

  def convert
    Ibanomat.find(bank_code: bank_code, bank_account_number: account_number)

  rescue RestClient::RequestTimeout
    raise ServiceUnavailable
  rescue
    raise UnknownError
  end

  def parse(result)
    return_code = result.fetch(:return_code)

    if return_code == "00"
      iban = result.fetch(:iban)
      bic = result.fetch(:bic)
      IbanBic.new(iban, bic)
    else
      raise CouldNotConvertError
    end
  end
end

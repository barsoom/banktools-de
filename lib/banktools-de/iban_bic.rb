require "memoit"
require "ibanizator"
require "attr_extras/explicit"

class BankTools::DE::IbanBicConverter
  extend AttrExtras.mixin

  class CouldNotConvertIbanError < StandardError; end
  class CouldNotFindBicError < StandardError; end

  class IbanBic
    extend AttrExtras.mixin
    vattr_initialize :iban, :bic
  end

  method_object [ :blz!, :account! ]

  def call
    IbanBic.new(iban, bic)
  end

  private

  def iban
    iban_object.iban_string
  end

  def bic
    iban_object.extended_data.bic
  rescue Ibanizator::BankDb::BankNotFoundError => e
    raise CouldNotFindBicError.new(e.message)
  end

  memoize \
  def iban_object
    iban_string = Ibanizator.new.calculate_iban(country_code: :de, bank_code: blz, account_number: account)
    iban = Ibanizator.iban_from_string(iban_string)

    if Ibanizator.iban_from_string(iban).valid?
      iban
    else
      raise CouldNotConvertIbanError.new("Invalid IBAN: #{iban.iban_string}")
    end
  end
end

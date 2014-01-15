# http://de.wikipedia.org/wiki/Bankleitzahl
# http://translate.google.com/translate?hl=en&sl=de&tl=en&u=http%3A%2F%2Fde.wikipedia.org%2Fwiki%2FBankleitzahl

require "attr_extras"
require "bank_tools/de/errors"

module BankTools
  module DE
    class BLZ
      LENGTH = 8

      pattr_initialize :original_value

      def normalize
        if compacted_value.match(/\A(\d{3})(\d{3})(\d{2})\z/)
          "#$1 #$2 #$3"
        else
          original_value
        end
      end

      def valid?
        errors.empty?
      end

      def errors
        errors = []
        errors << Errors::TOO_SHORT if compacted_value.length < LENGTH
        errors << Errors::TOO_LONG if compacted_value.length > LENGTH
        errors << Errors::INVALID_CHARACTERS if compacted_value.match(/\D/)
        errors
      end

      private

      def compacted_value
        original_value.to_s.gsub(/\s/, "")
      end
    end
  end
end

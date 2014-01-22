# http://de.wikipedia.org/wiki/Bankleitzahl
# http://translate.google.com/translate?hl=en&sl=de&tl=en&u=http%3A%2F%2Fde.wikipedia.org%2Fwiki%2FBankleitzahl

require "attr_extras"
require "banktools-de/errors"

module BankTools
  module DE
    class Account
      # Picked some reasonable values, erring on the side of allowing too much.
      # Seems to claim max 10: http://docs.oracle.com/cd/E18727_01/doc.121/e13483/T359831T498954.htm
      # Seems to claim 2 - 13: http://www.credit-card.be/BankAccount/ValidationRules.htm#DE_Validation
      MIN_LENGTH = 2
      MAX_LENGTH = 15

      GROUPS_OF = 3

      pattr_initialize :original_value

      def normalize
        if valid?
          compacted_value.scan(/\d{#{GROUPS_OF}}|\d+/).join(" ")
        else
          original_value
        end
      end

      def valid?
        errors.empty?
      end

      def errors
        errors = []
        errors << Errors::TOO_SHORT if compacted_value.length < MIN_LENGTH
        errors << Errors::TOO_LONG if compacted_value.length > MAX_LENGTH
        errors << Errors::INVALID_CHARACTERS if compacted_value.match(/\D/)
        errors
      end

      private

      def compacted_value
        original_value.to_s.gsub(/[\s-]/, "")
      end
    end
  end
end

# http://de.wikipedia.org/wiki/Bankleitzahl
# http://translate.google.com/translate?hl=en&sl=de&tl=en&u=http%3A%2F%2Fde.wikipedia.org%2Fwiki%2FBankleitzahl

require "banktools-de"
require "banktools-de/errors"

require "attr_extras/explicit"
require "yaml"

module BankTools
  module DE
    class BLZ
      extend AttrExtras.mixin

      LENGTH = 8
      BLZ_TO_BANK_NAME_PATH = File.join(BankTools::DE.data_dir, "blz_to_name.yml")

      pattr_initialize :original_value

      def self.blz_to_bank_name
        @blz_to_bank_name ||= YAML.load_file(BLZ_TO_BANK_NAME_PATH).fetch(:data)
      end

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

      def bank_name
        blz_to_bank_name.fetch(compacted_value, nil)
      end

      private

      def blz_to_bank_name
        self.class.blz_to_bank_name
      end

      def compacted_value
        original_value.to_s.gsub(/[\s-]/, "")
      end
    end
  end
end

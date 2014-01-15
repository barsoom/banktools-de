require "attr_extras"

module BankTools
  module DE
    class BLZ
      pattr_initialize :original_value

      def normalize
        if compacted_value.match(/\A(\d{3})(\d{3})(\d{2})\z/)
          "#$1 #$2 #$3"
        else
          original_value
        end
      end

      private

      def compacted_value
        original_value.to_s.gsub(/\s/, "")
      end
    end
  end
end

require "bank_tools/de/version"
require "bank_tools/de/blz"
require "bank_tools/de/account"

module BankTools
  module DE
    def self.data_dir
      File.join(root_dir, "data")
    end

    def self.root_dir
      File.expand_path '../../..', __FILE__
    end
  end
end

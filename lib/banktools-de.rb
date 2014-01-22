module BankTools
  module DE
    def self.data_dir
      File.join(root_dir, "data")
    end

    def self.root_dir
      File.expand_path '../..', __FILE__
    end
  end
end

require "banktools-de/version"
require "banktools-de/blz"
require "banktools-de/account"

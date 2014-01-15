require "attr_extras"
require "yaml"
require "open-uri"

# Also tried "roo" (slow) and "spreadsheet" (got errors).
require "creek"

module BankTools
  module DE
    class BLZDownloader
      pattr_initialize :url

      def run
        puts "Download: #{url}"

        if url.include?("://")
          puts "Downloading…"
          local_file = "/tmp/blz.xlsx"
          File.write(local_file, open(url).read)
        else
          local_file = url
        end

        puts "Parsing…"

        book = Creek::Book.new(local_file)
        sheet = book.sheets[0]

        hash = {
          generated_at: Time.now,
          generated_from_url: url,
          data: {}
        }

        data = hash[:data]

        sheet.rows.each_with_index do |row, index|
          blz, feature, name, plz, location, short_name, *_ = row.values
          next if index.zero? && blz.match(/\D/)  # Headers
          data[blz] = short_name
        end

        File.write("data/blz_to_name.yml", hash.to_yaml)

        puts "Done. Wrote #{data.length} entries."
      end
    end
  end
end

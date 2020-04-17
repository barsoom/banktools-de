# German bank tools

[![Build Status](https://secure.travis-ci.org/barsoom/banktools-de.svg)](http://travis-ci.org/barsoom/banktools-de)

Ruby gem to validate, normalize/prettify and interpret German Bankleitzahl (BLZ) and bank account numbers.

When in doubt, this library aims to err on the side of allowing too much. We've yet to find clear specs, so be aware that the current validation rules are *very* forgiving.

If we got anything wrong, please file an issue or contribute a fix yourself.


## Usage

```ruby
# BLZ

blz = BankTools::DE::BLZ.new("10070024")
blz.normalize  # => "100 700 24"
blz.valid?  # => true
blz.errors  # => []
blz.bank_name  # => "Deutsche Bank PGK Berlin"
BankTools::DE::BLZ.blz_to_bank_name  # => { "10070024" => "Deutsche Bank PGK Berlin", … }

bad_blz = BankTools::DE::BLZ.new("1X")
bad_blz.normalize  # => "1X"
bad_blz.valid?  # => false
bad_blz.errors  # => [:too_short, :invalid_characters]
blz.bank_name  # => nil

# Account

account = BankTools::DE::Account.new("123456789")
account.normalize  # => "123 456 789"
account.valid?  # => true
account.errors  # => []

bad_account = BankTools::DE::Account.new("1")
bad_account.normalize  # => "1"
bad_account.valid?  # => false
bad_account.errors  # => [:too_short]

# Convert BLZ and account number to IBAN/BIC

result = BankTools::DE::IbanBicConverter.call(blz: "37040044", account: "532013000")
result.iban  # => "DE89370400440532013000"
result.bic   # => "COBADEFFXXX"
# Or raises an exception.
```

## Tests

    bundle
    rspec  # or: rake


## Update BLZ data

Bundesbank provide a mapping from BLZ to bank name that is updated regularly. Updates appear to ship for periods of 3 months (e.g. 2013-09-09 - 2013-12-08) and to be made available the month prior.

As a gem maintainer:

Visit <https://www.bundesbank.de/en/tasks/payment-systems/services/bank-sort-codes/download---bank-sort-codes-626218> and find the latest data (you may need to scroll past older data) under "Bank sort code files, unpacked" in the XLSX format. Copy that URL.

Run:

    bundle
    bundle exec rake download URL="https://www.bundesbank.de/resource/blob/602630/20faacc2e44cf0c02ff37edb4d8a6ea6/mL/blz-aktuell-xls-data.xlsx"

Where the URL is the URL for the latest unpacked XLSX data.

You can provide a local path if you want.

This will overwrite the data file in the code repository.

Bump the gem tiny version (e.g. 1.1.1 -> 1.1.2) and make a new release (`rake release`).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'banktools-de'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install banktools-de


## TODO

* [Checksum validation](http://www.bundesbank.de/Navigation/DE/Kerngeschaeftsfelder/Unbarer_Zahlungsverkehr/Pruefzifferberechnung/pruefzifferberechnung.html)


## Also see

- [Our other BankTools](https://github.com/barsoom?q=banktools)
- [iban-tools](https://github.com/iulianu/iban-tools)
- [Konto API online service](https://www.kontoapi.de)


## Credits

* [Henrik Nyh](http://henrik.nyh.se)
* Tomas Skogberg
* Victor Arias

## License

MIT license:

Copyright (c) 2014 Barsoom AB

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

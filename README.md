# German bank tools

Ruby gem to validate, normalize/prettify and interpret German Bankleitzahl (BLZ) and bank account numbers.

When in doubt, this library aims to err on the side of allowing too much. We've yet to find clear specs, so be aware that the current validation rules are *very* forgiving.

If we got anything wrong, please file an issue or contribute a fix yourself.


## Usage

    # BLZ

    blz = BankTools::DE::BLZ.new("10070024")
    blz.normalize  # => "100 700 24"
    blz.valid?  # => true
    blz.errors  # => []
    blz.bank_name  # => "Deutsche Bank PGK Berlin"

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


## Tests

    bundle
    rspec  # or: rake


## Update BLZ data

Bundesbank provide a mapping from BLZ to bank name that appears to be updated regularly:

<http://www.bundesbank.de/Redaktion/DE/Standardartikel/Kerngeschaeftsfelder/Unbarer_Zahlungsverkehr/bankleitzahlen_download.html>

As a gem maintainer, run

    bundle
    rake download URL="http://www.bundesbank.de/…/blz_2013_12_09_xls.xlsx?__blob=publicationFile"

providing a URL for the latest unpacked XLSX version of the data.

You can provide a local path if you want.

This will overwrite the data file in the code repository.

Updates appear to ship for periods of 3 months, provided the month before a period starts. We've seen these periods:
* 2013-09-09 - 2013-12-08
* 2013-12-09 - 2014-03-02


## Installation

Add this line to your application's Gemfile:

    gem 'banktools-de'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install banktools-de


## Also see

* [BankTools::SE (Swedish)](https://github.com/barsoom/banktools-se)
* [iban-tools](https://github.com/iulianu/iban-tools)


## Credits and license

By [Henrik Nyh](http://henrik.nyh.se) for [Barsoom](http://barsoom.se) under the MIT license:

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

<p align="right">
    <a href="https://github.com/vergilet/monobank"><img align="" src="https://user-images.githubusercontent.com/2478436/51829223-cb05d600-22f5-11e9-9245-bc6e82dcf028.png" width="56" height="56" /></a>
<a href="https://rubygems.org/gems/monobank"><img align="right" src="https://user-images.githubusercontent.com/2478436/51829691-c55cc000-22f6-11e9-99a5-42f88a8f2a55.png" width="56" height="56" /></a>
</p>
<p align="center">
   <a href="https://rubygems.org/gems/monobank"><img width="460" src="https://user-images.githubusercontent.com/2478436/71856112-95639280-30eb-11ea-932e-dd8cbe851858.png" /></a>
</p>

[![Build Status](https://api.travis-ci.com/vergilet/repost.svg?branch=master)](https://app.travis-ci.com/github/vergilet/monobank)

# Monobank

Unofficial Ruby Gem for [Monobank API](https://api.monobank.ua/docs/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'monobank'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install monobank

## API Modules

Use available methods to gather needed data from Monobank API:

```ruby
# --- Public API ---
# Bank currency (no token needed)
Monobank.bank_currency

# --- Personal API ---
# Client Info
Monobank.client_info(token: 'YOUR_PERSONAL_TOKEN')

# Statement
Monobank.statement(token: 'YOUR_PERSONAL_TOKEN', account_id: 'ACCOUNT_ID', from: 1546304461)

# Set webhook
Monobank.set_webhook(token: 'YOUR_PERSONAL_TOKEN',  url: 'WEBHOOK_URL')

# --- Business API (for Legal Entities) ---
Monobank::Business.configure(token: 'YOUR_BUSINESS_TOKEN')
Monobank::Business.accounts
Monobank::Business.statement(account: 'IBAN', from: 1672524000)
```

### Public data

General information provided without authorization.

#### Bank Currency

##### API Method: [bank-currency](https://api.monobank.ua/docs/#tag/Publichni-dani/paths/~1bank~1currency/get)

`GET /bank/currency`

*Get a basic list of monobank exchange rates. The information is cached and updated at least once every 5 minutes.*

```ruby
bank_currency = Monobank.bank_currency
#=> returns an array of Monobank::Resources::Bank::Currency objects
```

```ruby
some_currency = bank_currency.first
some_currency.currency_code_a   # Integer, ISO 4217
some_currency.currency_code_b   # Integer, ISO 4217
some_currency.date              # Integer, Unix time in sec (use Time.at)
some_currency.rate_sell         # Float
some_currency.rate_buy          # Float
some_currency.rate_cross        # Float
```

*(!) About [ISO 4217](https://uk.wikipedia.org/wiki/%D0%9A%D0%BB%D0%B0%D1%81%D0%B8%D1%84%D1%96%D0%BA%D0%B0%D1%86%D1%96%D1%8F_%D0%B2%D0%B0%D0%BB%D1%8E%D1%82_(ISO_4217)?section=2#%D0%9F%D0%B5%D1%80%D0%B5%D0%BB%D1%96%D0%BA_%D0%B4%D1%96%D1%8E%D1%87%D0%B8%D1%85_%D0%BA%D0%BE%D0%B4%D1%96%D0%B2).* 


### Personal data

Information provided only with the access token that the client can obtain in his personal account [Monobank API](https://api.monobank.ua/)

#### Client Info

##### API Method: [personal-client-info](https://api.monobank.ua/docs/#tag/Kliyentski-personalni-dani/paths/~1personal~1client-info/get)

`GET /personal/client-info`

*Receiving information about the client and a list of his accounts. Limit: no more than once every 60 seconds.*

```ruby
client_info = Monobank.client_info(token: 'YOUR_PERSONAL_TOKEN')
#=> returns a Monobank::Resources::Personal::ClientInfo object

client_info.name                # String, client name
client_info.web_hook_url        # String, webhook url 
client_info.accounts            # array of accounts (type Monobank::Resources::Personal::Account)

client_info.attributes          # Hash with all fields above
```
##### Client Info > Account

```ruby
account = client_info.accounts.first
account.class                   # Monobank::Resources::Personal::Account
```
```ruby
account.id                      # String, Account identifier
account.balance                 # Integer, Balance in cents
account.credit_limit            # Integer, Credit limit
account.currency_code           # Integer, ISO 4217
account.cashback_type           # String, None, UAH, Miles 

account.attributes              # Hash with all fields above
```

#### Statement

##### API Method: [personal-statement](https://api.monobank.ua/docs/#tag/Kliyentski-personalni-dani/paths/~1personal~1statement~1{account}~1{from}~1{to}/get)

`GET /personal/statement/{account}/{from}/{to}`

*Receiving a statement {from} - {to} time in seconds in Unix time format. 
The maximum time for which it is possible to receive a statement is 31 days + 1 hour (2682000 seconds).
Limit on using the function no more than 1 time in 60 seconds.*

```ruby
account_id = 'QWERTY-1SdSD' # From client_info.accounts
from       = (Time.now - 2682000).to_i # 24 hours ago
to         = Time.now.to_i

statements = Monobank.statement(token: 'YOUR_PERSONAL_TOKEN', account_id: account_id, from: from, to: to)
#=> returns an array of Monobank::Resources::Personal::Statement objects
```

```ruby
statement = statements.first
statement.class             # Monobank::Resources::Personal::Statement
```
```ruby
statement.id                # String, transaction ID
statement.time              # Integer, Unix time in sec (use Time.at)
statement.description       # String, transaction description
statement.mcc               # Integer, Merchant Category Code, (ISO 18245)
statement.hold              # Boolean, Lock status
statement.amount            # Integer, Amount in cents
statement.operation_amount  # Integer, Amount in cents
statement.currency_code     # Integer, ISO 4217
statement.commission_rate   # Integer, commission amount in cents
statement.cashback_amount   # Integer, cashback amount in cents
statement.balance           # Integer, balance in cents

statement.attributes        # Hash with all fields above
```

#### Set WebHook

`POST /personal/webhook`

*Set a webhook URL to receive notifications about new transactions.*
*Sends json ~ `{type:"StatementItem", data:{account:"...", statementItem:{#StatementItem}}}` to WEBHOOK_URL*

```ruby
webhook = Monobank.set_webhook(token: 'YOUR_PERSONAL_TOKEN',  url: 'https://your.server/webhook')
#=> returns a Monobank::Resources::Personal::Webhook object

webhook.status              # String, "ok" if successful
webhook.attributes          # Hash with all fields above
```

### Business API (for Legal Entities)

DOCS: https://corp-api.monobank.ua/

API for working with legal entity (business) accounts using the new token-based authentication. To get started, obtain an access token from the [Monobank Business web cabinet](http://web.monobank.ua/?modal=tokens). 

First, configure the client with your token, typically in an initializer file (e.g., `config/initializers/monobank.rb`):

```ruby
Monobank::Business.configure(token: 'YOUR_BUSINESS_API_TOKEN')
```

#### Get All Accounts

`GET /ext/v1/accounts`

*Get a list of all company accounts.*

```ruby
accounts = Monobank::Business.accounts
#=> returns an array of Monobank::Resources::Business::Account objects

account = accounts.first
account.iban     # String
account.currency # Integer, ISO 4217
account.balance  # Float
```

#### Get a Specific Account

`GET /ext/v1/accounts/{IBAN}`

*Get details for a single account by its IBAN.*

```ruby
my_account = Monobank::Business.account(iban: 'UA753220010000026202340272045')
#=> returns a single Monobank::Resources::Business::Account object

my_account.balance #=> 42.0```
```
#### Get Account Statement

`GET /ext/v1/statement/{account}/{from}/{to}`

*Get a list of transactions for a specific account within a date range.*

```ruby
iban = 'UA753220010000026202340272045'
one_week_ago = Time.now.to_i - (7 * 86400)

transactions = Monobank::Business.statement(account: iban, from: one_week_ago)
#=> returns an array of Monobank::Resources::Business::Statement objects

tx = transactions.first
tx.id          # String
tx.time        # Integer, Unix time
tx.destination # String
tx.amount      # Integer, in cents
```

#### Get a Specific Transaction

`GET /ext/v1/statement?id=...`

*Get details for a single transaction by its unique ID.*

```ruby
transaction = Monobank::Business.statement_item(id: 'ea4f9218-d134-431a-9169-88acab4454c9')
#=> returns a single Monobank::Resources::Business::Statement object

transaction.status     # "DONE"
transaction.amount     # 12345
```

### Error Handling

If an API call fails, the gem returns a `Monobank::Resources::Error` object instead of raising an exception. You can check the class of the result to handle errors gracefully.

```ruby
result = Monobank::Business.statement(account: 'INVALID_IBAN', from: 1)

if result.is_a?(Monobank::Resources::Error)
  puts "An error occurred!"
  puts "Code: #{result.code}"                 # e.g., 400
  puts "Description: #{result.error_description}" # e.g., "Invalid IBAN"
else
  # Process successful result
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/vergilet/monobank](https://github.com/vergilet/monobank)
    
Feel free to contribute:
1. Fork it ([https://github.com/vergilet/monobank/fork](https://github.com/vergilet/monobank/fork))
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License
The gem is available as open source under the terms of the MIT License.

Copyright © 2020 Yaro & Tolik.

[![GitHub license](https://img.shields.io/badge/license-MIT-brightgreen)](https://raw.githubusercontent.com/vergilet/monobank/master/LICENSE.txt)

**That's all folks.**


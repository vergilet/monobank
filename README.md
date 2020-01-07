
<p align="right">
    <a href="https://github.com/vergilet/monobank"><img align="" src="https://user-images.githubusercontent.com/2478436/51829223-cb05d600-22f5-11e9-9245-bc6e82dcf028.png" width="56" height="56" /></a>
<a href="https://rubygems.org/gems/monobank"><img align="right" src="https://user-images.githubusercontent.com/2478436/51829691-c55cc000-22f6-11e9-99a5-42f88a8f2a55.png" width="56" height="56" /></a>
</p>
<p align="center">
   <a href="https://rubygems.org/gems/monobank"><img width="460" src="https://user-images.githubusercontent.com/2478436/71856112-95639280-30eb-11ea-932e-dd8cbe851858.png" /></a>
</p>

# Monobank

:smirk_cat: Unofficial Ruby Gem for [Monobank API](https://api.monobank.ua/docs/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'monobank'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install monobank

## Endpoints

Use available methods to gather needed data from Monobank API:

```ruby
# Bank currency
Monobank.bank_currency

# Client Info
Monobank.client_info(token: YOUR_MONO_TOKEN)

# Statement
Monobank.statement(token: YOUR_MONO_TOKEN, account_id: ACCOUNT_ID, from: 1575721820)
```

### :small_blue_diamond:Public data

General information provided without authorization.

#### :radio_button: Bank Currency

##### API Method: [bank-currency](https://api.monobank.ua/docs/#operation--bank-currency-get)

`GET /bank/currency`

*Get a basic list of monobank exchange rates. The information is cached and updated at least once every 5 minutes.*


```ruby
bank_currency = Monobank.bank_currency
bank_currency                   # Array
```

```ruby
some_currency = bank_currency.first
some_currency.class             # Monobank::Resources::Bank::Currency
```

```ruby
some_currency.currency_code_a   # Integer, ISO 4217
some_currency.currency_code_a   # Integer, ISO 4217
some_currency.date              # Integer, Unix time in sec (use Time.at)
some_currency.rate_sell         # Float
some_currency.rate_buy          # Float
some_currency.rate_cross        # Float

some_currency.attributes        # Hash with all fields above
```

### :small_orange_diamond:Personal data

Information provided only with the access token that the client can obtain in his personal account [Monobank API](https://api.monobank.ua/)

#### :radio_button: Client Info

##### API Method: [personal-client-info](https://api.monobank.ua/docs/#operation--personal-client-info-get)

`GET /personal/client-info`

*Receiving information about the client and a list of his accounts. Restrictions on the use of the function no more than once every 60 seconds.*

```ruby
client_info = Monobank.client_info(token: YOUR_MONO_TOKEN)
client_info                     # Monobank::Resources::Personal::ClientInfo
```
```ruby
client_info.name                # String, client name
client_info.web_hook_url        # String, webhook url 
client_info.accounts            # array of accounts (type Monobank::Resources::Personal::Account)

client_info.attributes          # Hash with all fields above
```
##### :heavy_minus_sign: Account

```ruby
account = client_info.accounts.first
account                         # Monobank::Resources::Personal::Account
```
```ruby
account.id                      # String, Account identifier
account.balance                 # Integer, Balance in cents
account.credit_limit            # Integer, Credit limit
account.currency_code           # Integer, ISO 4217
account.cashback_type           # String, None, UAH, Miles 

account.attributes              # Hash with all fields above
```

#### :radio_button: Statement

##### API Method: [personal-statement](https://api.monobank.ua/docs/#operation--personal-statement--account---from---to--get)

`GET /personal/statement/{account}/{from}/{to}`

*Receiving a statement {from} - {to} time in seconds in Unix time format. 
The maximum time for which it is possible to receive a statement is 31 days + 1 hour (2682000 seconds).
Limit on using the function no more than 1 time in 60 seconds.*

```ruby
account_id = 'QWERTY-1SdSD' # String, ClientInfo -> Account ID
from = 1575721820           # Integer, Unix time in sec (use Time.at)
```

```ruby
statements = Monobank.statement(token: YOUR_MONO_TOKEN, account_id: ACCOUNT_ID, from: 1575721820)
statements                  # array of accounts (type Monobank::Resources::Personal::Statement)
```

```ruby
statement = statements.first
statement                   # Monobank::Resources::Personal::Statement
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

#### :radio_button: Set WebHook

##### API Method: [personal-webhook](https://api.monobank.ua/docs/#operation--personal-webhook-post)

`POST /personal/webhook`

*Specifying the URL of the user to which a POST request will be made in `{type: "StatementItem" format, data: {account: "...", statementItem: {# StatementItem}}}`. If the customer service does not respond within 5s to the command, the service will retry within 60 and 600 seconds. If no response is received on the third attempt, the function will be disabled.*

- *WORK IN PROGRESS*

...


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vergilet/monobank
    
Feel free to contribute:
1. Fork it (https://github.com/vergilet/monobank/fork)
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request



## License
The gem is available as open source under the terms of the MIT License.

Copyright © 2020 Yaro & Tolik.

[![GitHub license](https://img.shields.io/dub/l/vibe-d.svg)](https://raw.githubusercontent.com/vergilet/monobank/master/LICENSE)

# Monobank


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'monobank'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install monobank

## :radio_button: Endpoints

Use available methods to gather needed data:

```ruby
# Bank currency
Monobank.bank_currency

# Client Info
Monobank.client_info(token: YOUR_MONO_TOKEN)

# Statement
Monobank.statement(token: YOUR_MONO_TOKEN, account_id: ACCOUNT_ID, from: 1575721820)
```

#### :radio_button: Bank Currency

##### API Method: [bank-currency](https://api.monobank.ua/docs/#operation--bank-currency-get)

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
```

#### :radio_button: Client Info

##### API Method: [personal-client-info](https://api.monobank.ua/docs/#operation--personal-client-info-get)

```ruby
    client_info = Monobank.client_info(token: YOUR_MONO_TOKEN)
    client_info                     # Monobank::Resources::Personal::ClientInfo
```
```ruby
    client_info.name                # String, client name
    client_info.web_hook_url        # String, webhook url 
    client_info.accounts            # array of accounts (type Monobank::Resources::Personal::Account)
```
##### :radio_button: Account

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
```

#### :radio_button: Statement

##### API Method: [personal-statement](https://api.monobank.ua/docs/#operation--personal-statement--account---from---to--get)

```ruby
    account_id = ACCOUNT_ID     # Integer, ClientInfo -> Account ID
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
```

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

Copyright © 2017 Yaro.

[![GitHub license](https://img.shields.io/dub/l/vibe-d.svg)](https://raw.githubusercontent.com/vergilet/monobank/master/LICENSE)

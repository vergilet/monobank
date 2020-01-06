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

## Endpoints

#### Bank Currency

##### API Method: [operation--bank-currency-get](https://api.monobank.ua/docs/#operation--bank-currency-get)

```ruby
bank_currency = Monobank.bank_currency
bank_currency       # Array
```

```ruby
some_currency = bank_currency.first
some_currency.class # Monobank::Resources::Bank::Currency
```

```ruby
some_currency.currency_code_a   # Integer, ISO 4217
some_currency.currency_code_a   # Integer, ISO 4217
some_currency.date              # Integer, Unix time in sec (use Time.at)
some_currency.rate_sell         # Float
some_currency.rate_buy          # Float
some_currency.rate_cross        # Float
```

#### Client Info

##### API Method: [operation--personal-client-info-get](https://api.monobank.ua/docs/#operation--personal-client-info-get)

```ruby
client_info = Monobank.client_info(token: YOUR_MONO_TOKEN)
client_info     # Monobank::Resources::Personal::ClientInfo
```
```ruby
client_info.name                # String, client name
client_info.web_hook_url        # String, webhook url 
client_info.accounts            # array of accounts (type Monobank::Resources::Personal::Account)
```
##### Account

```ruby
account = client_info.accounts.first
account     # Monobank::Resources::Personal::Account
```
```ruby
account.id                      # String, Account identifier
account.balance                 # Integer, Balance in cents
account.credit_limit            # Integer, Credit limit
account.currency_code           # Integer, ISO 4217
account.cashback_type           # String, None, UAH, Miles 
```

#### Statement

##### API Method: [operation--personal-statement--account---from---to--get](https://api.monobank.ua/docs/#operation--personal-statement--account---from---to--get)

```ruby
account_id = ACCOUNT_ID     # Integer, ClientInfo -> Account ID
from = 1575721820           # Integer, Unix time in sec (use Time.at)

statements = Monobank.statement(token: MONO_TOKEN, account_id: ACCOUNT_ID, from: 1575721820)
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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/monobank. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/monobank/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Monobank project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/monobank/blob/master/CODE_OF_CONDUCT.md).

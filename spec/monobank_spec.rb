describe Monobank do
  let(:token) { 'FAKE_TOKEN' }

  context '.bank_currency' do
    before do
      stub_request(:get, "https://api.monobank.ua/bank/currency").
        with(headers: {'X-Token' => ''}).
        to_return(
          status: 200,
          body: [
            {
              'currencyCodeA' => 840,
              'currencyCodeB' => 980,
              'date' => 1552392228,
              'rateSell' => 27,
              'rateBuy' => 27.2,
              'rateCross' => 27.1
            }
          ].to_json,
          headers: {'Content-Type' => 'application/json'}
        )
    end

    it 'returns correct data' do
      result = Monobank.bank_currency
      expect(result.first.currency_code_a).to eq 840
    end
  end

  context '.client_info' do
    before do
      stub_request(:get, "https://api.monobank.ua/personal/client-info").
        with(headers: {'X-Token' => 'FAKE_TOKEN'}).
        to_return(
          status: 200,
          body: {
            "clientId": "3MSaMMtczs",
            "name": "Мазепа Іван",
            "webHookUrl": "https://example.com/some_random_data_for_security",
            "permissions": "psfj",
            "accounts": [
              {
                "id": "kKGVoZuHWzqVoZuH",
                "sendId": "uHWzqVoZuH",
                "balance": 10000000,
                "creditLimit": 10000000,
                "type": "black",
                "currencyCode": 980,
                "cashbackType": "UAH",
                "maskedPan": [
                  "537541******1234"
                ],
                "iban": "UA733220010000026201234567890"
              }
            ],
            "jars": [
              {
                "id": "kKGVoZuHWzqVoZuH",
                "sendId": "uHWzqVoZuH",
                "title": "На тепловізор",
                "description": "На тепловізор",
                "currencyCode": 980,
                "balance": 1000000,
                "goal": 10000000
              }
            ]
          }.to_json,
          headers: {'Content-Type' => 'application/json'}
        )
    end

    it 'returns correct data' do
      result = Monobank.client_info(token:)
      expect(result.name).to eq 'Мазепа Іван'
      expect(result.accounts.length).to eq 1
    end
  end

  context '.statement' do
    before do
      stub_request(:get, "https://api.monobank.ua/personal/statement/0/1546304461").
        with(headers: {'X-Token' => 'FAKE_TOKEN'}).
        to_return(
          status: 200,
          body: [
            {
              "id": "ZuHWzqkKGVo=",
              "time": 1554466347,
              "description": "Покупка щастя",
              "mcc": 7997,
              "originalMcc": 7997,
              "hold": false,
              "amount": -95000,
              "operationAmount": -95000,
              "currencyCode": 980,
              "commissionRate": 0,
              "cashbackAmount": 19000,
              "balance": 10050000,
              "comment": "За каву",
              "receiptId": "XXXX-XXXX-XXXX-XXXX",
              "invoiceId": "2103.в.27",
              "counterEdrpou": "3096889974",
              "counterIban": "UA898999980000355639201001404",
              "counterName": "ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ «ВОРОНА»"
            }
          ].to_json,
          headers: {'Content-Type' => 'application/json'}
        )
    end

    it 'returns correct data' do
      result = Monobank.statement(token:, account_id: 0, from: 1546304461)
      expect(result.first.id).to eq 'ZuHWzqkKGVo='
      expect(result.first.amount).to eq -95000
      expect(result.first.currency_code).to eq 980
    end
  end

  context '.set_webhook' do
    before do
      stub_request(:post, "https://api.monobank.ua/personal/webhook").
        with(
          body: {'webHookUrl': 'https://example.com/some_random_data_for_security'}.to_json,
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Ruby',
            'X-Token'=>'FAKE_TOKEN'
          }).
        to_return(status: 200, body: {'status' => 'ok'}.to_json, headers: {'Content-Type' => 'application/json'})
    end

    it 'returns correct data' do
      result = Monobank.set_webhook(token:, url: 'https://example.com/some_random_data_for_security')

      expect(result.status).to eq 'ok'
    end
  end
end

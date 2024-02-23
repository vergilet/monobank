describe Monobank::Corporate do
  let(:key_id) { nil }

  before do
    allow(Time).to receive(:now).and_return(Time.parse('2024-01-31'))

    fake_private_key = OpenSSL::PKey::EC.new
    allow(fake_private_key).to(receive(:sign)) { |_, args| "__SIGNED__#{args}" }
    allow_any_instance_of(Monobank::Auth::Corporate).to receive(:init_key).and_return(fake_private_key)

    allow(Base64).to(receive(:strict_encode64)) { |arg| "__BASE64__#{arg}" }

    Monobank::Corporate.configure(private_key: 'FAKE PRIVATE KEY', key_id:)
  end

  context '.registration' do
    before do
      stub_request(:post, 'https://api.monobank.ua/personal/auth/registration').
        with(
          body: {
            "pubkey": "LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUZZd0VBWUhLb1pJemow...",
            "name": "ТОВ \"Ворона\"",
            "description": "Ми робимо найрозумніший PFM з усіх можливих і нам потрібен доступ до виписка користувача, щоб створювати красиву статистику",
            "contactPerson": "Роман Шевченко",
            "phone": "380671234567",
            "email": "etс@example.com",
            "logo": "iVBORw0KGgoAAAANSUhEUgAAAUAAAACECAYAAADhnvK8AAAapElEQVR42..."
          }.to_json,
          headers: {
            'X-Sign'=>'__BASE64____SIGNED__1706652000/personal/auth/registration',
            'X-Time'=>'1706652000'
          }).
        to_return(status: 200, body: { status: 'New' }.to_json, headers: {'Content-Type' => 'application/json'})
    end

    it 'returns correct data' do
      result = Monobank::Corporate.registration(
        public_key: 'LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUZZd0VBWUhLb1pJemow...',
        name: 'ТОВ "Ворона"',
        description: 'Ми робимо найрозумніший PFM з усіх можливих і нам потрібен доступ до виписка користувача, щоб створювати красиву статистику',
        contact_person: 'Роман Шевченко',
        phone: '380671234567',
        email: 'etс@example.com',
        logo: 'iVBORw0KGgoAAAANSUhEUgAAAUAAAACECAYAAADhnvK8AAAapElEQVR42...'
      )

      expect(result.status).to eq 'New'
    end
  end

  context '.registration_status' do
    before do
      stub_request(:post, 'https://api.monobank.ua/personal/auth/registration/status').
        with(
          body: {
            "pubkey": "LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUZZd0VBWUhLb1pJemow..."
          }.to_json,
          headers: {
            'X-Sign' => '__BASE64____SIGNED__1706652000/personal/auth/registration/status',
            'X-Time' => '1706652000'
          }).
        to_return(
          status: 200,
          body: { status: 'Approved', keyId: '28a75537175a018645e6f8b14be7681791e701e0' }.to_json,
          headers: {'Content-Type' => 'application/json'}
        )
    end

    it 'returns correct data' do
      result = Monobank::Corporate.registration_status(public_key: 'LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUZZd0VBWUhLb1pJemow...')

      expect(result.status).to eq 'Approved'
      expect(result.key_id).to eq '28a75537175a018645e6f8b14be7681791e701e0'
    end
  end

  context 'with key_id' do
    let(:key_id) { '28a75537175a018645e6f8b14be7681791e701e0' }

    context '.set_webhook' do
      before do
        stub_request(:post, 'https://api.monobank.ua/personal/corp/webhook').
          with(
            body: {'webHookUrl': 'https://example.com/some_random_data_for_security'}.to_json,
            headers: {
              'X-Key-Id' => '28a75537175a018645e6f8b14be7681791e701e0',
              'X-Sign' => '__BASE64____SIGNED__1706652000/personal/corp/webhook',
              'X-Time' => '1706652000'
            }).
          to_return(status: 200, body: {'status' => 'ok'}.to_json, headers: {'Content-Type' => 'application/json'})
      end

      it 'returns correct data' do
        result = Monobank::Corporate.set_webhook(url: 'https://example.com/some_random_data_for_security')

        expect(result.status).to eq 'ok'
      end
    end

    context '.settings' do
      before do
        stub_request(:post, 'https://api.monobank.ua/personal/corp/settings').
          with(
            headers: {
              'X-Key-Id' => '28a75537175a018645e6f8b14be7681791e701e0',
              'X-Sign' => '__BASE64____SIGNED__1706652000/personal/corp/settings',
              'X-Time' => '1706652000'
            }).
          to_return(
            status: 200,
            body: {
              "pubkey": "LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUZZd0VBWUhLb1pJemow...",
              "name": "Компанія",
              "permission": "psf",
              "logo": "iVBORw0KGgoAAAANSUhEUgAAAUAAAACECAYAAADhnvK8AAAapElEQVR42...",
              "webhook": "https://example.com/mono/corp/webhook/maybesomegibberishuniquestringbutnotnecessarily"
            }.to_json,
            headers: {'Content-Type' => 'application/json'}
          )
      end

      it 'returns correct data' do
        result = Monobank::Corporate.settings

        expect(result.name).to eq 'Компанія'
        expect(result.webhook).to eq 'https://example.com/mono/corp/webhook/maybesomegibberishuniquestringbutnotnecessarily'
      end
    end

    context '.auth_request' do
      let(:headers) { {} }

      before do
        stub_request(:post, 'https://api.monobank.ua/personal/auth/request').
          with(
            headers: {
              'X-Key-Id' => '28a75537175a018645e6f8b14be7681791e701e0',
              'X-Sign' => '__BASE64____SIGNED__1706652000/personal/auth/request',
              'X-Time' => '1706652000',
              **headers
            }).
          to_return(
            status: 200,
            body: {
              "tokenRequestId": "uLkwh3NzFAfEkj7urj5C7AU_",
              "acceptUrl": "https://mbnk.app/auth/uLkwh3NzFAfEkj7urj5C7AU_"
            }.to_json,
            headers: {'Content-Type' => 'application/json'}
          )
      end

      it 'returns correct data' do
        result = Monobank::Corporate.auth_request

        expect(result.request_id).to eq 'uLkwh3NzFAfEkj7urj5C7AU_'
        expect(result.accept_url).to eq 'https://mbnk.app/auth/uLkwh3NzFAfEkj7urj5C7AU_'
      end

      context 'when a callback is passed' do
        let(:headers) { {'X-Callback' => 'https://example.com' }}

        it 'returns passes it as headers' do
          result = Monobank::Corporate.auth_request(callback: 'https://example.com')

          expect(result.request_id).to eq 'uLkwh3NzFAfEkj7urj5C7AU_'
          expect(result.accept_url).to eq 'https://mbnk.app/auth/uLkwh3NzFAfEkj7urj5C7AU_'
        end
      end
    end

    context 'with request_id' do
      let(:request_id) { 'uLkwh3NzFAfEkj7urj5C7AU_' }

      context '.auth_check' do
        before do
          stub_request(:get, 'https://api.monobank.ua/personal/auth/request').
            with(
              headers: {
                'X-Key-Id' => '28a75537175a018645e6f8b14be7681791e701e0',
                'X-Request-Id' => 'uLkwh3NzFAfEkj7urj5C7AU_',
                'X-Sign' => '__BASE64____SIGNED__1706652000uLkwh3NzFAfEkj7urj5C7AU_/personal/auth/request',
                'X-Time' => '1706652000'
              }).
            to_return(
              status: 200,
              body: { status: 'ok' }.to_json,
              headers: {'Content-Type' => 'application/json'}
            )
        end

        it 'returns correct data' do
          result = Monobank::Corporate.auth_check(request_id:)

          expect(result.status).to eq 'ok'
        end
      end

      context '.client_info' do
        before do
          stub_request(:get, 'https://api.monobank.ua/personal/client-info').
            with(
              headers: {
                'X-Key-Id' => '28a75537175a018645e6f8b14be7681791e701e0',
                'X-Request-Id' => 'uLkwh3NzFAfEkj7urj5C7AU_',
                'X-Sign' => '__BASE64____SIGNED__1706652000uLkwh3NzFAfEkj7urj5C7AU_/personal/client-info',
                'X-Time' => '1706652000'
              }).
            to_return(
              status: 200,
              body: {
                "clientId": "3MSaMMtczs",
                "name": "Мазепа Іван",
                "webHookUrl": "https://mysomesite.copm/some_random_data_for_security",
                "permissions": "psf",
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
                ]
              }.to_json,
              headers: {'Content-Type' => 'application/json'}
            )
        end

        it 'returns correct data' do
          result = Monobank::Corporate.client_info(request_id:)

          expect(result.name).to eq 'Мазепа Іван'
          expect(result.accounts.length).to eq 1
        end
      end

      context '.statement' do
        before do
          stub_request(:get, 'https://api.monobank.ua/personal/statement/0/1546304461').
            with(
              headers: {
                'X-Key-Id' => '28a75537175a018645e6f8b14be7681791e701e0',
                'X-Request-Id' => 'uLkwh3NzFAfEkj7urj5C7AU_',
                'X-Sign' => '__BASE64____SIGNED__1706652000uLkwh3NzFAfEkj7urj5C7AU_/personal/statement/0/1546304461',
                'X-Time' => '1706652000'
              }).
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
                  "counterEdrpou": "3096889974",
                  "counterIban": "UA898999980000355639201001404",
                  "counterName": "ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ «ВОРОНА»"
                }
              ].to_json,
              headers: {'Content-Type' => 'application/json'}
            )
        end

        it 'returns correct data' do
          result = Monobank::Corporate.statement(request_id:, account_id: 0, from: 1546304461)

          expect(result.first.id).to eq 'ZuHWzqkKGVo='
          expect(result.first.amount).to eq -95000
          expect(result.first.currency_code).to eq 980
        end
      end
    end
  end
end

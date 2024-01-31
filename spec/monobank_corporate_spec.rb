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
  end
end

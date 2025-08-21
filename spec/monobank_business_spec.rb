describe Monobank::Business do
  let(:token) { 'very-secret-business-api-token' }

  after do
    Monobank::Business.instance_variable_set(:@client, nil)
    Monobank::Business.instance_variable_set(:@token, nil)
  end

  context 'when not configured' do
    it 'raises a configuration error' do
      expect { Monobank::Business.statement(account: 'iban', from: 1) }.to raise_error(RuntimeError, /Monobank::Business not configured/)
    end
  end

  context 'when configured' do
    before do
      Monobank::Business.configure(token: token)
    end

    let(:iban) { 'UA753220010000026202340272045' }
    let(:from_time) { 1719472800 }
    let(:to_time) { 1719472805 }
    
    describe '.statement (list)' do
      before do
        stub_request(:get, "https://corp-api.monobank.ua/ext/v1/statement/#{iban}/#{from_time}/#{to_time}")
          .with(query: { 'limit' => 10 }, headers: { 'X-Token' => token })
          .to_return(status: 200, body: [{ "id": "tx_list_item_1" }].to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns an array of statement resources' do
        result = Monobank::Business.statement(account: iban, from: from_time, to: to_time, limit: 10)
        expect(result).to be_an(Array)
        expect(result.first).to be_a(Monobank::Resources::Business::Statement)
        expect(result.first.id).to eq('tx_list_item_1')
      end
    end

    describe '.statement_item (single)' do
      let(:payment_id) { 'ea4f9218-d134-431a-9169-88acab4454c9' }
      
      before do
        stub_request(:get, "https://corp-api.monobank.ua/ext/v1/statement")
          .with(query: { 'id' => payment_id }, headers: { 'X-Token' => token })
          .to_return(status: 200, body: { "id": payment_id, "amount": 12345 }.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a single statement resource' do
        result = Monobank::Business.statement_item(id: payment_id)
        expect(result).to be_a(Monobank::Resources::Business::Statement)
        expect(result.id).to eq(payment_id)
        expect(result.amount).to eq(12345)
      end
    end
    
    describe '.accounts (list)' do
      before do
        stub_request(:get, "https://corp-api.monobank.ua/ext/v1/accounts")
          .with(headers: { 'X-Token' => token })
          .to_return(status: 200, body: [{ "iban": "UA...", "currency": 980 }].to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns an array of account resources' do
        result = Monobank::Business.accounts
        expect(result).to be_an(Array)
        expect(result.first).to be_a(Monobank::Resources::Business::Account)
        expect(result.first.iban).to eq("UA...")
      end
    end
    
    describe '.account (single)' do
      before do
        stub_request(:get, "https://corp-api.monobank.ua/ext/v1/accounts/#{iban}")
          .with(headers: { 'X-Token' => token })
          .to_return(status: 200, body: { "iban": iban, "balance": 42.0 }.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a single account resource' do
        result = Monobank::Business.account(iban: iban)
        expect(result).to be_a(Monobank::Resources::Business::Account)
        expect(result.iban).to eq(iban)
        expect(result.balance).to eq(42.0)
      end
    end

    context 'when the API returns an error' do
      before do
        stub_request(:get, /corp-api.monobank.ua/)
          .to_return(status: 403, body: { "errorDescription": "Unknown token" }.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a Monobank::Resources::Error object for all methods' do
        expect(Monobank::Business.statement(account: 'a', from: 1)).to be_a(Monobank::Resources::Error)
        expect(Monobank::Business.statement_item(id: 'a')).to be_a(Monobank::Resources::Error)
        expect(Monobank::Business.accounts).to be_a(Monobank::Resources::Error)
        expect(Monobank::Business.account(iban: 'a')).to be_a(Monobank::Resources::Error)
      end
    end
  end
end
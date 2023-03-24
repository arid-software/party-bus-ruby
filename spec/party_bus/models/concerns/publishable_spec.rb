RSpec.describe Publishable do
  let(:test_class) do
    Class.new(ActiveRecord::Base) do
      include Publishable

      attr_accessor :foo, :bar

      def self.name
        "TestClass"
      end

      def hello
        'say hi!'
      end

      publish_on [:hello]
    end
  end

  describe 'include' do
    it 'decorates methods' do
      expected_request = stub_request(:post, "#{PartyBus.configuration.api_url}/api/v1/connections/#{PartyBus.configuration.connection_id}/events")
        .to_return(status: 200, body: JSON.generate({ success: true }))

      expect(test_class.new.hello).to eq('say hi!')
      expect(expected_request).to have_been_requested
    end

    it 'gracefully handles a request failure' do
      expected_request = stub_request(:post, "#{PartyBus.configuration.api_url}/api/v1/connections/#{PartyBus.configuration.connection_id}/events")
        .to_return(status: 500)

      expect(test_class.new.hello).to eq('say hi!')
      expect(expected_request).to have_been_requested
    end

    it 'gracefully handles an exception' do
      expected_request = stub_request(:post, "#{PartyBus.configuration.api_url}/api/v1/connections/#{PartyBus.configuration.connection_id}/events")

      expect(PartyBus::Events::Create).to receive(:perform_using)
        .and_raise(StandardError)

      expect(test_class.new.hello).to eq('say hi!')
      expect(expected_request).to_not have_been_requested
    end
  end
end

require 'karafka/testing'
require 'karafka/testing/spec_consumer_client'
require 'karafka/testing/spec_producer_client'
require 'karafka/testing/proxy'

module Karafka
  module Testing
    module Minitest
      module TestHelper
        include Karafka::Testing

        def before_setup
          super

          @karafka = Karafka::Testing::Proxy.new(self)
          @_karafka_consumer_messages = []
          @_karafka_producer_client = Karafka::Testing::SpecProducerClient.new(self)
          @_karafka_consumer_client = Karafka::Testing::SpecConsumerClient.new

          if Object.const_defined?('Mocha', false)
            Karafka.producer.stubs(:client).returns(@_karafka_producer_client)
          else
            @_karafka_previous_client = Karafka.producer.client
            Karafka.producer.instance_variable_set(:@client, @_karafka_producer_client)
          end

          _karafka_consumer_messages.clear
          _karafka_producer_client.reset
        end

        def after_teardown
          @karafka = nil
          @_karafka_consumer_messages = nil
          @_karafka_producer_client = nil
          @_karafka_consumer_client = nil

          if @_karafka_previous_client
            Karafka.producer.instance_variable_set(:@client, @_karafka_previous_client)
            @_karafka_previous_client = nil
          end

          super
        end

        def karafka
          @karafka
        end

        def _karafka_consumer_messages
          @_karafka_consumer_messages
        end

        def _karafka_producer_client
          @_karafka_producer_client
        end

        def _karafka_consumer_client
          @_karafka_consumer_client
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'waterdrop'
require 'karafka/testing'
require 'karafka/testing/spec_consumer_client'
require 'karafka/testing/spec_producer_client'
require 'karafka/testing/proxy'

module Karafka
  module Testing
    # All the things related to extra functionalities needed to easier spec out
    # Karafka things using RSpec
    module RSpec
      # RSpec helpers module that needs to be included
      module Helpers
        class << self
          # Adds all the needed extra functionalities to the rspec group
          # @param base [Class] RSpec example group we want to extend
          def included(base)
            base.include Karafka::Testing

            # RSpec local reference to Karafka proxy that allows us to build the consumer instance
            base.let(:karafka) { Karafka::Testing::Proxy.new(self) }

            # Messages that are targeted to the consumer
            # You can produce many messages from Karafka during specs and not all should go to the
            # consumer for processing. This buffer holds only those that should go to consumer
            base.let(:_karafka_consumer_messages) { [] }
            # Consumer fake client to mock communication with Kafka
            base.let(:_karafka_consumer_client) { Karafka::Testing::SpecConsumerClient.new }
            # Producer fake client to mock communication with Kafka
            base.let(:_karafka_producer_client) { Karafka::Testing::SpecProducerClient.new(self) }

            base.prepend_before do
              _karafka_consumer_messages.clear
              _karafka_producer_client.reset

              if Object.const_defined?('Mocha', false)
                Karafka.producer.stubs(:client).returns(_karafka_producer_client)
              else
                allow(Karafka.producer).to receive(:client).and_return(_karafka_producer_client)
              end
            end
          end
        end
      end
    end
  end
end

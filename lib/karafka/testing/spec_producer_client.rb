# frozen_string_literal: true

module Karafka
  module Testing
    # Spec producer client used to buffer messages that we send out in specs
    class SpecProducerClient < ::WaterDrop::Clients::Buffered
      # @param context [RSpec::Core::ExampleGroup, Minitest::Test] current example
      #   context (rspec) or test (minitest)
      def initialize(context)
        super(nil)
        @context = context
      end

      # "Produces" message to Kafka. That is, it acknowledges it locally, adds it to the internal
      # buffer and adds it (if needed) into the current consumer messages buffer
      # @param message [Hash] `Karafka.producer.produce_sync` message hash
      def produce(message)
        @context._karafka_add_message_to_consumer_if_needed(message)

        super
      end
    end
  end
end

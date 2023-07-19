# frozen_string_literal: true

module Karafka
  module Testing
    # Proxy object for a nicer `karafka.` API within RSpec or Minitest
    # None other should be used by the end users
    class Proxy
      # @param context [RSpec::ExampleGroups, Minitest::Test] current example
      def initialize(context)
        @context = context
      end

      # @param args Anything that the `#_karafka_consumer_for` accepts
      def consumer_for(*args)
        @context._karafka_consumer_for(*args)
      end

      # @param args Anything that `#_karafka_produce` accepts
      def produce(*args)
        @context._karafka_produce(*args)
      end

      # @return [Array<Hash>] messages produced via `Karafka#producer`
      def produced_messages
        @context._karafka_produced_messages
      end
    end
  end
end

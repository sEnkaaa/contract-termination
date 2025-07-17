require 'date'

module ContractTermination
  module Iard
    class Contract
      VALID_CONTRACT_TYPES = %i[iard].freeze

      attr_reader :contract_type, :initial_effective_start_date

      def initialize(contract_type:, initial_effective_start_date:)
        @contract_type = contract_type
        @initial_effective_start_date = initial_effective_start_date

        validate!
      end

      def current_effective_start_date(reference_date = Date.today)
        date = initial_effective_start_date
        date = date.next_year while date.next_year <= reference_date
        date
      end

      def renewed?(reference_date = Date.today)
        current_effective_start_date(reference_date) != initial_effective_start_date
      end

      private

      def validate!
        unless VALID_CONTRACT_TYPES.include?(contract_type)
          raise ArgumentError,
                "Invalid contract_type: #{contract_type.inspect}. Valid types: #{VALID_CONTRACT_TYPES.join(', ')}"
        end

        return if initial_effective_start_date.is_a?(Date)

        raise ArgumentError, "initial_effective_start_date must be a Date (got #{initial_effective_start_date.class})"
      end
    end
  end
end

module ContractTermination
  module Iard
    class TerminationRequest
      attr_reader :contract, :requested_termination_date

      def initialize(contract:, requested_termination_date:)
        @contract = contract
        @requested_termination_date = requested_termination_date

        validate!
      end

      private

      def validate!
        unless contract.is_a?(ContractTermination::Iard::Contract)
          raise ArgumentError, 'contract must be a ContractTermination::Contract'
        end
        raise ArgumentError, 'requested_termination_date must be a Date' unless requested_termination_date.is_a?(Date)
      end
    end
  end
end

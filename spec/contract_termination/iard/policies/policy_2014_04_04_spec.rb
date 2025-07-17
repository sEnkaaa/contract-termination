require 'spec_helper'
require_relative '../../../../lib/contract_termination/iard/policies/policy_2014_04_04'
require_relative '../../../../lib/contract_termination/iard/contract'
require_relative '../../../../lib/contract_termination/iard/termination_request'
require 'date'

RSpec.describe ContractTermination::Iard::Policies::Policy20140404 do
  describe '.earliest_termination_date' do
    let(:contract_start_date) { Date.new(2022, 4, 1) }
    let(:contract) do
      ContractTermination::Iard::Contract.new(
        contract_type: :iard,
        initial_effective_start_date: contract_start_date
      )
    end

    context 'when requested before notice deadline' do
      it 'returns the next renewal date' do
        requested_date = Date.new(2024, 12, 1)

        termination_request = ContractTermination::Iard::TerminationRequest.new(
          contract: contract,
          requested_termination_date: requested_date
        )

        result = described_class.earliest_termination_date(termination_request)
        expect(result).to eq(Date.new(2025, 4, 1))
      end
    end

    context 'when requested after notice deadline' do
      it 'returns the following year\'s renewal date' do
        requested_date = Date.new(2025, 1, 10)

        termination_request = ContractTermination::Iard::TerminationRequest.new(
          contract: contract,
          requested_termination_date: requested_date
        )

        result = described_class.earliest_termination_date(termination_request)
        expect(result).to eq(Date.new(2026, 4, 1))
      end
    end
  end
end

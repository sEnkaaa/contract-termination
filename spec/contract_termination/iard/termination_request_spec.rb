require 'spec_helper'
require 'date'
require_relative '../../../lib/contract_termination/iard/termination_request'
require_relative '../../../lib/contract_termination/iard/contract'

RSpec.describe ContractTermination::Iard::TerminationRequest do
  let(:contract) do
    ContractTermination::Iard::Contract.new(
      contract_type: :iard,
      initial_effective_start_date: Date.new(2024, 1, 1)
    )
  end

  describe '#initialize' do
    it 'accepts a valid contract and requested_termination_date' do
      request = described_class.new(
        contract: contract,
        requested_termination_date: Date.new(2025, 1, 1)
      )
      expect(request.contract).to eq(contract)
      expect(request.requested_termination_date).to eq(Date.new(2025, 1, 1))
    end

    it 'raises ArgumentError if requested_termination_date is not a Date' do
      expect do
        described_class.new(
          contract: contract,
          requested_termination_date: '2025-01-01'
        )
      end.to raise_error(ArgumentError, /requested_termination_date must be a Date/)
    end
  end
end

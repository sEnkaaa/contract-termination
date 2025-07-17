require 'spec_helper'
require_relative '../../../../lib/contract_termination/iard/policies/policy_2024_10_01'
require_relative '../../../../lib/contract_termination/iard/policies/policy_2014_04_04'
require_relative '../../../../lib/contract_termination/iard/contract'
require_relative '../../../../lib/contract_termination/iard/termination_request'
require 'date'

RSpec.describe ContractTermination::Iard::Policies::Policy20241001 do
  describe '.earliest_termination_date' do
    let(:contract_start_date) { Date.new(2024, 11, 1) }

    let(:contract) do
      ContractTermination::Iard::Contract.new(
        contract_type: :iard,
        initial_effective_start_date: contract_start_date
      )
    end

    context 'when contract has not yet been renewed' do
      it 'delegates to Policy20140404' do
        request_date = Date.new(2025, 6, 1)

        request = ContractTermination::Iard::TerminationRequest.new(
          contract: contract,
          requested_termination_date: request_date
        )

        allow(contract).to receive(:renewed?).with(request_date).and_return(false)
        allow(contract).to receive(:current_effective_start_date).with(request_date)

        expect(ContractTermination::Iard::Policies::Policy20140404)
          .to receive(:earliest_termination_date)
          .with(request)

        described_class.earliest_termination_date(request)
      end
    end

    context 'when contract has been renewed' do
      it 'returns requested date + 2 months' do
        request_date = Date.new(2025, 12, 1)

        request = ContractTermination::Iard::TerminationRequest.new(
          contract: contract,
          requested_termination_date: request_date
        )

        allow(contract).to receive(:renewed?).with(request_date).and_return(true)
        allow(contract).to receive(:current_effective_start_date).with(request_date)

        result = described_class.earliest_termination_date(request)
        expect(result).to eq(Date.new(2026, 2, 1))
      end
    end
  end
end

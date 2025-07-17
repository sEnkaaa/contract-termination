require_relative '../../lib/contract_termination/policy_selector'
require_relative '../../lib/contract_termination/termination_request'

RSpec.describe ContractTermination::PolicySelector do
  describe '.select_policy' do
    context 'with iard contract' do
      it 'returns Policy20241001 if contract started on or after 2024-10-01' do
        contract = ContractTermination::Contract.new(
          contract_type: :iard,
          initial_effective_start_date: Date.new(2024, 10, 1)
        )
        request = ContractTermination::TerminationRequest.new(
          contract: contract,
          requested_termination_date: Date.new(2025, 1, 1)
        )

        result = described_class.select_policy(request)
        expect(result).to eq(ContractTermination::Policies::Policy20241001)
      end

      it 'returns Policy20140404 if contract started before 2024-10-01' do
        contract = ContractTermination::Contract.new(
          contract_type: :iard,
          initial_effective_start_date: Date.new(2024, 9, 30)
        )
        request = ContractTermination::TerminationRequest.new(
          contract: contract,
          requested_termination_date: Date.new(2025, 1, 1)
        )

        result = described_class.select_policy(request)
        expect(result).to eq(ContractTermination::Policies::Policy20140404)
      end
    end

    context 'with contract having unsupported type' do
      it 'raises NotImplementedError in select_policy' do
        fake_contract = instance_double('FakeContract',
                                        contract_type: :life,
                                        initial_effective_start_date: Date.new(2024, 9, 30))

        allow(fake_contract).to receive(:is_a?).with(ContractTermination::Contract).and_return(true)

        request = ContractTermination::TerminationRequest.new(
          contract: fake_contract,
          requested_termination_date: Date.new(2025, 1, 1)
        )

        expect do
          described_class.select_policy(request)
        end.to raise_error(NotImplementedError, /not implemented/i)
      end
    end

    context 'with invalid contract object' do
      it 'raises ArgumentError if contract is not a Contract instance' do
        fake_contract = instance_double('FakeContract')

        expect do
          ContractTermination::TerminationRequest.new(
            contract: fake_contract,
            requested_termination_date: Date.new(2025, 1, 1)
          )
        end.to raise_error(ArgumentError, /contract must be a ContractTermination::Contract/)
      end
    end
  end
end

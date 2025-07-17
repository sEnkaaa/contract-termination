require 'spec_helper'
require_relative '../../../lib/contract_termination/policies/base_policy'
require_relative '../../../lib/contract_termination/policies/policy_2014_04_04'
require_relative '../../../lib/contract_termination/policies/policy_2024_10_01'
require_relative '../../../lib/contract_termination/termination_request'
require_relative '../../../lib/contract_termination/contract'
require 'date'

RSpec.describe ContractTermination::Policies do
  describe ContractTermination::Policies::BasePolicy do
    describe '.earliest_termination_date' do
      it 'raises NotImplementedError when called directly' do
        contract = ContractTermination::Contract.new(
          contract_type: :iard,
          initial_effective_start_date: Date.new(2024, 1, 1)
        )
        termination_request = ContractTermination::TerminationRequest.new(
          contract: contract,
          requested_termination_date: Date.today
        )

        expect do
          described_class.earliest_termination_date(termination_request)
        end.to raise_error(NotImplementedError, /Subclasses must implement/)
      end
    end
  end

  describe 'Concrete Policies implementation' do
    let(:contract) do
      ContractTermination::Contract.new(
        contract_type: :iard,
        initial_effective_start_date: Date.new(2023, 1, 1)
      )
    end

    let(:termination_request) do
      ContractTermination::TerminationRequest.new(
        contract: contract,
        requested_termination_date: Date.today
      )
    end

    [
      ContractTermination::Policies::Policy20140404,
      ContractTermination::Policies::Policy20241001
    ].each do |policy_class|
      it "#{policy_class} implements earliest_termination_date without raising error" do
        expect do
          policy_class.earliest_termination_date(termination_request)
        end.not_to raise_error
      end
    end
  end
end

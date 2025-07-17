require 'date'
require_relative 'contract_termination/contract'
require_relative 'contract_termination/termination_request'
require_relative 'contract_termination/policy_selector'

module ContractTermination
  def self.earliest_termination_date(contract_type:, contract_initial_effective_start_date:,
                                     requested_termination_date: Date.today)
    contract = Contract.new(
      contract_type: contract_type,
      initial_effective_start_date: contract_initial_effective_start_date
    )
    termination_request = TerminationRequest.new(
      contract: contract,
      requested_termination_date: requested_termination_date
    )
    policy = PolicySelector.select_policy(termination_request)
    policy.earliest_termination_date(termination_request)
  end
end

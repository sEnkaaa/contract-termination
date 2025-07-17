require 'date'

module ContractTermination
  def self.earliest_termination_date(contract_type:, contract_initial_effective_start_date:,
                                     requested_termination_date: Date.today)
    context_module = case contract_type
                     when :iard
                        require_relative 'contract_termination/iard/contract'
                        require_relative 'contract_termination/iard/termination_request'
                        require_relative 'contract_termination/iard/policy_selector'
                        ContractTermination::Iard
                     else
                        raise NotImplementedError, "Contract type #{contract_type} not supported"
                     end

    contract = context_module::Contract.new(
      contract_type: contract_type,
      initial_effective_start_date: contract_initial_effective_start_date
    )
    termination_request = context_module::TerminationRequest.new(
      contract: contract,
      requested_termination_date: requested_termination_date
    )
    policy = context_module::PolicySelector.select_policy(termination_request)
    policy.earliest_termination_date(termination_request)
  end
end

require_relative "base_policy"
require_relative "policy_2014_04_04"

module ContractTermination
    module Policies
        class Policy20241001 < BasePolicy
            NOTICE_MONTHS = 2

            def self.earliest_termination_date(termination_request)
                contract = termination_request.contract

                requested_termination_date = termination_request.requested_termination_date
                contract_current_effective_start_date = contract.current_effective_start_date(requested_termination_date)

                return Policy20140404::earliest_termination_date(termination_request) unless contract.renewed?(requested_termination_date)
                
                termination_effective_date = requested_termination_date.next_month(NOTICE_MONTHS).next_day
                termination_effective_date
            end
        end
    end
end
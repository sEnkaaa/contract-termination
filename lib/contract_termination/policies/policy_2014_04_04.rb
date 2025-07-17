require_relative "base_policy"

require 'date'

module ContractTermination
    module Policies
        class Policy20140404 < BasePolicy
            NOTICE_MONTHS = 3

            def self.earliest_termination_date(termination_request)
                contract = termination_request.contract

                requested_termination_date = termination_request.requested_termination_date
                contract_effective_start_date = contract.current_effective_start_date(requested_termination_date)
                  
                contract_renewal_date = contract_effective_start_date.next_year
                termination_notice_deadline = (contract_renewal_date << NOTICE_MONTHS).prev_day

                if requested_termination_date <= termination_notice_deadline
                    contract_renewal_date
                else
                    contract_renewal_date.next_year
                end
            end
        end
    end
end
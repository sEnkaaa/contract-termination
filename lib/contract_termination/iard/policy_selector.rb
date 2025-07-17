require_relative 'policies/policy_2014_04_04'
require_relative 'policies/policy_2024_10_01'

module ContractTermination
  module Iard
    module PolicySelector
      def self.select_policy(termination_request)
        contract = termination_request.contract

        case contract.contract_type
        when :iard
          if contract.current_effective_start_date(termination_request.requested_termination_date) >= Date.new(2024, 10,
                                                                                                               1)
            Policies::Policy20241001
          else
            Policies::Policy20140404
          end
        else
          raise NotImplementedError, 'This contract type is not implemented yet'
        end
      end
    end
  end
end

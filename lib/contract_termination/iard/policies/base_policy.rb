module ContractTermination
  module Iard
    module Policies
      class BasePolicy
        def self.earliest_termination_date(termination_request)
          raise NotImplementedError, 'Subclasses must implement `earliest_termination_date`'
        end
      end
    end
  end
end

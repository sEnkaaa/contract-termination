require 'spec_helper'
require_relative '../lib/contract_termination'

RSpec.describe ContractTermination do
  describe '.earliest_termination_date' do
    context 'when contract started before 2024-10-01' do
      it 'uses the 2014 policy and terminates at the first renewal date when notice is given in time' do
        result = described_class.earliest_termination_date(
          contract_type: :iard,
          contract_initial_effective_start_date: Date.new(2023, 11, 1),
          requested_termination_date: Date.new(2024, 7, 1)
        )

        expect(result).to eq(Date.new(2024, 11, 1))
      end

      it 'uses the 2014 policy and terminates at the next renewal date when notice is not given in time' do
        result = described_class.earliest_termination_date(
          contract_type: :iard,
          contract_initial_effective_start_date: Date.new(2023, 11, 1),
          requested_termination_date: Date.new(2024, 10, 1)
        )

        expect(result).to eq(Date.new(2025, 11, 1))
      end
    end

    context 'when contract started after 2024-10-01 and has been renewed' do
      it 'uses the 2024 policy and applies 2 months notice' do
        result = described_class.earliest_termination_date(
          contract_type: :iard,
          contract_initial_effective_start_date: Date.new(2024, 10, 2),
          requested_termination_date: Date.new(2025, 11, 1)
        )

        expect(result).to eq(Date.new(2026, 1, 1))
      end
    end

    context 'when contract started after 2024-10-01, has not been renewed and fallbacks on the former 2014 policy' do
      it 'uses the 2014 policy and terminates at the first renewal date when notice is given in time' do
        result = described_class.earliest_termination_date(
          contract_type: :iard,
          contract_initial_effective_start_date: Date.new(2024, 10, 1),
          requested_termination_date: Date.new(2025, 1, 1)
        )

        expect(result).to eq(Date.new(2025, 10, 1))
      end

      it 'uses the 2014 policy and terminates at the next renewal date when notice is not given in time' do
        result = described_class.earliest_termination_date(
          contract_type: :iard,
          contract_initial_effective_start_date: Date.new(2024, 10, 1),
          requested_termination_date: Date.new(2025, 9, 1)
        )

        expect(result).to eq(Date.new(2026, 10, 1))
      end
    end

    context 'when contract type is invalid' do
      it 'raises an error' do
        expect do
          described_class.earliest_termination_date(
            contract_type: :health,
            contract_initial_effective_start_date: Date.new(2024, 3, 1),
            requested_termination_date: Date.new(2024, 8, 1)
          )
        end.to raise_error(ArgumentError, /Invalid contract_type/)
      end
    end
  end
end

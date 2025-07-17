require 'spec_helper'
require 'date'
require_relative '../../../lib/contract_termination/iard/contract'

RSpec.describe ContractTermination::Iard::Contract do
  let(:contract_type) { :iard }
  let(:initial_date) { Date.new(2025, 1, 20) }

  subject { described_class.new(contract_type: contract_type, initial_effective_start_date: initial_date) }

  describe '#current_effective_start_date' do
    context 'when reference_date is before the first anniversary' do
      let(:reference_date) { Date.new(2025, 2, 20) }

      it 'returns the initial effective start date' do
        expect(subject.current_effective_start_date(reference_date)).to eq(initial_date)
      end
    end

    context 'when reference_date is exactly on the first anniversary' do
      let(:reference_date) { Date.new(2026, 1, 20) }

      it 'returns the first anniversary date' do
        expect(subject.current_effective_start_date(reference_date)).to eq(Date.new(2026, 1, 20))
      end
    end

    context 'when reference_date is after multiple anniversaries' do
      let(:reference_date) { Date.new(2028, 4, 20) }

      it 'returns the latest anniversary date before or equal to the reference date' do
        expect(subject.current_effective_start_date(reference_date)).to eq(Date.new(2028, 1, 20))
      end
    end
  end

  describe '#renewed?' do
    context 'when contract is not renewed' do
      let(:reference_date) { Date.new(2025, 2, 20) }

      it 'returns false' do
        expect(subject.renewed?(reference_date)).to be false
      end
    end

    context 'when contract is renewed' do
      let(:reference_date) { Date.new(2026, 3, 20) }

      it 'returns true' do
        expect(subject.renewed?(reference_date)).to be true
      end
    end
  end

  describe 'validations' do
    it 'raises error if contract_type is invalid' do
      expect do
        described_class.new(contract_type: :invalid_type, initial_effective_start_date: initial_date)
      end.to raise_error(ArgumentError, /Invalid contract_type/)
    end

    it 'raises error if initial_effective_start_date is not a Date' do
      expect do
        described_class.new(contract_type: contract_type, initial_effective_start_date: '2023-03-15')
      end.to raise_error(ArgumentError, /initial_effective_start_date must be a Date/)
    end
  end
end

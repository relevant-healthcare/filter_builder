require 'rails_helper'
require 'byebug'

describe FilterBuilder::Form do
  let(:form_model) { described_class.new(filtered_class, params) }
  let(:filtered_class) { Patient }

  describe 'results' do
    let!(:included_patient) do
      Fabricate(
        :patient,
        first_name: 'Jill',
        provider: Fabricate(:provider, npi: 'included')
      )
    end

    let!(:excluded_patient) do
      Fabricate(
        :patient,
        provider: Fabricate(:provider, npi: 'excluded')
      )
    end

    let(:results) { form_model.results }

    context 'when passing hash params on initialize' do
      let(:params) { { provider: { npi: 'included' } } }

      it 'builds a scope with these params' do
        expect(results).to contain_exactly included_patient
      end
    end

    context 'when passing action controller params on initialize' do
      let(:params) do
        ActionController::Parameters.new(first_name: 'NotJill', provider: { npi: 'included' })
                                    .permit(provider: :npi)
      end

      it 'builds a scope with the permitted params' do
        expect(results).to contain_exactly included_patient
      end
    end

    context 'when require_filter is set to true' do
      let(:form_model) { described_class.new(filtered_class, params, true) }

      context 'when params are present' do
        let(:params) { { provider: { npi: 'included' } } }

        it 'builds a scope with these params' do
          expect(results).to contain_exactly included_patient
        end
      end

      context 'when params are empty' do
        let(:params) { {} }

        it 'builds an empty scope' do
          expect(results).to be_empty
        end
      end
    end
  end

  describe 'filter_params_present?' do
    context 'when params are present' do
      context 'with values' do
        let(:params) { { name: 'John Smith' } }

        it 'returns true' do
          expect(form_model.filter_params_present?).to eq(true)
        end
      end

      context 'with empty nested params' do
        let(:params) { { primary_address: { city: '', state: '' } } }

        it 'returns false' do
          expect(form_model.filter_params_present?).to eq(false)
        end
      end

      context 'with all empty values' do
        let(:params) { { name: '', age: '' } }

        it 'returns false' do
          expect(form_model.filter_params_present?).to eq(false)
        end
      end
    end

    context 'when params are empty' do
      let(:params) { {} }

      it 'returns false' do
        expect(form_model.filter_params_present?).to eq(false)
      end
    end
  end
end

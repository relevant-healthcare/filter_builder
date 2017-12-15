require 'rails_helper'

describe FilterBuilder::FormModel do
  let(:form_model) { described_class.new(Patient, params) }

  describe 'results' do
    let!(:included_patient) do
      Fabricate(
        :patient,
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

    context 'when passing params on initialize' do
      let(:params) { { provider: { npi: 'included' } } }

      it 'builds a scope with these params' do
        expect(results).to contain_exactly included_patient
      end
    end

    context 'when setting attributes on the form_model object' do
      let(:params) { nil }

      before { form_model.provider.npi = 'included' }

      it 'builds up the correct scope' do
        expect(results).to contain_exactly included_patient
      end
    end
  end
end

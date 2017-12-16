require 'rails_helper'
require 'byebug'

describe FilterBuilder::FormModel do
  let(:form_model) { described_class.new(filtered_class, params) }
  let(:filtered_class) { Patient }

  describe 'results' do
    let!(:included_patient) do
      Fabricate(
        :patient,
        last_name: 'Ellsberg',
        provider: Fabricate(:provider, npi: 'included'),
        visits: [included_visit]
      )
    end

    let(:included_visit) do
      Fabricate(
        :visit,
        visit_date: Date.new(2016, 1, 1),
        uds_universe: true
      )
    end

    let!(:excluded_patient) do
      Fabricate(
        :patient,
        provider: Fabricate(:provider, npi: 'excluded'),
        visits: [excluded_visit]
      )
    end

    let(:excluded_visit) do
      Fabricate(
        :visit,
        visit_date: Date.new(2016, 1, 1),
        uds_universe: false
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

      it 'builds up the correct scope' do
        form_model.visits.uds_universe = []
        form_model.visits.date_on_or_after = Date.new(2016, 1, 1)
        expect(results).to contain_exactly included_patient
      end

      context 'with empty string values' do
        it 'ignores the empty string values' do
          form_model.a.b.c.d.e.f = ''
          form_model.first_name = ''
          expect(form_model.filter_params).to be_empty
          expect(results).to include included_patient, excluded_patient
        end
      end
    end

    context 'when reading but not writing attributes on the form_model object' do
      let(:filtered_class) { Visit }
      let(:params) { nil }

      before do
        form_model.uds_universe
        form_model.date_on_or_after
      end

      it 'ignores these attributes when building scope' do
        expect(results).to contain_exactly included_visit, excluded_visit
      end
    end
  end
end

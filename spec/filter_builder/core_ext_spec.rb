require 'rails_helper'

describe 'ActiveRecord::Base Extension' do
  describe '.filter' do
    context 'when filtering based on attributes' do
      let!(:included_patient) do
        Fabricate :patient, first_name: 'TestFirst', last_name: 'TestLast'
      end

      let!(:excluded_first_name_patient) do
        Fabricate :patient, first_name: 'SomethingElse', last_name: 'TestLast'
      end

      let!(:excluded_last_name_patient) do
        Fabricate :patient, first_name: 'TestFirst', last_name: 'SomethingElse'
      end

      let(:filter_params) do
        { first_name: 'TestFirst', last_name: 'TestLast' }
      end

      it 'includes records with the specified fields' do
        expect(Patient.filter(filter_params)).to contain_exactly included_patient
      end
    end

    context 'when filtering based on joined classes' do
      let!(:included_patient) { Fabricate :patient, visits: [visit] }
      let(:visit) { Fabricate :visit, provider: provider }
      let(:provider) { Fabricate :provider, npi: 'some_npi' }
      let!(:excluded_visit_patient) { Fabricate :patient }

      let(:filter_params) { { visits: { provider: { npi: 'some_npi' } } } }

      it 'includes records with the specified fields in their joined relationships' do
        expect(Patient.filter(filter_params)).to contain_exactly included_patient
      end
    end

    context 'when filtering based on scopes with no args' do
      let!(:included_visit) { Fabricate :visit, uds_universe: true }
      let!(:excluded_visit) { Fabricate :visit, uds_universe: false }

      let(:filter_params) { { uds_universe: [] } }

      it 'includes records returned by the scope' do
        expect(Visit.filter(filter_params)).to contain_exactly included_visit
      end
    end

    context 'when filtering based on scopes with multiple args' do
      let!(:included_patient) { Fabricate :patient, provider: provider }
      let(:provider) { Fabricate :provider }

      let!(:excluded_patient) { Fabricate :patient }
      let!(:provider_without_patients) { Fabricate :provider }

      context 'when the filter key only matches a scope when prepended by with_' do
        let(:filter_params) do
          {
            patient_relation: [
              ProviderPatientRelation.new('primary_care_giver'),
              [provider.id, provider_without_patients.id]
            ]
          }
        end

        it 'includes records returned by the scope matching the filter key prepended by with_' do
          expect(Patient.filter(filter_params)).to contain_exactly included_patient
        end
      end

      context 'when the filter key matches a scope exactly' do
        let(:filter_params) do
          {
            with_patient_relation: [
              ProviderPatientRelation.new('primary_care_giver'),
              provider.id
            ]
          }
        end

        it 'includes records returned by the scope matching the filter key prepended by with_' do
          expect(Patient.filter(filter_params)).to contain_exactly included_patient
        end
      end
    end

    context 'when filtering based on scopes with one arg' do
      let!(:included_visit) { Fabricate :visit, visit_date: '2017-01-01' }
      let!(:excluded_visit) { Fabricate :visit, visit_date: '2016-01-01' }

      context 'when the individual argument is provided as an array' do
        context 'when the filter key only matches a scope when prepended by with_' do
          let(:filter_params) { { date_on_or_after: ['2016-06-01'] } }
          it 'includes records returned by the scope matching filter key prepended by with_' do
            expect(Visit.filter(filter_params)).to contain_exactly included_visit
          end
        end

        context 'when the filter key matches a scope exactly' do
          let(:filter_params) { { with_date_on_or_after: ['2016-06-01'] } }
          it 'includes records returned by the scope matching filter key with no prefix' do
            expect(Visit.filter(filter_params)).to contain_exactly included_visit
          end
        end
      end

      context 'when the individual argument is provided without an array' do
        context 'when the filter key only matches a scope when prepended by with_' do
          let(:filter_params) { { date_on_or_after: '2016-06-01' } }
          it 'includes records returned by the scope matching filter key prepended by with_' do
            expect(Visit.filter(filter_params)).to contain_exactly included_visit
          end
        end

        context 'when the filter key matches a scope exactly' do
          let(:filter_params) { { with_date_on_or_after: '2016-06-01' } }
          it 'includes records returned by the scope matching filter key with no prefix' do
            expect(Visit.filter(filter_params)).to contain_exactly included_visit
          end
        end
      end
    end

    context 'when filtering based on scopes with a hash arg' do
      let!(:included_visit) { Fabricate :visit, uds_universe: true }
      let!(:excluded_visit) { Fabricate :visit, uds_universe: false }

      context 'when the filter key matches a scope exactly' do
        let(:filter_params) { { with_visit_sets: { id: :uds } } }
        it 'passes the hash argument correctly, returning scoped results' do
          expect(Visit.filter(filter_params)).to contain_exactly included_visit
        end
      end

      context 'when the filter key only matches a scope prepended by with_' do
        let(:filter_params) { { visit_sets: { id: :uds } } }
        it 'passes the hash argument correctly, returning scoped results' do
          expect(Visit.filter(filter_params)).to contain_exactly included_visit
        end
      end
    end

    context 'when filtering with params that respond to #to_h' do
      let!(:included_visit) { Fabricate :visit, uds_universe: true }
      let!(:excluded_visit) { Fabricate :visit, uds_universe: false }

      let(:filter_params) do
        double('hash_like_obj', to_h: { with_visit_sets: { id: :uds } })
      end

      it 'still filters' do
        expect(Visit.filter(filter_params)).to contain_exactly included_visit
      end
    end
  end
end

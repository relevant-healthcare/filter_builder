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

    context 'when filtering with an operator keyword' do
      context 'two operators filtering the same field' do
        let!(:included_provider) { Fabricate(:provider, npi: '3AC') }
        let!(:excluded_provider) { Fabricate(:provider, npi: '4AC') }
        let!(:other_excluded_provider) { Fabricate(:provider, npi: '3ac') }

        let(:filter_params) do
          { npi: { matches_case_insensitive: '3A', matches_case_sensitive: 'AC' } }
        end

        it 'includes results with matching values' do
          expect(Provider.filter(filter_params)).to contain_exactly included_provider
        end
      end

      context 'filtering a field that is shared by the base table and the joined table' do
        let!(:included_provider) { Fabricate(:provider, patients: [patient]) }
        let(:patient) { Fabricate.build(:patient, first_name: 'Sam') }
        let!(:excluded_provider) { Fabricate(:provider) }

        let(:filter_params) do
          # patients and providers both have a first_name column
          { patients: { first_name: { matches_case_insensitive: 'sa' } } }
        end

        it 'refers to the filtered column unambiguously' do
          expect(Provider.filter(filter_params)).to contain_exactly included_provider
        end
      end

      context 'matches_case_insensitive' do
        let!(:included_provider) { Fabricate(:provider, npi: '3AC') }
        let!(:excluded_provider) { Fabricate(:provider, npi: '4AC') }
        let(:filter_params) do
          { npi: { matches_case_insensitive: '^3a.*$' } }
        end

        it 'returns records with matching values, case insensitive' do
          expect(Provider.filter(filter_params)).to contain_exactly included_provider
        end
      end

      context 'does_not_match_case_insensitive' do
        let!(:included_provider) { Fabricate(:provider, npi: '4AC') }
        let!(:excluded_provider) { Fabricate(:provider, npi: '3AC') }
        let(:filter_params) do
          { npi: { does_not_match_case_insensitive: '^3a.*$' } }
        end

        it 'returns records without matching values, case insensitive' do
          expect(Provider.filter(filter_params)).to contain_exactly included_provider
        end
      end

      context 'matches_case_sensitive' do
        let!(:included_provider) { Fabricate(:provider, npi: '3aC') }
        let!(:excluded_provider) { Fabricate(:provider, npi: '3AC') }
        let(:filter_params) do
          { npi: { matches_case_sensitive: '^3a.*$' } }
        end

        it 'returns records with matching values, case sensitve' do
          expect(Provider.filter(filter_params)).to contain_exactly included_provider
        end
      end

      context 'does_not_match_case_sensitive' do
        let!(:included_provider) { Fabricate(:provider, npi: '3AC') }
        let!(:excluded_provider) { Fabricate(:provider, npi: '3aC') }
        let(:filter_params) do
          { npi: { does_not_match_case_sensitive: '^3a.*$' } }
        end

        it 'returns records without matching values, case sensitve' do
          expect(Provider.filter(filter_params)).to contain_exactly included_provider
        end
      end

      context 'equals' do
        let!(:included_provider) { Fabricate(:provider, npi: 'AC') }
        let!(:excluded_provider) { Fabricate(:provider, npi: '3AC') }

        context 'filtering to a scalar' do
          it 'returns records with equal values' do
            expect(Provider.filter(npi: { equals: 'AC' })).to contain_exactly included_provider
          end
        end

        context 'filtering to a collection' do
          let!(:other_included_provider) { Fabricate(:provider, npi: 'DC') }

          it 'includes records with a value in the collection' do
            expect(Provider.filter(npi: { equals: %w[AC DC] })).to contain_exactly(
              included_provider, other_included_provider
            )
          end
        end
      end

      context 'does_not_equal' do
        let!(:included_provider) { Fabricate(:provider, npi: 'AC') }
        let!(:excluded_provider) { Fabricate(:provider, npi: '3AC') }

        context 'filtering to a scalar' do
          it 'returns records with unequal values' do
            expect(Provider.filter(npi: { does_not_equal: '3AC' })).to contain_exactly included_provider
          end
        end

        context 'filtering to a collection' do
          let!(:other_excluded_provider) { Fabricate(:provider, npi: 'DC') }

          it 'includes records without a value in the collection' do
            expect(Provider.filter(npi: { does_not_equal: %w[3AC DC] })).to contain_exactly(
              included_provider
            )
          end
        end
      end

      context 'greater_than' do
        let!(:included_provider) { Fabricate(:provider, twelve_month_panel_target: 2) }
        let!(:excluded_provider) { Fabricate(:provider, twelve_month_panel_target: 1) }

        context 'filtering to a scalar' do
          it 'returns records with greater numeric values' do
            expect(Provider.filter(twelve_month_panel_target: { greater_than: 1 })).to contain_exactly included_provider
          end
        end

        context 'filtering to a collection' do
          let!(:other_excluded_provider) { Fabricate(:provider, twelve_month_panel_target: 0) }

          it 'includes records without a greater value in the collection' do
            expect(Provider.filter(twelve_month_panel_target: { greater_than: %w[1] })).to contain_exactly(
              included_provider
            )
          end
        end
      end

      context 'less_than' do
        let!(:included_provider) { Fabricate(:provider, twelve_month_panel_target: 1) }
        let!(:excluded_provider) { Fabricate(:provider, twelve_month_panel_target: 2) }

        context 'filtering to a scalar' do
          it 'returns records with less than values' do
            expect(Provider.filter(twelve_month_panel_target: { less_than: 2 })).to contain_exactly included_provider
          end
        end

        context 'filtering to a collection' do
          let!(:other_excluded_provider) { Fabricate(:provider, twelve_month_panel_target: 3) }

          it 'includes records without a less than value in the collection' do
            expect(Provider.filter(twelve_month_panel_target: { less_than: %w[2] })).to contain_exactly(
              included_provider
            )
          end
        end
      end

      context 'greater_than_or_equal_to' do
        let!(:included_provider) { Fabricate(:provider, twelve_month_panel_target: 2) }
        let!(:excluded_provider) { Fabricate(:provider, twelve_month_panel_target: 1) }

        context 'filtering to a scalar' do
          it 'returns records with greater than or equal to values' do
            expect(Provider.filter(twelve_month_panel_target: { greater_than_or_equal_to: 2 })).to contain_exactly included_provider
          end
        end

        context 'filtering to a collection' do
          let!(:other_excluded_provider) { Fabricate(:provider, twelve_month_panel_target: 0) }

          it 'includes records without a greater than or equal to value in the collection' do
            expect(Provider.filter(twelve_month_panel_target: { greater_than_or_equal_to: %w[2] })).to contain_exactly(
              included_provider
            )
          end
        end
      end

      context 'less_than_or_equal_to' do
        let!(:included_provider) { Fabricate(:provider, twelve_month_panel_target: 1) }
        let!(:excluded_provider) { Fabricate(:provider, twelve_month_panel_target: 2) }

        context 'filtering to a scalar' do
          it 'returns records with less than or equal to values' do
            expect(Provider.filter(twelve_month_panel_target: { less_than_or_equal_to: 1 })).to contain_exactly included_provider
          end
        end

        context 'filtering to a collection' do
          let!(:other_excluded_provider) { Fabricate(:provider, twelve_month_panel_target: 3) }

          it 'includes records without a less than or equal to value in the collection' do
            expect(Provider.filter(twelve_month_panel_target: { less_than_or_equal_to: %w[1] })).to contain_exactly(
              included_provider
            )
          end
        end
      end
    end

    context 'with an unsupported operator keyword' do
      it 'raises the expected error' do
        expect do
          Provider.filter(npi: { unsupported: 'foo'})
        end.to raise_error FilterBuilder::UnsupportedOperatorKeywordError
      end
    end
  end
end

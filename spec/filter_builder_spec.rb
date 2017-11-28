require 'rails_helper'

describe FilterBuilder do
  describe '#scope' do
    context 'when filtering based on attributes' do
      let!(:included_patient) { Fabricate :patient, first_name: 'TestFirst', last_name: 'TestLast' }
      let!(:excluded_first_name_patient) { Fabricate :patient, first_name: 'SomethingElse', last_name: 'TestLast' }
      let!(:excluded_last_name_patient) { Fabricate :patient, first_name: 'TestFirst', last_name: 'SomethingElse' }

      let(:filter_builder) { FilterBuilder.new Patient, first_name: 'TestFirst', last_name: 'TestLast' }

      it 'includes records with the specified fields' do
        expect(filter_builder.scope).to contain_exactly included_patient
      end
    end

    # context 'when filtering based on joined classes' do
    #   let!(:included_patient) { Fabricate :patient, visits: [visit] }
    #   let(:visit) { Fabricate :visit, provider: provider }
    #   let(:provider) { Fabricate :provider, npi: 'some_npi' }
    #   let!(:excluded_visit_patient) { Fabricate :patient }

    #   let(:filter_builder) { FilterBuilder.new Patient, visits: { provider: { npi: 'some_npi' } } }
    #   it 'includes records with the specified fields in their joined relationships' do
    #     expect(filter_builder.scope).to contain_exactly included_patient
    #   end
    # end

    # context 'when filtering based on scopes with no args' do
    #   let!(:included_visit) { Fabricate :visit, uds_universe: true }
    #   let!(:excluded_visit) { Fabricate :visit, uds_universe: false }

    #   let(:filter_builder) { FilterBuilder.new Visit, uds_universe: [] }
    #   it 'includes records returned by the scope' do
    #     expect(filter_builder.scope).to contain_exactly included_visit
    #   end
    # end

    # context 'when filtering based on scopes with multiple args' do
    #   let!(:included_patient) { Fabricate :patient, primary_care_giver: provider }
    #   let(:provider) { Fabricate :provider }

    #   let!(:excluded_patient) { Fabricate :patient }

    #   context 'when the filter key only matches a scope when prepended by with_' do
    #     let(:filter_builder) { FilterBuilder.new Patient, patient_relation: [ProviderPatientRelation.new('primary_care_giver'), provider.id] }
    #     it 'includes records returned by the scope matching the filter key prepended by with_' do
    #       expect(filter_builder.scope).to contain_exactly included_patient
    #     end
    #   end

    #   context 'when the filter key matches a scope exactly' do
    #     let(:filter_builder) { FilterBuilder.new Patient, with_patient_relation: [ProviderPatientRelation.new('primary_care_giver'), provider.id] }
    #     it 'includes records returned by the scope matching the filter key prepended by with_' do
    #       expect(filter_builder.scope).to contain_exactly included_patient
    #     end
    #   end
    # end

    # context 'when filtering based on scopes with one arg' do
    #   let!(:included_visit) { Fabricate :visit, visit_date: '2017-01-01' }
    #   let!(:excluded_visit) { Fabricate :visit, visit_date: '2016-01-01' }

    #   context 'when the invidual argument is provided as an array' do
    #     context 'when the filter key only matches a scope when prepended by with_' do
    #       let(:filter_builder) { FilterBuilder.new Visit, date_on_or_after: ['2016-06-01'] }
    #       it 'includes records returned by the scope matching filter key prepended by with_' do
    #         expect(filter_builder.scope).to contain_exactly included_visit
    #       end
    #     end

    #     context 'when the filter key matches a scope exactly' do
    #       let(:filter_builder) { FilterBuilder.new Visit, with_date_on_or_after: ['2016-06-01'] }
    #       it 'includes records returned by the scope matching filter key with no prefix' do
    #         expect(filter_builder.scope).to contain_exactly included_visit
    #       end
    #     end
    #   end

    #   context 'when the individual argument is provided without an array' do
    #     context 'when the filter key only matches a scope when prepended by with_' do
    #       let(:filter_builder) { FilterBuilder.new Visit, date_on_or_after: '2016-06-01' }
    #       it 'includes records returned by the scope matching filter key prepended by with_' do
    #         expect(filter_builder.scope).to contain_exactly included_visit
    #       end
    #     end

    #     context 'when the filter key matches a scope exactly' do
    #       let(:filter_builder) { FilterBuilder.new Visit, with_date_on_or_after: '2016-06-01' }
    #       it 'includes records returned by the scope matching filter key with no prefix' do
    #         expect(filter_builder.scope).to contain_exactly included_visit
    #       end
    #     end
    #   end
    # end
  end
end

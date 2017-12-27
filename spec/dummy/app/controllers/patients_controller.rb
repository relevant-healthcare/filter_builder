class PatientsController < ApplicationController
  def index
    @filter = FilterBuilder::Form.new(Patient, filter_params)
  end

  private

  def filter_params
    params.permit(
      filter: [
        :first_name,
        :last_name,
        :date_of_birth,
        provider_id: [],
        visits: [
          :date_on_or_before,
          provider: :npi
        ]
      ]
    )[:filter] || {}
  end
end

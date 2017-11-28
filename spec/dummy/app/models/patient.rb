class Patient < ActiveRecord::Base
  belongs_to :provider
  has_many :visits

  def self.with_patient_relation(relation, provider_ids)
    if relation.any? && provider_ids.present?
      where(<<-SQL, provider_ids: provider_ids)
        "#{table_name}"."id" IN (
          #{Visit.where(provider_id: provider_ids).select(:patient_id).to_sql}
        ) OR
        "#{table_name}"."provider_id" IN (:provider_ids)
      SQL
    elsif relation.primary_care_giver?
      where(provider_id: provider_ids)
    elsif relation.appointment_provider?
      joins(:visits).merge(Visit.where(provider_id: provider_ids))
    else
      all
    end
  end
end

class Visit < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :patient
  belongs_to :provider
  belongs_to_active_hash :visit_type

  scope :uds_universe, -> { where(uds_universe: true) }

  class << self
    def with_date_on_or_before(date)
      where "\"#{table_name}\".\"visit_date\" <= ?", date.to_date.end_of_day
    end

    def with_date_on_or_after(date)
      where "\"#{table_name}\".\"visit_date\" >= ?", date.to_date.beginning_of_day
    end

    def with_visit_sets(visit_set_params)
      all.merge(VisitSet.find_by(visit_set_params).visits)
    end

    def with_visit_type(visit_type_params)
      where(visit_type_id: visit_type_params[:id])
    end
  end
end

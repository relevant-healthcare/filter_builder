class Visit < ActiveRecord::Base
  belongs_to :patient
  belongs_to :provider

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
  end
end

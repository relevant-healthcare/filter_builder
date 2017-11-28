class Visit < ActiveRecord::Base
  belongs_to :patient
  belongs_to :provider
end

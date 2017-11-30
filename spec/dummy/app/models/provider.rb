class Provider < ActiveRecord::Base
  has_many :patients
  has_many :visits
end

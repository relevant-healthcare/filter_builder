class HealthCenter < ActiveRecord::Base
  def self.with_name(name)
    where(name: name)
  end
end

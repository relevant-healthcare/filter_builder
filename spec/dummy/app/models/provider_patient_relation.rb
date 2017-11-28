class ProviderPatientRelation
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def any?
    !(primary_care_giver? || appointment_provider?)
  end

  def primary_care_giver?
    name == 'primary_care_giver'
  end

  def appointment_provider?
    name == 'appointment_provider'
  end
end

Fabricator :patient do
  first_name 'FirstName'
  last_name  { sequence(:patient_name) { |i| "LastName #{i}" } }
  date_of_birth '1980-06-01'
  # provider
end

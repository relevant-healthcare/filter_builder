Fabricator :patient do
  first_name { sequence(:patient_fname) { |i| "FirstName #{i}" } }
  last_name  { sequence(:patient_lname) { |i| "LastName #{i}" } }
  date_of_birth '1980-06-01'
  provider
end

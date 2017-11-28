Fabricator :provider do
  npi { sequence(:provider_id) { |i| "npi #{i}" } }
end

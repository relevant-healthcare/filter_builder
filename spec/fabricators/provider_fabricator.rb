Fabricator :provider do
  npi { sequence(:provider_npi) { |i| "npi #{i}" } }
end

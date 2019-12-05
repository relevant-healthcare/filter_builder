# FilterBuilder

## API

Filter Builder implements `.filter` on ActiveRecord::Base, making `.filter` available on any child of ActiveRecord::Base.

### `.filter`
required argument: Hash
returned value: ActiveRecord_Relation

#### Example use cases:

Given the schema:
```
create_table "patients", force: :cascade do |t|
  t.string   "first_name"
  t.string   "last_name"
  t.date     "date_of_birth"
  t.integer  "provider_id"
  t.datetime "created_at",    null: false
  t.datetime "updated_at",    null: false
end

create_table "providers", force: :cascade do |t|
  t.string   "npi"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.string   "first_name"
  t.string   "last_name"
end
```

and the models:
```
# models/patient.rb
class Patient < ApplicationRecord
  belongs_to :provider

  def self.born_after(date)
    where("date_of_birth > ?", date)
  end

  def self.with_age(year)
    born_after(year.ago)
  end
end

# models/provider.rb
class Provider < ApplicationRecord
  belongs_to :patients

  def self.missing_npi
    where(npi: nil)
  end
end
``

Filtering by column:
`Patient.filter(first_name: 'My Name')` is equivalent to `Patient.where(first_name: 'My Name')`

Filtering by a belongs_to association:
`Patient.filter(provider: { npi: 'some_npi' })` is equivalent to `Patient.joins(:provider).merge(Provider.where(npi: some_npi))`

Filtering by a scope with an argument:
`Patient.filter(born_after: 5.year.ago)` is equivalent to `Patient.born_after(5.years.ago)`

Filtering by a scope without an argument:
`Provider.filter(missing_npi: [])` is equivalent to `Provider.missing_npi`

Filtering by a scope prefixed by "with":
`Provider.filter(age: 28)` is equivalent to `Provider.with_age(28`

Filtering using operator keywords:
Example: `Patient.filter(first_name: { matches_case_insensitive: 'Lars' })` is equivalent to `Patient.where("patients.first_name ~* 'Larse'")`

Supported operator keywors:
- `matches_case_insensitive:` => `~*`
- `matches_case_sensitive:` => `~`

## Local Setup

- Clone repo
- `cd filter_builder`
- `bundle install`
- Start postgres
- Create a postgres user with name 'filter_builder' that can create databases
- `bundle exec rake db:reset`

To run specs:
- `bundle exec rspec`

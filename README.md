# FilterBuilder

FilterBuilder is used to dynamically filter an ActiveRecord model based on a hash-like data structure, for example when filtering an API response based on user-selected filter params.

## API

Filter Builder implements `.filterbuilder_filter` on ActiveRecord::Base, making `.filterbuilder_filter` available on any child of ActiveRecord::Base.

### `.filterbuilder_filter`

required argument: Hash

returned value: ActiveRecord_Relation

#### Example method calls:

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
```

**Filtering by column**:

`Patient.filterbuilder_filter(first_name: 'My Name')` is equivalent to `Patient.where(first_name: 'My Name')`

**Filtering by a belongs_to association**:

`Patient.filterbuilder_filter(provider: { npi: 'some_npi' })` is equivalent to `Patient.joins(:provider).merge(Provider.where(npi: some_npi))`

**Filtering by a scope**:

`Patient.filterbuilder_filter(born_after: 5.years.ago)` is equivalent to `Patient.born_after(5.years.ago)`

Filter Builder will look for scopes that match the keyword prefix with "with". For example:

`Provider.filterbuilder_filter(age: 28)` is equivalent to `Provider.with_age(28)`

By passing an empty hash as the argument, it's possible to call a scope without an argument. For example:

`Provider.filterbuilder_filter(missing_npi: [])` is equivalent to `Provider.missing_npi`

**Filtering using operator keywords**:

Example: `Patient.filterbuilder_filter(first_name: { matches_case_insensitive: 'Lars' })` is equivalent to `Patient.where("patients.first_name ~* 'Larse'")`

Supported operator keywords:

- `matches_case_insensitive:` => `~*`
- `does_not_match_case_insensitive:` => `!~*`
- `matches_case_sensitive:` => `~`
- `does_not_match_case_sensitive:` => `!~`
- `equals:` => `=` or `IN` if passing a collection
- `does_not_equal:` => `!=` or `NOT IN` if passing a collection
- `lt:` => `<`
- `lte:` => `<=`
- `gt:` => `>`
- `gte:` => `>=`
- `between:` => `BETWEEN` expects a value of a hash with keys `min` and `max` e.g `{ min: ?, max: ? }`

## Local Setup

- Clone repo
- `cd filter_builder`
- `bundle install`
- Start postgres
- Create a postgres user with name "filter_builder" that can create databases:
    - `psql postgres`
    - `CREATE USER filter_builder WITH CREATEDB;`
- `bundle exec rake db:reset`

To run specs:

- `bundle exec rspec`

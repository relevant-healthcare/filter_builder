# FilterBuilder

FilterBuilder is used to dynamically filter an ActiveRecord model based on a hash-like data structure, for example when filtering an API response based on user-selected filter params.

## API

Filter Builder implements `.filter` on ActiveRecord::Base, making `.filter` available on any child of ActiveRecord::Base.

### `.filter`
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

`Patient.filter(first_name: 'My Name')` is equivalent to `Patient.where(first_name: 'My Name')`

**Filtering by a belongs_to association**:

`Patient.filter(provider: { npi: 'some_npi' })` is equivalent to `Patient.joins(:provider).merge(Provider.where(npi: some_npi))`

**Filtering by a scope**:

`Patient.filter(born_after: 5.year.ago)` is equivalent to `Patient.born_after(5.years.ago)`

Filter Builder will look for scopes that match the keyword prefix with "with". For example:

`Provider.filter(age: 28)` is equivalent to `Provider.with_age(28`

By passing an empty hash as the argument, it's possible to call a scope without an argument. For example:

`Provider.filter(missing_npi: [])` is equivalent to `Provider.missing_npi`

Note that Filter Builder does not infer scopes that are classically inherited by the caller of `.filter`. Instead, it will treat that keyword like it is a column. For example, if `Foo` defines `.my_scope` and `Bar` inherits from `Foo`, then `Bar.filter(my_scope: 'my_value')` will result in `Bar.where(my_scope: 'my_value')` _not_ `Bar.my_scope`. In that case, only `Foo.filter(my_scope: 'my_value')` will result in executing the `my_scope` method. Scopes that are provided via module inheritance will be infered. Filter Builder infers scopes from the return value of `.public_methods(false)`.

**Filtering using operator keywords**:

Example: `Patient.filter(first_name: { matches_case_insensitive: 'Lars' })` is equivalent to `Patient.where("patients.first_name ~* 'Larse'")`

Supported operator keywords:
- `matches_case_insensitive:` => `~*`
- `does_not_match_case_insensitive:` => `!~*`
- `matches_case_sensitive:` => `~`
- `does_not_match_case_sensitive:` => `!~`
- `equals:` => `=` or `IN` if passing a collection
- `does_not_equal:` => `!=` or `NOT IN` if passing a collection

## Local Setup

- Clone repo
- `cd filter_builder`
- `bundle install`
- Start postgres
- Create a postgres user with name 'filter_builder' that can create databases
- `bundle exec rake db:reset`

To run specs:
- `bundle exec rspec`

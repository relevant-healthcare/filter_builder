# FilterBuilder

Extends `ActiveRecord::Base` with `.filter`

## Local Setup

- Clone repo
- `cd filter_builder`
- `bundle install`
- Start postgres
- Create a postgres user with name 'filter_builder' that can create databases
- `bundle exec rake db:reset`

To run specs:
- `bundle exec rspec`

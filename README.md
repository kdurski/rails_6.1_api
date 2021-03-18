# flex-app-service

Repository for Functional Alerting service

## Installation

Standard rails installation:

- rails db:create
- rails db:setup

## Running tests and linter checks before PR

If you want to run up-to-date suite, please ran the included Makefile by executing this command 

- `make`

This will run all of the tests and automated linter checks.

### Tests

Automated tests are written using RSpec:

- `rspec`

### Linters

Besides tests there is a couple different linter checks that are ran before each merge on CI, including

- `rubocop`
- `reek`
- `brakeman`
- `rails_best_practices` 
  
and possibly more in the future.


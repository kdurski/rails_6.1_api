all: rubocop rspec rails_best_practices reek rubocop brakeman

rspec:
	@rspec

rubocop:
	@rubocop

rails_best_practices:
	@rails_best_practices -c .rails_best_practices.yml

reek:
	@reek

brakeman:
	@brakeman

# Decidim::Courses

.

## Usage

Courses will be available as a brand new Participatory
Space.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-courses"
```

And then execute:

```bash
bundle install
bundle exec rails decidim_courses:install:migrations
bundle exec rails db:migrate
```

### Run tests

Create a dummy app in your application (if not present):

```bash
bundle exec rake test_app
cd spec/decidim_dummy_app/
bundle exec rails decidim_courses:install:migrations
RAILS_ENV=test bundle exec rails db:migrate
cd ../..
```

And run tests:

```bash
bundle exec rspec spec
```

## Contributing

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.

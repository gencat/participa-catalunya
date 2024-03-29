# participa-catalunya

Free Open-Source participatory democracy, citizen participation and open government for cities and organizations

This is the open-source repository for participa-catalunya, based on [Decidim](https://github.com/decidim/decidim).

## Development with docker

If you want to develop using Docker you can run `docker-compose up`.

It will install ruby deps, run the migrations and start the development server for you.

Then you can open a console with `docker-compose run app bash` and continue to the next section.

## Setting up the application

You will need to do some steps before having the app working properly once you've deployed it:

1. Open a Rails console in the server: `bundle exec rails console`
2. Create a System Admin user:
```ruby
user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
user.save!
```
3. Visit `<your app url>/system` and login with your system admin credentials
4. Create a new organization. Check the locales you want to use for that organization, and select a default locale.
5. Set the correct default host for the organization, otherwise the app will not work properly. Note that you need to include any subdomain you might be using.
6. Fill the rest of the form and submit it.

You're good to go!

### Run tests

Run `bin/rake decidim:generate_external_test_app` to generate a dummy application to test both the application and the modules.

Use the `test` environment for the current application:

```bash
bundle exec rails decidim_courses:install:migrations
bundle exec rails decidim_resource_banks:install:migrations
RAILS_ENV=test bundle exec rails db:migrate
```

And run tests:

```bash
bundle exec rspec spec
```

TODO: Use a test_app instead of reusing the current application as `db/schema.rb` gets modified every time a migration is run for the test environment. And this modifications should not go into version control.

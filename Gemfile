source 'https://rubygems.org'

gem 'rails', '4.1.1'
gem 'secure_headers', '~>1.1.1' # Provides XSS protection
gem 'active_attr', '~>0.8.3' # Handles static data like Users
gem 'slim', '~>2.0.2' # Templating
gem 'sass-rails', '~>4.0.3' # CSS
gem 'bootstrap-sass', '~>3.1.1' # Bootstrap
gem 'compass-rails', '~>1.1.7' # Dependency
gem 'font-awesome-rails', '~>4.1.0.0' # FONTS R GRATE
gem 'retriable', '~>1.4.1' # Allows for APIs to be tried multiple times
gem 'rest-client', '~>1.6.7' # Easy API calling
gem 'pundit', '~>0.2.3' # Policies
gem 'therubyracer', '~>0.12.1' # Java runtime
gem 'jquery-rails', '~>3.1.0' # Dependency
gem 'placeholder-gem', '~>3.0.2' # Placeholder
gem 'omniauth-cas' # Omniauth strategy for CAS
gem 'figaro', '~>1.0.0.rc1' # For environment variables
gem 'rufus-scheduler', '~>3.0.8' # For scheduled tasks

group :production do
  gem 'passenger', '~>4.0.46'
end

group :development, :test do
  gem 'rspec-rails', '~>2.14.1' # Testing code
  gem 'selenium-webdriver', '~> 2.39.0' # For testing JS
  gem 'capybara', '~>2.3.0' # For website testing
  gem 'spork-rails', '~>4.0.0' # Ensures clean testing state
  gem 'sqlite3', '~>1.3.9' # Testing
  gem 'uglifier'
end

group :test do
  gem 'fuubar'
end

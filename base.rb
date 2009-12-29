git :init
git :add => "."
git :commit => "-a -m 'initial commit'"

run "rm public/index.html"


file ".gitignore", <<-END
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END


git :add => "."
git :commit => "-a -m 'gitignore'"


gem "rspec", :lib => false, :version => ">= 1.2.0"
gem "rspec-rails", :lib => false, :version => ">= 1.2.0"

gem "cucumber"
gem "cucumber-rails", :lib => false

gem "authlogic"
gem "binarylogic-searchlogic", :lib => 'searchlogic', :source  => 'http://gems.github.com'

gem "haml", :lib => "haml", :version => ">=2.2.0"
gem "chriseppstein-compass", :source => "http://gems.github.com/", :lib => "compass"

rake("gems:install", :sudo => true)


generate :rspec
git :add => "."
git :commit => "-m 'generated rspec'"

generate :cucumber, "--rspec", "--webrat"
git :add => "."
git :commit => "-m 'generated cucumber'"


compass_command = "compass --rails -f blueprint . --css-dir=public/stylesheets/compiled --sass-dir=app/stylesheets "
# Require compass during plugin loading
file 'vendor/plugins/compass/init.rb', <<-CODE
# This is here to make sure that the right version of sass gets loaded (haml 2.2) by the compass requires.
require 'compass'
CODE

# integrate it!
run "haml --rails ."
run compass_command
git :add => "."
git :commit => "-m 'installed compass '"


rake "gems:unpack"
git :add => "."
git :commit => "-m 'unpacked gems'"

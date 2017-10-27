# README

This is Airtailor's Rails 5 API.

# INSTALLATION

## Dependencies:
- postgresql (DB)
- redis (nice things involving queues + background processing)
- ruby (2.4.0 or greater)
- rbenv (install and manage ruby versions)
- rbenv gemset (nice, clean, sandboxed sets of gems)

## SETUP
All commands should be run from ```~/[wherever you cloned the repo]/new_portal/.```.

Make a nice, clean Homebrew:
1. ```brew update```
2. ```brew doctor```
  - Resolve anything nasty you see here.
  - ```brew prune``` will kill old symlinks

Set up rbenv, and make sure you've got ruby 2.4.0 or greater:
1. ```brew install rbenv```
2. ```rbenv install 2.4.0```
3. ```echo '2.4.0' > .ruby-version```

Now do the gemsets:
1. ```brew install rbenv-gemset```
2. ```rbenv gemset init```
3. ```rbenv gemset create 2.40 airtailor-api```
4. ```echo 'airtailor-api' > .rbenv-gemsets```

Get your dependencies:
2. ```brew install postgresql``` (you probably need to add it to launchctl).
2. ```brew install redis```(again, launchctl). The standard port is 6379, and it needs to be valid and running for sidekiq to go.

Get your gems:
3. ```gem install bundler```
3. ```bundle update```

# RUNNING THE API
1. ```rails s``` starts the server on http://localhost:3000.
2. ```bundle exec sidekiq``` prepares the app to process the Redis queue. It needs its own tab/thread to perform async work.

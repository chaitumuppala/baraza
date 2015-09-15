# Baraza

Current status: [![Build Status](https://snap-ci.com/Z3XXANONKIklTpFY0rIbTOFjSiyOD3KyWifmzqJEQu0/build_image)](https://snap-ci.com/cuevee/baraza/branch/master)

**Note**: Things are still local at this point. I'll add container instructions
in the next few commits.

## Get set up

### Prerequisites

- Postgresql with `brew install postgresql`
- ImageMagick with `brew install imagemagick`
- Heroku Toolbelt with `brew install heroku-toolbelt`. Alternatively, you can run all your tests using their respective rake tasks. Both RSpec and Cucumber have tasks which you can find with `rake -T`.

### Running tests

Unit: `bundle exec rspec`

Features: `bundle exec cucumber`

Unless you type at the speed of light I strongly recommend you alias `bundle exec` to something like `be` with

    echo "alias be=bundle exec" >> ~/.aliases

### Running the server

After cloning the repo, we need to set up a couple of things: first, let's get our dependencies installed with `bundle` (from the application directory.)

Then, set up the db:

    bundle exec rake db:drop db:create db:migrate db:test:prepare

Finally, run the application with `bundle exec foreman start`.

**NOTE on environment variables:** the local .env file (*do not commit this file!*) will be loaded by foreman automatically when you run the server. These same environment variables will have their values set on heroku for staging and production, so no worries there.

And there you go :-)

### OS X Setup

If you're a console jockey, feel free to steal https://git.killerco.de/cuevee/dotfiles.git

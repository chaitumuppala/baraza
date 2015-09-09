# Baraza

**Note**: Things are still manual at this point. I'll add container instructions
in the next few commits.

## Get set up

### Prerequisites

- Postgresql with `brew install postgresql`
- ImageMagick with `brew install imagemagick`

### Run the server

After cloning the repo, we need to set up a couple of things: first, let's get our dependencies installed with `bundle` (from the application directory.)

Then, set up the db:

```
bundle exec rake db:drop
bundle exec rake db:reset
```

Finally, run the application with `bundle exec foreman start`.

And there you go :-)

# Guard::RackUnit

Guard::RackUnit is a Guard plugin to run
[Racket's](http:/racket-lang.org)
[RackUnit](http://docs.racket-lang.org/rackunit/index.html) unit
tests.

By default, `Guard::RackUnit` uses the `raco test` command run
tests. Consequently, your RackUnit tests should be placed in
Racket test modules: `(module+ test ...)`.

```
guard init rackunit
```

## Setup
There are many ways to setup Guard. For the non-Rubyist, the ceremony
described below is a typical setup.

1. Install a relatively recent version of Ruby.
2. Install [bundler](http://bundler.io)
3. Install [rvm](https://rvm.io)
4. Create a `Gemfile` in your Racket project's root directory. To the
   `Gemfile`, add both the guard gem and the guard-rackunit gem.
5. In the directory where the `Gemfile` is stored, run `bundle install`

If everything successfully installs, you are now ready to use
Guard. Consult the usage section below on how to use the RackUnit
plugin.

### Example Gemfile
``` ruby
source 'https://www.rubygems.org'
gem "guard", "~> 2.5.1
gem 'guard-rackunit', path: '/home/calbers/src/mine/guard-rackunit'
```

## Usage
To use the RackUnit Guard plugin, Guard must be initialized. To do so,
execute the following command your project's root directory: `bundle
exec guard init`. This should create a `Guardfile` with a default
setup for RackUnit.

Now, to start Guard, execute the following command: `bundle exec guard
start`.

Please consult Guard's own
[usage notes](https://github.com/guard/guard#readme) for more
information.

##List of available options:
``` ruby
test_paths: ['tests/']  # Specify an array of paths that contain unit test files
all_on_start: true      # Run all the tests at startup, default: false
```

## Support and Issues
Please submit support questions, feature requests, and issues to
github issue tracker.

## Updates
Consult the [ChangeLog](Changelog) when upgrading to newer versions.

## Development
The source code is hosted at
[GitHub](https://github.com/neomantic/guard-rackunit).

Pull requests are more than welcome. To contribute, please add new
unit tests to the existing suite of Ruby
[rspec](https://relishapp.com/rspec) unit tests.

## Requirements
1. Racket, with `raco test` support
2. Ruby, and the gems which `Guard::RackUnit` depends on.

## Author
[Chad Albers](https://github.com/neomantic)

## License
This Guard plugin is released under the GPLv3. Consult the LICENSE
file for more details

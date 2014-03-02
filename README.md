# Guard::RackUnit

Guard::RackUnit is a Guard plugin to run
[Racket](http:/racket-lang.org)
[RackUnit](http://docs.racket-lang.org/rackunit/index.html) unit
tests.

`Guard::RackUnit` uses `raco tests` by default to run tests. Consequently, your RackUnit
tests should be placed in the Racket test modules: `(module+ test ...)`.

```
guard init rackunit
```

## Setup
The following steps should get you started

1. Install Ruby
2. `gem install guard-rackunit`
3.

## Usage
Please consult Guard's own [usage notes](https://github.com/guard/guard#readme)

##List of available options:
``` ruby
test_paths: ['tests/']  # Specify an array of paths that contain unit test files
all_on_start: true      # Run all the tests at startup, default: false
```

## Support and Issues
Please submit support questions, feature requests, and issues to the
source code repository's issue tracker.

## Updates
Consult the [ChangeLog](Changelog) when upgrading to newer versions.

## Development
The Sourcecode is hosted at [GitHub](https://github.com/neomantic/guard-rackunit).

Pull requests are more than welcome. Guard-Rackunit includes a Ruby
[rspec](https://relishapp.com/rspec) test suites. Please updated the tests
run `rspec` before submitting pull requests.

## Requirements
1. Racket
2. Ruby, and the gems which Guard::RackUnit depends on. A simple `gem
   install guard-rackunit` should install everything your need.

## Author
[Chad Albers](https://github.com/neomantic)

## License
This Guard plugin is released under the GPLv3. Consult the LICENSE
file for me details

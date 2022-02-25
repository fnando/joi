# joi

[![Tests](https://github.com/fnando/joi/workflows/ruby-tests/badge.svg)](https://github.com/fnando/joi)
[![Gem](https://img.shields.io/gem/v/joi.svg)](https://rubygems.org/gems/joi)
[![Gem](https://img.shields.io/gem/dt/joi.svg)](https://rubygems.org/gems/joi)
[![MIT License](https://img.shields.io/:License-MIT-blue.svg)](https://tldrlegal.com/license/mit-license)

Autorun your minitest tests. Supports Rails projects.

## Installation

```bash
gem install joi
```

Or add the following line to your project's Gemfile:

```ruby
gem "joi"
```

## Usage

```console
$ joi -h
Usage: joi [OPTIONS]
    -b, --[no-]bundler               Use bundler to run commands.
        --rails                      Use this in Rails projects.
    -h, --help                       Prints this help
```

Only `.rb` files are watched. Changes on `lib/**/*.rb` and `app/**/*.rb` files
will run only matching test files (e.g. `app/models/user.rb` changes will run
`test/models/user_test.rb` tests). If no matching test file is found, then all
tests are executed. Any `.rb` file that's either created or removed file will
also trigger a full suite run.

Joi is even more useful if you use
[test_notifier](https://github.com/fnando/test_notifier).

## Maintainer

- [Nando Vieira](https://github.com/fnando)

## Contributors

- <https://github.com/fnando/joi/contributors>

## Contributing

For more details about how to contribute, please read
<https://github.com/fnando/joi/blob/main/CONTRIBUTING.md>.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT). A copy of the license can be
found at <https://github.com/fnando/joi/blob/main/LICENSE.md>.

## Code of Conduct

Everyone interacting in the joi project's codebases, issue trackers, chat rooms
and mailing lists is expected to follow the
[code of conduct](https://github.com/fnando/joi/blob/main/CODE_OF_CONDUCT.md).

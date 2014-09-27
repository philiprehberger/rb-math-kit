# philiprehberger-math_kit

[![Tests](https://github.com/philiprehberger/rb-math-kit/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-math-kit/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-math_kit.svg)](https://rubygems.org/gems/philiprehberger-math_kit)
[![License](https://img.shields.io/github/license/philiprehberger/rb-math-kit)](LICENSE)
[![Sponsor](https://img.shields.io/badge/sponsor-GitHub%20Sponsors-ec6cb9)](https://github.com/sponsors/philiprehberger)

Statistics, interpolation, rounding modes, and moving averages for Ruby

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem "philiprehberger-math_kit"
```

Or install directly:

```bash
gem install philiprehberger-math_kit
```

## Usage

```ruby
require "philiprehberger/math_kit"
```

### Statistics

```ruby
Philiprehberger::MathKit::Stats.mean([1, 2, 3, 4, 5])       # => 3.0
Philiprehberger::MathKit::Stats.median([3, 1, 4, 1, 5])      # => 3.0
Philiprehberger::MathKit::Stats.mode([1, 2, 2, 3])            # => [2]
Philiprehberger::MathKit::Stats.variance([2, 4, 4, 4, 5, 5, 7, 9])  # => 4.0
Philiprehberger::MathKit::Stats.stddev([2, 4, 4, 4, 5, 5, 7, 9])    # => 2.0
Philiprehberger::MathKit::Stats.percentile([1, 2, 3, 4, 5], 50)      # => 3.0
Philiprehberger::MathKit::Stats.sum([1, 2, 3])                # => 6
Philiprehberger::MathKit::Stats.range([1, 5, 3, 9, 2])        # => 8
```

Sample variance and standard deviation:

```ruby
Philiprehberger::MathKit::Stats.variance([2, 4, 4, 4, 5, 5, 7, 9], population: false)  # => 4.571...
Philiprehberger::MathKit::Stats.stddev([2, 4, 4, 4, 5, 5, 7, 9], population: false)    # => 2.138...
```

### Interpolation

```ruby
points = [[0, 0], [5, 10], [10, 20]]
Philiprehberger::MathKit::Interpolation.linear(points, 2.5)  # => 5.0
Philiprehberger::MathKit::Interpolation.linear(points, 7.5)  # => 15.0
```

### Rounding

```ruby
Philiprehberger::MathKit::Round.bankers(2.5)                  # => 2.0 (round half to even)
Philiprehberger::MathKit::Round.bankers(3.5)                  # => 4.0
Philiprehberger::MathKit::Round.ceiling(2.1)                  # => 3.0
Philiprehberger::MathKit::Round.floor(2.9)                    # => 2.0
Philiprehberger::MathKit::Round.truncate(2.9)                 # => 2.0
Philiprehberger::MathKit::Round.truncate(-2.9)                # => -2.0
Philiprehberger::MathKit::Round.bankers(2.55, precision: 1)   # => 2.6
```

### Moving Averages

```ruby
Philiprehberger::MathKit::MovingAverage.simple([1, 2, 3, 4, 5], window: 3)      # => [2.0, 3.0, 4.0]
Philiprehberger::MathKit::MovingAverage.exponential([1, 2, 3, 4, 5], alpha: 0.5) # => [1.0, 1.5, 2.25, 3.125, 4.0625]
```

## API

| Method | Description |
|--------|-------------|
| `Stats.mean(values)` | Arithmetic mean |
| `Stats.median(values)` | Median (middle value or average of two middle) |
| `Stats.mode(values)` | Mode(s) as array |
| `Stats.variance(values, population: true)` | Population or sample variance |
| `Stats.stddev(values, population: true)` | Standard deviation |
| `Stats.percentile(values, p)` | Percentile (0-100) |
| `Stats.sum(values)` | Sum of values |
| `Stats.range(values)` | Max - min |
| `Interpolation.linear(points, x)` | Linear interpolation between points |
| `Round.bankers(value, precision: 0)` | Banker's rounding (round half to even) |
| `Round.ceiling(value, precision: 0)` | Round up |
| `Round.floor(value, precision: 0)` | Round down |
| `Round.truncate(value, precision: 0)` | Truncate toward zero |
| `MovingAverage.simple(values, window:)` | Simple moving average |
| `MovingAverage.exponential(values, alpha:)` | Exponential moving average |

## Development

```bash
bundle install
bundle exec rspec      # Run tests
bundle exec rubocop    # Check code style
```

## License

[MIT](LICENSE)

# philiprehberger-math_kit

[![Tests](https://github.com/philiprehberger/rb-math-kit/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-math-kit/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-math_kit.svg)](https://rubygems.org/gems/philiprehberger-math_kit)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/rb-math-kit)](https://github.com/philiprehberger/rb-math-kit/commits/main)

Statistics, regression, interpolation, rounding modes, and moving averages for Ruby

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

### Summary Statistics

```ruby
Philiprehberger::MathKit::Stats.describe([1, 2, 3, 4, 5])
# => { count: 5, mean: 3.0, median: 3.0, min: 1.0, max: 5.0,
#      stddev: 1.58..., variance: 2.5, p25: 2.0, p50: 3.0, p75: 4.0 }
```

### Weighted Mean

```ruby
Philiprehberger::MathKit::Stats.weighted_mean([10, 20, 30], weights: [3, 1, 1])
# => 16.0
```

### Histogram

```ruby
Philiprehberger::MathKit::Stats.histogram([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], bins: 5)
# => [{ min: 1.0, max: 2.8, count: 2 }, { min: 2.8, max: 4.6, count: 2 }, ...]
```

### Skewness and Kurtosis

```ruby
Philiprehberger::MathKit::Stats.skewness([1, 1, 1, 2, 5, 10])  # => positive (right-skewed)
Philiprehberger::MathKit::Stats.kurtosis([2, 3, 4, 5, 6, 7])   # => near 0 (normal-like)
```

### Confidence Intervals

```ruby
data = [10, 12, 14, 16, 18]
lower, upper = Philiprehberger::MathKit::Stats.confidence_interval(data, level: 0.95)
# => [9.87, 18.13] (approximate)
```

### Correlation and Covariance

```ruby
Philiprehberger::MathKit::Stats.correlation([1, 2, 3, 4], [2, 4, 6, 8])  # => 1.0
Philiprehberger::MathKit::Stats.covariance([1, 2, 3, 4], [2, 4, 6, 8])   # => 3.333...
```

### Data Normalization

```ruby
Philiprehberger::MathKit::Stats.normalize([10, 20, 30])       # => [0.0, 0.5, 1.0]
Philiprehberger::MathKit::Stats.standardize([10, 20, 30, 40]) # => z-scores (mean=0, stddev=1)
```

### Robust Statistics

```ruby
Philiprehberger::MathKit::Stats.median_absolute_deviation([1, 1, 2, 2, 4, 6, 9])  # => 1.0
Philiprehberger::MathKit::Stats.trimmed_mean([1, 2, 3, 4, 100], trim: 0.2)        # => 3.0
Philiprehberger::MathKit::Stats.winsorized_mean([1, 2, 3, 4, 100], trim: 0.2)     # => less affected by outlier
```

### Linear Regression

```ruby
result = Philiprehberger::MathKit::Regression.linear([1, 2, 3, 4], [2, 4, 6, 8])
result.slope      # => 2.0
result.intercept  # => 0.0
result.r_squared  # => 1.0
result.predict(5) # => 10.0
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
Philiprehberger::MathKit::Round.bankers(2.55, precision: 1)   # => 2.6
```

### Moving Averages

```ruby
Philiprehberger::MathKit::MovingAverage.simple([1, 2, 3, 4, 5], window: 3)      # => [2.0, 3.0, 4.0]
Philiprehberger::MathKit::MovingAverage.exponential([1, 2, 3, 4, 5], alpha: 0.5) # => [1.0, 1.5, 2.25, 3.125, 4.0625]
```

## API

### `Stats`

| Method | Description |
|--------|-------------|
| `.mean(values)` | Arithmetic mean |
| `.median(values)` | Median (middle value or average of two middle) |
| `.mode(values)` | Mode(s) as array |
| `.variance(values, population: true)` | Population or sample variance |
| `.stddev(values, population: true)` | Standard deviation |
| `.percentile(values, p)` | Percentile (0-100) with linear interpolation |
| `.sum(values)` | Sum of values |
| `.range(values)` | Max - min |
| `.skewness(values)` | Sample skewness (Fisher-Pearson) |
| `.kurtosis(values)` | Sample excess kurtosis (Fisher definition) |
| `.confidence_interval(values, level: 0.95)` | Confidence interval for the mean |
| `.correlation(xs, ys)` | Pearson correlation coefficient |
| `.covariance(xs, ys)` | Sample covariance |
| `.normalize(values)` | Min-max normalization to 0..1 |
| `.standardize(values)` | Z-score standardization (mean=0, stddev=1) |
| `.median_absolute_deviation(values)` | Median absolute deviation |
| `.trimmed_mean(values, trim: 0.1)` | Trimmed mean (remove fraction from each end) |
| `.winsorized_mean(values, trim: 0.1)` | Winsorized mean (clamp extremes) |
| `.describe(values)` | Summary statistics hash (count, mean, median, min, max, stddev, percentiles) |
| `.histogram(values, bins: 10)` | Frequency distribution as array of bin hashes |
| `.weighted_mean(values, weights:)` | Weighted arithmetic mean |

### `Regression`

| Method | Description |
|--------|-------------|
| `.linear(xs, ys)` | Ordinary least squares linear regression |
| `Result#slope` | Slope of the fitted line |
| `Result#intercept` | Y-intercept of the fitted line |
| `Result#r_squared` | Coefficient of determination (0 to 1) |
| `Result#predict(x)` | Predict y for a given x |

### `Interpolation`

| Method | Description |
|--------|-------------|
| `.linear(points, x)` | Linear interpolation between sorted points |

### `Round`

| Method | Description |
|--------|-------------|
| `.bankers(value, precision: 0)` | Banker's rounding (round half to even) |
| `.ceiling(value, precision: 0)` | Round up |
| `.floor(value, precision: 0)` | Round down |
| `.truncate(value, precision: 0)` | Truncate toward zero |

### `MovingAverage`

| Method | Description |
|--------|-------------|
| `.simple(values, window:)` | Simple moving average |
| `.exponential(values, alpha:)` | Exponential moving average |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Support

If you find this project useful:

⭐ [Star the repo](https://github.com/philiprehberger/rb-math-kit)

🐛 [Report issues](https://github.com/philiprehberger/rb-math-kit/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

💡 [Suggest features](https://github.com/philiprehberger/rb-math-kit/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)

❤️ [Sponsor development](https://github.com/sponsors/philiprehberger)

🌐 [All Open Source Projects](https://philiprehberger.com/open-source-packages)

💻 [GitHub Profile](https://github.com/philiprehberger)

🔗 [LinkedIn Profile](https://www.linkedin.com/in/philiprehberger)

## License

[MIT](LICENSE)

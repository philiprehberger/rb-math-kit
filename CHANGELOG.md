# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0] - 2026-04-15

### Added
- `Numeric` module with common integer and value helpers
- `Numeric.factorial(n)` for non-negative integer factorial (arbitrary precision)
- `Numeric.fibonacci(n)` for the n-th Fibonacci number via iterative O(n)/O(1) computation
- `Numeric.gcd(a, b)` for greatest common divisor (accepts negative inputs)
- `Numeric.lcm(a, b)` for least common multiple (accepts negative inputs)
- `Numeric.clamp(value, min, max)` for constraining a value to a range

## [0.3.0] - 2026-04-10

### Added
- `Stats.describe(values)` for summary statistics (count, mean, median, min, max, stddev, variance, percentiles)
- `Stats.histogram(values, bins:)` for frequency distribution into equal-width bins
- `Stats.weighted_mean(values, weights:)` for weighted arithmetic mean

## [0.2.3] - 2026-04-08

### Changed
- Align gemspec summary with README description.

## [0.2.2] - 2026-03-31

### Added
- Add GitHub issue templates, dependabot config, and PR template

## [0.2.1] - 2026-03-31

### Changed
- Standardize README badges, support section, and license format

## [0.2.0] - 2026-03-27

### Added
- Skewness (Fisher-Pearson sample skewness)
- Kurtosis (excess kurtosis, Fisher definition)
- Confidence intervals for the mean (90%, 95%, 99% levels with t-distribution)
- Linear regression with slope, intercept, r-squared, and prediction
- Pearson correlation coefficient
- Sample covariance
- Min-max normalization (normalize to 0..1)
- Z-score standardization (mean=0, stddev=1)
- Median absolute deviation (MAD)
- Trimmed mean with configurable trim fraction
- Winsorized mean with configurable trim fraction
- `Regression` module with `Result` data class and `predict` method

## [0.1.2] - 2026-03-26

### Changed
- Add Sponsor badge to README
- Fix License section format
- Sync gemspec summary with README

## [0.1.1] - 2026-03-26

### Changed

- Fix README compliance (one-liner, license link)

## [0.1.0] - 2026-03-26

### Added
- Initial release
- Descriptive statistics: mean, median, mode, variance, stddev, percentile, sum, range
- Linear interpolation between sorted points with extrapolation
- Rounding modes: bankers (round half to even), ceiling, floor, truncate with precision
- Simple moving average and exponential moving average

[Unreleased]: https://github.com/philiprehberger/rb-math-kit/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/philiprehberger/rb-math-kit/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/philiprehberger/rb-math-kit/compare/v0.2.3...v0.3.0
[0.2.3]: https://github.com/philiprehberger/rb-math-kit/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/philiprehberger/rb-math-kit/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/philiprehberger/rb-math-kit/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/philiprehberger/rb-math-kit/compare/v0.1.2...v0.2.0
[0.1.2]: https://github.com/philiprehberger/rb-math-kit/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/philiprehberger/rb-math-kit/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/philiprehberger/rb-math-kit/releases/tag/v0.1.0

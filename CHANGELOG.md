# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

# frozen_string_literal: true

module Philiprehberger
  module MathKit
    module Stats
      class << self
        # Arithmetic mean of values
        #
        # @param values [Array<Numeric>] the input values
        # @return [Float] the arithmetic mean
        # @raise [ArgumentError] if values is empty
        def mean(values)
          raise ArgumentError, 'values must not be empty' if values.empty?

          sum(values).to_f / values.size
        end

        # Median (middle value or average of two middle values)
        #
        # @param values [Array<Numeric>] the input values
        # @return [Float] the median
        # @raise [ArgumentError] if values is empty
        def median(values)
          raise ArgumentError, 'values must not be empty' if values.empty?

          sorted = values.sort
          mid = sorted.size / 2

          if sorted.size.odd?
            sorted[mid].to_f
          else
            (sorted[mid - 1] + sorted[mid]).to_f / 2
          end
        end

        # Mode(s) — most frequently occurring value(s)
        #
        # @param values [Array<Numeric>] the input values
        # @return [Array<Numeric>] the mode(s) as an array
        # @raise [ArgumentError] if values is empty
        def mode(values)
          raise ArgumentError, 'values must not be empty' if values.empty?

          freq = values.tally
          max_count = freq.values.max
          freq.select { |_, count| count == max_count }.keys
        end

        # Population or sample variance
        #
        # @param values [Array<Numeric>] the input values
        # @param population [Boolean] true for population variance, false for sample
        # @return [Float] the variance
        # @raise [ArgumentError] if values is empty or sample variance with fewer than 2 values
        def variance(values, population: true)
          raise ArgumentError, 'values must not be empty' if values.empty?

          n = values.size
          raise ArgumentError, 'sample variance requires at least 2 values' if !population && n < 2

          avg = mean(values)
          sum_sq = values.sum { |v| (v - avg)**2 }
          divisor = population ? n : n - 1
          sum_sq.to_f / divisor
        end

        # Standard deviation
        #
        # @param values [Array<Numeric>] the input values
        # @param population [Boolean] true for population stddev, false for sample
        # @return [Float] the standard deviation
        def stddev(values, population: true)
          Math.sqrt(variance(values, population: population))
        end

        # Percentile (0-100) using linear interpolation
        #
        # @param values [Array<Numeric>] the input values
        # @param p [Numeric] the percentile (0-100)
        # @return [Float] the percentile value
        # @raise [ArgumentError] if values is empty or p is out of range
        def percentile(values, p)
          raise ArgumentError, 'values must not be empty' if values.empty?
          raise ArgumentError, 'percentile must be between 0 and 100' if p.negative? || p > 100

          sorted = values.sort
          return sorted.first.to_f if p.zero?
          return sorted.last.to_f if p == 100

          rank = (p / 100.0) * (sorted.size - 1)
          lower = rank.floor
          upper = rank.ceil

          return sorted[lower].to_f if lower == upper

          fraction = rank - lower
          (sorted[lower] + (fraction * (sorted[upper] - sorted[lower]))).to_f
        end

        # Sum of values
        #
        # @param values [Array<Numeric>] the input values
        # @return [Numeric] the sum
        def sum(values)
          values.sum
        end

        # Range (max - min)
        #
        # @param values [Array<Numeric>] the input values
        # @return [Numeric] the range
        # @raise [ArgumentError] if values is empty
        def range(values)
          raise ArgumentError, 'values must not be empty' if values.empty?

          values.max - values.min
        end

        # Sample skewness (Fisher-Pearson)
        #
        # @param values [Array<Numeric>] the input values
        # @return [Float] the sample skewness
        # @raise [ArgumentError] if fewer than 3 values
        def skewness(values)
          n = values.size
          raise ArgumentError, 'skewness requires at least 3 values' if n < 3

          avg = mean(values)
          s = stddev(values, population: false)
          return 0.0 if s.zero?

          m3 = values.sum { |v| (v - avg)**3 } / n.to_f
          adjustment = (n.to_f * (n - 1)) / (n - 2)
          (adjustment / n) * (m3 / (s**3)) * n
        end

        # Sample excess kurtosis (Fisher definition, normal = 0)
        #
        # @param values [Array<Numeric>] the input values
        # @return [Float] the sample excess kurtosis
        # @raise [ArgumentError] if fewer than 4 values
        def kurtosis(values)
          n = values.size
          raise ArgumentError, 'kurtosis requires at least 4 values' if n < 4

          avg = mean(values)
          s2 = variance(values, population: false)
          return 0.0 if s2.zero?

          m4 = values.sum { |v| (v - avg)**4 } / n.to_f
          raw = m4 / (s2**2)
          # Adjusted Fisher kurtosis
          prefactor = (n.to_f * (n + 1)) / ((n - 1) * (n - 2) * (n - 3))
          correction = (3.0 * ((n - 1)**2)) / ((n - 2) * (n - 3))
          (prefactor * n * raw) - correction
        end

        # Confidence interval for the mean using t-distribution critical values
        #
        # @param values [Array<Numeric>] the input values
        # @param level [Float] confidence level (0.90, 0.95, or 0.99)
        # @return [Array(Float, Float)] lower and upper bounds
        # @raise [ArgumentError] if fewer than 2 values or unsupported level
        def confidence_interval(values, level: 0.95)
          n = values.size
          raise ArgumentError, 'confidence interval requires at least 2 values' if n < 2

          t_value = t_critical(n - 1, level)
          avg = mean(values)
          se = stddev(values, population: false) / Math.sqrt(n)
          margin = t_value * se

          [avg - margin, avg + margin]
        end

        # Pearson correlation coefficient between two datasets
        #
        # @param xs [Array<Numeric>] first dataset
        # @param ys [Array<Numeric>] second dataset
        # @return [Float] the Pearson correlation coefficient (-1 to 1)
        # @raise [ArgumentError] if datasets differ in size or have fewer than 2 values
        def correlation(xs, ys)
          raise ArgumentError, 'datasets must have the same size' if xs.size != ys.size
          raise ArgumentError, 'correlation requires at least 2 values' if xs.size < 2

          cov = covariance(xs, ys)
          sx = stddev(xs, population: false)
          sy = stddev(ys, population: false)
          return 0.0 if sx.zero? || sy.zero?

          cov / (sx * sy)
        end

        # Sample covariance between two datasets
        #
        # @param xs [Array<Numeric>] first dataset
        # @param ys [Array<Numeric>] second dataset
        # @return [Float] the sample covariance
        # @raise [ArgumentError] if datasets differ in size or have fewer than 2 values
        def covariance(xs, ys)
          raise ArgumentError, 'datasets must have the same size' if xs.size != ys.size
          raise ArgumentError, 'covariance requires at least 2 values' if xs.size < 2

          n = xs.size
          avg_x = mean(xs)
          avg_y = mean(ys)
          xs.zip(ys).sum { |x, y| (x - avg_x) * (y - avg_y) } / (n - 1).to_f
        end

        # Min-max normalization to 0..1 range
        #
        # @param values [Array<Numeric>] the input values
        # @return [Array<Float>] normalized values
        # @raise [ArgumentError] if values is empty
        def normalize(values)
          raise ArgumentError, 'values must not be empty' if values.empty?

          min_val = values.min.to_f
          max_val = values.max.to_f
          span = max_val - min_val
          return values.map { 0.0 } if span.zero?

          values.map { |v| (v - min_val) / span }
        end

        # Z-score standardization (mean=0, stddev=1)
        #
        # @param values [Array<Numeric>] the input values
        # @return [Array<Float>] standardized values
        # @raise [ArgumentError] if fewer than 2 values
        def standardize(values)
          raise ArgumentError, 'standardize requires at least 2 values' if values.size < 2

          avg = mean(values)
          s = stddev(values, population: false)
          return values.map { 0.0 } if s.zero?

          values.map { |v| (v - avg) / s }
        end

        # Median absolute deviation
        #
        # @param values [Array<Numeric>] the input values
        # @return [Float] the MAD
        # @raise [ArgumentError] if values is empty
        def median_absolute_deviation(values)
          raise ArgumentError, 'values must not be empty' if values.empty?

          med = median(values)
          deviations = values.map { |v| (v - med).abs }
          median(deviations)
        end

        # Trimmed mean (removes a fraction from each end before averaging)
        #
        # @param values [Array<Numeric>] the input values
        # @param trim [Float] fraction to trim from each end (0.0 to 0.5 exclusive)
        # @return [Float] the trimmed mean
        # @raise [ArgumentError] if values is empty or trim is out of range
        def trimmed_mean(values, trim: 0.1)
          raise ArgumentError, 'values must not be empty' if values.empty?
          raise ArgumentError, 'trim must be between 0.0 and 0.5 (exclusive)' if trim.negative? || trim >= 0.5

          sorted = values.sort
          n = sorted.size
          k = (n * trim).floor
          return mean(sorted) if k.zero?

          trimmed = sorted[k..-(k + 1)]
          mean(trimmed)
        end

        # Winsorized mean (replaces extremes with boundary values before averaging)
        #
        # @param values [Array<Numeric>] the input values
        # @param trim [Float] fraction to winsorize from each end (0.0 to 0.5 exclusive)
        # @return [Float] the winsorized mean
        # @raise [ArgumentError] if values is empty or trim is out of range
        def winsorized_mean(values, trim: 0.1)
          raise ArgumentError, 'values must not be empty' if values.empty?
          raise ArgumentError, 'trim must be between 0.0 and 0.5 (exclusive)' if trim.negative? || trim >= 0.5

          sorted = values.sort
          n = sorted.size
          k = (n * trim).floor
          return mean(sorted) if k.zero?

          low = sorted[k]
          high = sorted[-(k + 1)]
          winsorized = sorted.map { |v| [[v, low].max, high].min }
          mean(winsorized)
        end

        private

        # T-distribution critical values for common confidence levels
        # Uses a lookup table for degrees of freedom up to 200 and common levels
        #
        # @param df [Integer] degrees of freedom
        # @param level [Float] confidence level
        # @return [Float] the t critical value
        def t_critical(df, level)
          # Two-tailed critical values for common levels
          # For large df (>120), use z-approximation
          t_values = {
            0.90 => { 1 => 6.314, 2 => 2.920, 3 => 2.353, 4 => 2.132, 5 => 2.015,
                      6 => 1.943, 7 => 1.895, 8 => 1.860, 9 => 1.833, 10 => 1.812,
                      15 => 1.753, 20 => 1.725, 25 => 1.708, 30 => 1.697,
                      40 => 1.684, 50 => 1.676, 60 => 1.671, 80 => 1.664,
                      100 => 1.660, 120 => 1.658 },
            0.95 => { 1 => 12.706, 2 => 4.303, 3 => 3.182, 4 => 2.776, 5 => 2.571,
                      6 => 2.447, 7 => 2.365, 8 => 2.306, 9 => 2.262, 10 => 2.228,
                      15 => 2.131, 20 => 2.086, 25 => 2.060, 30 => 2.042,
                      40 => 2.021, 50 => 2.009, 60 => 2.000, 80 => 1.990,
                      100 => 1.984, 120 => 1.980 },
            0.99 => { 1 => 63.657, 2 => 9.925, 3 => 5.841, 4 => 4.604, 5 => 4.032,
                      6 => 3.707, 7 => 3.499, 8 => 3.355, 9 => 3.250, 10 => 3.169,
                      15 => 2.947, 20 => 2.845, 25 => 2.787, 30 => 2.750,
                      40 => 2.704, 50 => 2.678, 60 => 2.660, 80 => 2.639,
                      100 => 2.626, 120 => 2.617 }
          }

          z_values = { 0.90 => 1.645, 0.95 => 1.960, 0.99 => 2.576 }

          raise ArgumentError, "unsupported confidence level: #{level}. Use 0.90, 0.95, or 0.99" unless t_values.key?(level)

          return z_values[level] if df > 120

          table = t_values[level]
          return table[df] if table.key?(df)

          # Interpolate between nearest known degrees of freedom
          keys = table.keys.sort
          lower = keys.select { |k| k <= df }.last
          upper = keys.select { |k| k >= df }.first

          return table[lower] if lower == upper

          # Linear interpolation
          t_low = table[lower]
          t_high = table[upper]
          fraction = (df - lower).to_f / (upper - lower)
          t_low + (fraction * (t_high - t_low))
        end
      end
    end
  end
end

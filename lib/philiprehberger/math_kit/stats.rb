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
      end
    end
  end
end

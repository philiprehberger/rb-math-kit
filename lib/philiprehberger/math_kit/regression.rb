# frozen_string_literal: true

module Philiprehberger
  module MathKit
    # Linear regression analysis
    module Regression
      # Result of a linear regression
      Result = Struct.new(:slope, :intercept, :r_squared, keyword_init: true) do
        # Predict the y value for a given x
        #
        # @param x [Numeric] the input value
        # @return [Float] the predicted y value
        def predict(x)
          intercept + (slope * x)
        end
      end

      class << self
        # Perform ordinary least squares linear regression
        #
        # @param xs [Array<Numeric>] independent variable values
        # @param ys [Array<Numeric>] dependent variable values
        # @return [Result] regression result with slope, intercept, and r_squared
        # @raise [ArgumentError] if arrays differ in size or have fewer than 2 points
        def linear(xs, ys)
          raise ArgumentError, 'datasets must have the same size' if xs.size != ys.size
          raise ArgumentError, 'linear regression requires at least 2 data points' if xs.size < 2

          n = xs.size.to_f
          sum_x = xs.sum.to_f
          sum_y = ys.sum.to_f
          sum_xy = xs.zip(ys).sum { |x, y| x * y }.to_f
          sum_x2 = xs.sum { |x| x**2 }.to_f

          denom = (n * sum_x2) - (sum_x**2)
          raise ArgumentError, 'all x values are identical — cannot fit a line' if denom.zero?

          slope = ((n * sum_xy) - (sum_x * sum_y)) / denom
          intercept = (sum_y - (slope * sum_x)) / n

          r_squared = compute_r_squared(ys, xs, slope, intercept)

          Result.new(slope: slope, intercept: intercept, r_squared: r_squared)
        end

        private

        def compute_r_squared(ys, xs, slope, intercept)
          mean_y = ys.sum.to_f / ys.size
          ss_tot = ys.sum { |y| (y - mean_y)**2 }
          return 1.0 if ss_tot.zero?

          ss_res = xs.zip(ys).sum { |x, y| (y - (intercept + (slope * x)))**2 }
          1.0 - (ss_res / ss_tot)
        end
      end
    end
  end
end

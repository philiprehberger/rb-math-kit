# frozen_string_literal: true

module Philiprehberger
  module MathKit
    module MovingAverage
      class << self
        # Simple moving average
        #
        # @param values [Array<Numeric>] the input values
        # @param window [Integer] the window size
        # @return [Array<Float>] the SMA values (size = values.size - window + 1)
        # @raise [ArgumentError] if window is larger than values or less than 1
        def simple(values, window:)
          raise ArgumentError, 'window must be at least 1' if window < 1
          raise ArgumentError, 'window must not exceed values size' if window > values.size

          (0..(values.size - window)).map do |i|
            values[i, window].sum.to_f / window
          end
        end

        # Exponential moving average
        #
        # @param values [Array<Numeric>] the input values
        # @param alpha [Float] the smoothing factor (0 < alpha <= 1)
        # @return [Array<Float>] the EMA values (same size as input)
        # @raise [ArgumentError] if alpha is out of range or values is empty
        def exponential(values, alpha:)
          raise ArgumentError, 'values must not be empty' if values.empty?
          raise ArgumentError, 'alpha must be between 0 (exclusive) and 1 (inclusive)' if alpha <= 0 || alpha > 1

          result = [values.first.to_f]
          values[1..].each do |v|
            result << ((alpha * v) + ((1 - alpha) * result.last))
          end
          result
        end
      end
    end
  end
end

# frozen_string_literal: true

module Philiprehberger
  module MathKit
    module Round
      class << self
        # Banker's rounding (round half to even)
        #
        # @param value [Numeric] the value to round
        # @param precision [Integer] number of decimal places
        # @return [Float] the rounded value
        def bankers(value, precision: 0)
          multiplier = 10**precision
          scaled = value * multiplier

          # Check if exactly at the halfway point
          if halfway?(scaled)
            floored = scaled.floor
            # Round to even
            if floored.even?
              floored.to_f / multiplier
            else
              (floored + 1).to_f / multiplier
            end
          else
            scaled.round.to_f / multiplier
          end
        end

        # Round up (ceiling)
        #
        # @param value [Numeric] the value to round
        # @param precision [Integer] number of decimal places
        # @return [Float] the rounded value
        def ceiling(value, precision: 0)
          multiplier = 10**precision
          (value * multiplier).ceil.to_f / multiplier
        end

        # Round down (floor)
        #
        # @param value [Numeric] the value to round
        # @param precision [Integer] number of decimal places
        # @return [Float] the rounded value
        def floor(value, precision: 0)
          multiplier = 10**precision
          (value * multiplier).floor.to_f / multiplier
        end

        # Truncate toward zero
        #
        # @param value [Numeric] the value to truncate
        # @param precision [Integer] number of decimal places
        # @return [Float] the truncated value
        def truncate(value, precision: 0)
          multiplier = 10**precision
          (value * multiplier).truncate.to_f / multiplier
        end

        private

        def halfway?(scaled)
          fractional = (scaled - scaled.floor).abs
          (fractional - 0.5).abs < 1e-9
        end
      end
    end
  end
end

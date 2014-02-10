# frozen_string_literal: true

module Philiprehberger
  module MathKit
    module Interpolation
      class << self
        # Linear interpolation between sorted points
        #
        # @param points [Array<Array(Numeric, Numeric)>] sorted array of [x, y] pairs
        # @param x [Numeric] the x value to interpolate at
        # @return [Float] the interpolated y value
        # @raise [ArgumentError] if fewer than 2 points or x is out of range
        def linear(points, x)
          raise ArgumentError, 'at least 2 points are required' if points.size < 2

          sorted = points.sort_by(&:first)

          if x <= sorted.first[0]
            return extrapolate(sorted[0], sorted[1], x) if x < sorted.first[0]

            return sorted.first[1].to_f
          end

          if x >= sorted.last[0]
            return extrapolate(sorted[-2], sorted[-1], x) if x > sorted.last[0]

            return sorted.last[1].to_f
          end

          # Find the bracketing pair
          i = sorted.index { |pt| pt[0] >= x }
          return sorted[i][1].to_f if sorted[i][0] == x

          interpolate_between(sorted[i - 1], sorted[i], x)
        end

        private

        def interpolate_between(p1, p2, x)
          x1, y1 = p1
          x2, y2 = p2
          t = (x - x1).to_f / (x2 - x1)
          (y1 + (t * (y2 - y1))).to_f
        end

        def extrapolate(p1, p2, x)
          interpolate_between(p1, p2, x)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Philiprehberger
  module MathKit
    # Numeric helpers for common integer and value operations
    module Numeric
      class << self
        # Factorial of a non-negative integer (n!)
        #
        # @param n [Integer] a non-negative integer
        # @return [Integer] the factorial of n
        # @raise [ArgumentError] if n is negative or not an Integer
        def factorial(n)
          raise ArgumentError, 'factorial requires an Integer' unless n.is_a?(Integer)
          raise ArgumentError, 'factorial requires a non-negative integer' if n.negative?

          (1..n).reduce(1, :*)
        end

        # N-th Fibonacci number (0-indexed: fibonacci(0) = 0, fibonacci(1) = 1)
        #
        # Uses an iterative algorithm for O(n) time and O(1) space.
        #
        # @param n [Integer] a non-negative index
        # @return [Integer] the n-th Fibonacci number
        # @raise [ArgumentError] if n is negative or not an Integer
        def fibonacci(n)
          raise ArgumentError, 'fibonacci requires an Integer' unless n.is_a?(Integer)
          raise ArgumentError, 'fibonacci requires a non-negative integer' if n.negative?

          a = 0
          b = 1
          n.times { a, b = b, a + b }
          a
        end

        # Greatest common divisor of two integers (Euclidean algorithm)
        #
        # @param a [Integer] first integer
        # @param b [Integer] second integer
        # @return [Integer] the non-negative greatest common divisor
        # @raise [ArgumentError] if either argument is not an Integer
        def gcd(a, b)
          raise ArgumentError, 'gcd requires Integer arguments' unless a.is_a?(Integer) && b.is_a?(Integer)

          a.abs.gcd(b.abs)
        end

        # Least common multiple of two integers
        #
        # @param a [Integer] first integer
        # @param b [Integer] second integer
        # @return [Integer] the non-negative least common multiple (0 if either is 0)
        # @raise [ArgumentError] if either argument is not an Integer
        def lcm(a, b)
          raise ArgumentError, 'lcm requires Integer arguments' unless a.is_a?(Integer) && b.is_a?(Integer)

          a.abs.lcm(b.abs)
        end

        # Clamp a numeric value between a minimum and maximum
        #
        # @param value [Numeric] the value to clamp
        # @param min [Numeric] lower bound
        # @param max [Numeric] upper bound
        # @return [Numeric] the clamped value
        # @raise [ArgumentError] if min is greater than max
        def clamp(value, min, max)
          raise ArgumentError, 'min must not be greater than max' if min > max

          return min if value < min
          return max if value > max

          value
        end
      end
    end
  end
end

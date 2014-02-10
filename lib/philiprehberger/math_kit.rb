# frozen_string_literal: true

require_relative 'math_kit/version'
require_relative 'math_kit/stats'
require_relative 'math_kit/interpolation'
require_relative 'math_kit/round'
require_relative 'math_kit/moving_average'

module Philiprehberger
  module MathKit
    class Error < StandardError; end
  end
end

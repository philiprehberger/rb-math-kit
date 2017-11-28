# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::MathKit do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be_nil
  end

  describe Philiprehberger::MathKit::Stats do
    describe '.mean' do
      it 'calculates mean of integers' do
        expect(described_class.mean([1, 2, 3, 4, 5])).to eq(3.0)
      end

      it 'calculates mean of floats' do
        expect(described_class.mean([1.5, 2.5, 3.5])).to eq(2.5)
      end

      it 'calculates mean of single value' do
        expect(described_class.mean([42])).to eq(42.0)
      end

      it 'raises on empty array' do
        expect { described_class.mean([]) }.to raise_error(ArgumentError)
      end
    end

    describe '.median' do
      it 'returns middle value for odd count' do
        expect(described_class.median([3, 1, 2])).to eq(2.0)
      end

      it 'returns average of two middle values for even count' do
        expect(described_class.median([4, 1, 3, 2])).to eq(2.5)
      end

      it 'handles single value' do
        expect(described_class.median([7])).to eq(7.0)
      end

      it 'handles already sorted values' do
        expect(described_class.median([10, 20, 30, 40, 50])).to eq(30.0)
      end

      it 'raises on empty array' do
        expect { described_class.median([]) }.to raise_error(ArgumentError)
      end
    end

    describe '.mode' do
      it 'returns the most frequent value' do
        expect(described_class.mode([1, 2, 2, 3])).to eq([2])
      end

      it 'returns multiple modes when tied' do
        result = described_class.mode([1, 1, 2, 2, 3])
        expect(result).to contain_exactly(1, 2)
      end

      it 'returns all values when all unique' do
        result = described_class.mode([1, 2, 3])
        expect(result).to contain_exactly(1, 2, 3)
      end

      it 'handles single value' do
        expect(described_class.mode([5])).to eq([5])
      end

      it 'raises on empty array' do
        expect { described_class.mode([]) }.to raise_error(ArgumentError)
      end
    end

    describe '.variance' do
      it 'calculates population variance' do
        expect(described_class.variance([2, 4, 4, 4, 5, 5, 7, 9])).to eq(4.0)
      end

      it 'calculates sample variance' do
        result = described_class.variance([2, 4, 4, 4, 5, 5, 7, 9], population: false)
        expect(result).to be_within(0.001).of(4.571)
      end

      it 'returns zero for identical values' do
        expect(described_class.variance([5, 5, 5])).to eq(0.0)
      end

      it 'raises on empty array' do
        expect { described_class.variance([]) }.to raise_error(ArgumentError)
      end

      it 'raises on sample variance with single value' do
        expect { described_class.variance([1], population: false) }.to raise_error(ArgumentError)
      end
    end

    describe '.stddev' do
      it 'calculates population standard deviation' do
        expect(described_class.stddev([2, 4, 4, 4, 5, 5, 7, 9])).to eq(2.0)
      end

      it 'calculates sample standard deviation' do
        result = described_class.stddev([2, 4, 4, 4, 5, 5, 7, 9], population: false)
        expect(result).to be_within(0.001).of(2.138)
      end
    end

    describe '.percentile' do
      it 'returns 0th percentile as minimum' do
        expect(described_class.percentile([1, 2, 3, 4, 5], 0)).to eq(1.0)
      end

      it 'returns 100th percentile as maximum' do
        expect(described_class.percentile([1, 2, 3, 4, 5], 100)).to eq(5.0)
      end

      it 'returns 50th percentile as median' do
        expect(described_class.percentile([1, 2, 3, 4, 5], 50)).to eq(3.0)
      end

      it 'interpolates between values' do
        expect(described_class.percentile([1, 2, 3, 4, 5], 25)).to eq(2.0)
      end

      it 'handles 75th percentile' do
        expect(described_class.percentile([1, 2, 3, 4, 5], 75)).to eq(4.0)
      end

      it 'raises on empty array' do
        expect { described_class.percentile([], 50) }.to raise_error(ArgumentError)
      end

      it 'raises on out of range percentile' do
        expect { described_class.percentile([1], -1) }.to raise_error(ArgumentError)
        expect { described_class.percentile([1], 101) }.to raise_error(ArgumentError)
      end
    end

    describe '.sum' do
      it 'sums integers' do
        expect(described_class.sum([1, 2, 3, 4, 5])).to eq(15)
      end

      it 'sums floats' do
        expect(described_class.sum([1.5, 2.5])).to eq(4.0)
      end

      it 'returns zero for empty array' do
        expect(described_class.sum([])).to eq(0)
      end
    end

    describe '.range' do
      it 'calculates range' do
        expect(described_class.range([1, 5, 3, 9, 2])).to eq(8)
      end

      it 'returns zero for identical values' do
        expect(described_class.range([4, 4, 4])).to eq(0)
      end

      it 'handles negative values' do
        expect(described_class.range([-5, -1, 3])).to eq(8)
      end

      it 'raises on empty array' do
        expect { described_class.range([]) }.to raise_error(ArgumentError)
      end
    end

    describe '.skewness' do
      it 'returns positive skewness for right-skewed data' do
        expect(described_class.skewness([1, 1, 1, 2, 5, 10])).to be > 0
      end

      it 'returns near-zero skewness for symmetric data' do
        expect(described_class.skewness([1, 2, 3, 4, 5])).to be_within(0.5).of(0)
      end

      it 'returns zero for identical values' do
        expect(described_class.skewness([5, 5, 5, 5])).to eq(0.0)
      end

      it 'raises with fewer than 3 values' do
        expect { described_class.skewness([1, 2]) }.to raise_error(ArgumentError)
      end
    end

    describe '.kurtosis' do
      it 'returns near-zero for normally distributed data' do
        data = [2, 3, 4, 4, 5, 5, 5, 6, 6, 7]
        expect(described_class.kurtosis(data)).to be_within(2.0).of(0)
      end

      it 'returns zero for identical values' do
        expect(described_class.kurtosis([3, 3, 3, 3, 3])).to eq(0.0)
      end

      it 'raises with fewer than 4 values' do
        expect { described_class.kurtosis([1, 2, 3]) }.to raise_error(ArgumentError)
      end
    end

    describe '.confidence_interval' do
      it 'returns lower and upper bounds' do
        data = [10, 12, 14, 16, 18]
        lower, upper = described_class.confidence_interval(data, level: 0.95)
        expect(lower).to be < 14.0
        expect(upper).to be > 14.0
        expect(lower).to be > 0
      end

      it 'narrows with larger sample' do
        small = [10, 12, 14, 16, 18]
        large = (1..100).map { |i| 14.0 + (i % 5) - 2 }
        _, upper_small = described_class.confidence_interval(small, level: 0.95)
        _, upper_large = described_class.confidence_interval(large, level: 0.95)
        small_width = upper_small - described_class.mean(small)
        large_width = upper_large - described_class.mean(large)
        expect(large_width).to be < small_width
      end

      it 'raises with fewer than 2 values' do
        expect { described_class.confidence_interval([1]) }.to raise_error(ArgumentError)
      end

      it 'raises for unsupported level' do
        expect { described_class.confidence_interval([1, 2, 3], level: 0.80) }.to raise_error(ArgumentError)
      end
    end

    describe '.correlation' do
      it 'returns 1.0 for perfectly correlated data' do
        expect(described_class.correlation([1, 2, 3, 4], [2, 4, 6, 8])).to be_within(0.001).of(1.0)
      end

      it 'returns -1.0 for perfectly inverse correlated data' do
        expect(described_class.correlation([1, 2, 3, 4], [8, 6, 4, 2])).to be_within(0.001).of(-1.0)
      end

      it 'returns 0 for constant values' do
        expect(described_class.correlation([1, 2, 3], [5, 5, 5])).to eq(0.0)
      end

      it 'raises for mismatched sizes' do
        expect { described_class.correlation([1, 2], [1]) }.to raise_error(ArgumentError)
      end
    end

    describe '.covariance' do
      it 'returns positive covariance for co-moving data' do
        expect(described_class.covariance([1, 2, 3, 4], [2, 4, 6, 8])).to be > 0
      end

      it 'returns negative covariance for inversely moving data' do
        expect(described_class.covariance([1, 2, 3, 4], [8, 6, 4, 2])).to be < 0
      end

      it 'raises for fewer than 2 values' do
        expect { described_class.covariance([1], [1]) }.to raise_error(ArgumentError)
      end
    end

    describe '.normalize' do
      it 'normalizes to 0..1 range' do
        result = described_class.normalize([10, 20, 30])
        expect(result).to eq([0.0, 0.5, 1.0])
      end

      it 'returns zeros for identical values' do
        expect(described_class.normalize([5, 5, 5])).to eq([0.0, 0.0, 0.0])
      end

      it 'raises on empty array' do
        expect { described_class.normalize([]) }.to raise_error(ArgumentError)
      end
    end

    describe '.standardize' do
      it 'produces mean ≈ 0 and stddev ≈ 1' do
        result = described_class.standardize([10, 20, 30, 40, 50])
        expect(described_class.mean(result)).to be_within(0.001).of(0.0)
        expect(described_class.stddev(result, population: false)).to be_within(0.001).of(1.0)
      end

      it 'returns zeros for identical values' do
        expect(described_class.standardize([7, 7, 7])).to eq([0.0, 0.0, 0.0])
      end

      it 'raises with fewer than 2 values' do
        expect { described_class.standardize([1]) }.to raise_error(ArgumentError)
      end
    end

    describe '.median_absolute_deviation' do
      it 'calculates MAD' do
        result = described_class.median_absolute_deviation([1, 1, 2, 2, 4, 6, 9])
        expect(result).to eq(1.0)
      end

      it 'returns 0 for identical values' do
        expect(described_class.median_absolute_deviation([3, 3, 3])).to eq(0.0)
      end

      it 'raises on empty array' do
        expect { described_class.median_absolute_deviation([]) }.to raise_error(ArgumentError)
      end
    end

    describe '.trimmed_mean' do
      it 'trims extreme values' do
        data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 100]
        trimmed = described_class.trimmed_mean(data, trim: 0.1)
        plain = described_class.mean(data)
        expect(trimmed).to be < plain
      end

      it 'equals mean with zero trim' do
        data = [1, 2, 3, 4, 5]
        expect(described_class.trimmed_mean(data, trim: 0.0)).to eq(described_class.mean(data))
      end

      it 'raises on empty array' do
        expect { described_class.trimmed_mean([]) }.to raise_error(ArgumentError)
      end

      it 'raises on invalid trim' do
        expect { described_class.trimmed_mean([1, 2], trim: 0.5) }.to raise_error(ArgumentError)
      end
    end

    describe '.winsorized_mean' do
      it 'replaces extremes with boundary values' do
        data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 100]
        winsorized = described_class.winsorized_mean(data, trim: 0.1)
        plain = described_class.mean(data)
        expect(winsorized).to be < plain
      end

      it 'raises on empty array' do
        expect { described_class.winsorized_mean([]) }.to raise_error(ArgumentError)
      end
    end
  end

  describe Philiprehberger::MathKit::Interpolation do
    describe '.linear' do
      let(:points) { [[0, 0], [10, 10]] }

      it 'returns exact value at known point' do
        expect(described_class.linear(points, 0)).to eq(0.0)
        expect(described_class.linear(points, 10)).to eq(10.0)
      end

      it 'interpolates midpoint' do
        expect(described_class.linear(points, 5)).to eq(5.0)
      end

      it 'interpolates between arbitrary points' do
        pts = [[0, 0], [5, 10], [10, 20]]
        expect(described_class.linear(pts, 2.5)).to eq(5.0)
        expect(described_class.linear(pts, 7.5)).to eq(15.0)
      end

      it 'extrapolates below range' do
        expect(described_class.linear(points, -5)).to eq(-5.0)
      end

      it 'extrapolates above range' do
        expect(described_class.linear(points, 15)).to eq(15.0)
      end

      it 'handles unsorted points' do
        pts = [[10, 20], [0, 0], [5, 10]]
        expect(described_class.linear(pts, 2.5)).to eq(5.0)
      end

      it 'raises with fewer than 2 points' do
        expect { described_class.linear([[1, 1]], 1) }.to raise_error(ArgumentError)
      end
    end
  end

  describe Philiprehberger::MathKit::Round do
    describe '.bankers' do
      it 'rounds half to even (down when even)' do
        expect(described_class.bankers(2.5)).to eq(2.0)
      end

      it 'rounds half to even (up when odd)' do
        expect(described_class.bankers(3.5)).to eq(4.0)
      end

      it 'rounds normally when not at halfway' do
        expect(described_class.bankers(2.3)).to eq(2.0)
        expect(described_class.bankers(2.7)).to eq(3.0)
      end

      it 'rounds with precision' do
        expect(described_class.bankers(2.55, precision: 1)).to eq(2.6)
        expect(described_class.bankers(2.45, precision: 1)).to eq(2.4)
      end

      it 'handles negative values' do
        expect(described_class.bankers(-2.5)).to eq(-2.0)
        expect(described_class.bankers(-3.5)).to eq(-4.0)
      end
    end

    describe '.ceiling' do
      it 'rounds up positive values' do
        expect(described_class.ceiling(2.1)).to eq(3.0)
      end

      it 'does not change whole numbers' do
        expect(described_class.ceiling(2.0)).to eq(2.0)
      end

      it 'rounds up with precision' do
        expect(described_class.ceiling(2.11, precision: 1)).to eq(2.2)
      end

      it 'rounds up negative values toward zero' do
        expect(described_class.ceiling(-2.9)).to eq(-2.0)
      end
    end

    describe '.floor' do
      it 'rounds down positive values' do
        expect(described_class.floor(2.9)).to eq(2.0)
      end

      it 'does not change whole numbers' do
        expect(described_class.floor(2.0)).to eq(2.0)
      end

      it 'rounds down with precision' do
        expect(described_class.floor(2.99, precision: 1)).to eq(2.9)
      end

      it 'rounds down negative values away from zero' do
        expect(described_class.floor(-2.1)).to eq(-3.0)
      end
    end

    describe '.truncate' do
      it 'truncates positive values toward zero' do
        expect(described_class.truncate(2.9)).to eq(2.0)
      end

      it 'truncates negative values toward zero' do
        expect(described_class.truncate(-2.9)).to eq(-2.0)
      end

      it 'truncates with precision' do
        expect(described_class.truncate(2.567, precision: 2)).to eq(2.56)
      end

      it 'does not change whole numbers' do
        expect(described_class.truncate(5.0)).to eq(5.0)
      end
    end
  end

  describe Philiprehberger::MathKit::MovingAverage do
    describe '.simple' do
      it 'calculates SMA with window of 3' do
        result = described_class.simple([1, 2, 3, 4, 5], window: 3)
        expect(result).to eq([2.0, 3.0, 4.0])
      end

      it 'calculates SMA with window equal to size' do
        result = described_class.simple([1, 2, 3], window: 3)
        expect(result).to eq([2.0])
      end

      it 'calculates SMA with window of 1' do
        result = described_class.simple([1, 2, 3], window: 1)
        expect(result).to eq([1.0, 2.0, 3.0])
      end

      it 'handles float values' do
        result = described_class.simple([1.0, 2.0, 3.0, 4.0], window: 2)
        expect(result).to eq([1.5, 2.5, 3.5])
      end

      it 'raises when window exceeds values size' do
        expect { described_class.simple([1, 2], window: 3) }.to raise_error(ArgumentError)
      end

      it 'raises when window is less than 1' do
        expect { described_class.simple([1], window: 0) }.to raise_error(ArgumentError)
      end
    end

    describe '.exponential' do
      it 'calculates EMA with alpha 0.5' do
        result = described_class.exponential([1, 2, 3, 4, 5], alpha: 0.5)
        expect(result.size).to eq(5)
        expect(result[0]).to eq(1.0)
        expect(result[1]).to eq(1.5)
        expect(result[2]).to eq(2.25)
        expect(result[3]).to eq(3.125)
        expect(result[4]).to eq(4.0625)
      end

      it 'calculates EMA with alpha 1.0 (no smoothing)' do
        result = described_class.exponential([1, 2, 3], alpha: 1.0)
        expect(result).to eq([1.0, 2.0, 3.0])
      end

      it 'returns single value for single element' do
        result = described_class.exponential([42], alpha: 0.5)
        expect(result).to eq([42.0])
      end

      it 'raises on empty array' do
        expect { described_class.exponential([], alpha: 0.5) }.to raise_error(ArgumentError)
      end

      it 'raises when alpha is 0' do
        expect { described_class.exponential([1], alpha: 0) }.to raise_error(ArgumentError)
      end

      it 'raises when alpha is greater than 1' do
        expect { described_class.exponential([1], alpha: 1.5) }.to raise_error(ArgumentError)
      end
    end
  end

  describe Philiprehberger::MathKit::Regression do
    describe '.linear' do
      it 'fits a perfect line' do
        result = described_class.linear([1, 2, 3, 4], [2, 4, 6, 8])
        expect(result.slope).to be_within(0.001).of(2.0)
        expect(result.intercept).to be_within(0.001).of(0.0)
        expect(result.r_squared).to be_within(0.001).of(1.0)
      end

      it 'predicts values' do
        result = described_class.linear([1, 2, 3, 4], [2, 4, 6, 8])
        expect(result.predict(5)).to be_within(0.001).of(10.0)
        expect(result.predict(0)).to be_within(0.001).of(0.0)
      end

      it 'fits noisy data with reasonable r_squared' do
        result = described_class.linear([1, 2, 3, 4, 5], [2.1, 3.9, 6.2, 7.8, 10.1])
        expect(result.slope).to be > 1.5
        expect(result.r_squared).to be > 0.95
      end

      it 'handles negative slope' do
        result = described_class.linear([1, 2, 3, 4], [8, 6, 4, 2])
        expect(result.slope).to be_within(0.001).of(-2.0)
        expect(result.intercept).to be_within(0.001).of(10.0)
      end

      it 'raises for mismatched sizes' do
        expect { described_class.linear([1, 2], [1]) }.to raise_error(ArgumentError)
      end

      it 'raises for fewer than 2 points' do
        expect { described_class.linear([1], [2]) }.to raise_error(ArgumentError)
      end

      it 'raises for identical x values' do
        expect { described_class.linear([5, 5, 5], [1, 2, 3]) }.to raise_error(ArgumentError)
      end
    end
  end
end

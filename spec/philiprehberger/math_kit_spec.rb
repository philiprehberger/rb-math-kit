# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::MathKit do
  it 'has a version number' do
    expect(described_class::VERSION).to eq('0.1.0')
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
end

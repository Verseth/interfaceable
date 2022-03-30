# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe Interfaceable do
  it 'has a version number' do
    expect(Interfaceable::VERSION).not_to be nil
  end

  module Barable
    def bar; end
  end

  module Fooable
    def foo; end
  end

  it 'raises if class does not implement a method' do
    expect do
      class Good
        extend Interfaceable

        implements Fooable

        def foo; end
      end
    end.to_not raise_error

    expect do
      class Bad
        extend Interfaceable

        implements Fooable
      end
    end.to raise_error(Interfaceable::Error, /Bad must implement.*Fooable#foo/m)
  end

  it 'does not catch errors during class definition' do
    expect do
      class Bad
        extend Interfaceable

        implements Fooable

        this_is_not_a_method
      end
    end.to raise_error(NameError)
  end

  it 'can implement multiples interfaces' do
    expect do
      class Bad2
        extend Interfaceable

        implements Fooable, Barable
      end
    end.to raise_error(Interfaceable::Error, /Bad2 must implement.*Fooable#foo.*Barable#bar/m)
  end

  it 'can call .implements multiple times' do
    expect do
      class Bad3
        extend Interfaceable

        implements Fooable
        implements Barable
      end
    end.to raise_error(Interfaceable::Error, /Bad3 must implement.*Fooable#foo.*Barable#bar/m)
  end
end
# rubocop:enable Metrics/BlockLength

require "test_helper"

class EtagTest < HRTest
  class DummyModel
    attr_reader :values

    def initialize(values)
      @values = values
    end
  end

  unless defined? Sequel
    module ::Sequel; class Model; end; end
  end

  test "#etag returns hash code of model's values" do
    attrs = { foo: "bar" }
    assert_equal attrs.hash, wrap(dummy_model(attrs)).etag
  end

  test "#etag raises if does not know how to calculate etag" do
    assert_raises HumbleRubyist::Decorators::Etag::InappropriateEtagSubjectError do
      wrap(1).etag
    end
  end

  test "#etag values are equal for identical objects" do
    assert_equal wrap(dummy_model(foo: 1)).etag, wrap(dummy_model(foo: 1)).etag
  end

  test "delegates unknown methods to underlying object" do
    m = dummy_model(foo: 1)
    def m.bar; 2; end
    assert_equal 2, wrap(m).bar
  end

  test "adds #etag to Enumerable" do
    assert wrap([]).respond_to?(:etag)
  end

  test "#etag for identical enumerables matches" do
    m1 = dummy_model(foo: 1)
    m2 = dummy_model(foo: 2)
    assert_equal wrap([m1, m2]).etag, wrap([m1.dup, m2.dup]).etag
  end

  private

  def wrap(things)
    HumbleRubyist::Decorators::Etag.new(things)
  end

  def dummy_model(values)
    DummyModel.new(values)
  end
end


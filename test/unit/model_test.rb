require "test_helper"

class MyModel < Trakstar::Models::Base
  synced_attr_accessor :id, :name
end

class ModelTest < Minitest::Test
  def test_that_it_only_syncs_empty_attributes
    my_model = MyModel.new

    my_model.sync = -> { flunk("Should not have been called") }

    my_model.name = "John"
    assert_equal "John", my_model.name
  end

  def test_calls_sync_when_getting_nil_attribute
    my_model = MyModel.new

    my_model.sync = -> { my_model.set("name", "Paul") }

    assert_equal "Paul", my_model.name
  end

  def test_calls_sync_is_only_called_once_even_when_attr_is_nil
    my_model = MyModel.new
    called = 0

    my_model.sync = -> { called += 1 }

    assert_equal 0, called
    assert_nil my_model.name
    assert_equal 1, called
    assert_nil my_model.name
    assert_equal 1, called
  end
end

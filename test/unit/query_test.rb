require 'test_helper'

class QueryTest < ActiveSupport::TestCase
  should "be valid" do
    assert Query.new.valid?
  end
end

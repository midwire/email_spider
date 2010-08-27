require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Result.new.valid?
  end
end

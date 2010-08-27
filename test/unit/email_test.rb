require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Email.new.valid?
  end
end

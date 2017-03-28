require 'rack/test'
require 'test/unit'
require_relative './lib/bloc_works'


class BlocWorkRackTests < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    BlocWorks::Application.new
  end

  def test_it_puts_bloc_heads
    get '/'
    assert last_response.ok?
  end

  def test_it_has_the_right_body
    get '/'
    assert_equal("Hello Blocheads!", last_response.body)
  end

end

require 'rack/test'
require 'test/unit'
require_relative './lib/bloc_works'
require '../bloc_books/app/controllers/books_controller'
require '../bloc_books/config/application'


class BlocWorkRackTests < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    BlocBooks::Application.new
  end

  def test_it_puts_bloc_heads
    get '/'
    assert last_response.ok?
  end

  def test_it_has_the_right_body
    get '/'
    assert_equal("Hello Blocheads!", last_response.body)
  end

  def test_it_gets_routed_to_welcome
    get '/books/welcome'
    assert_equal("<div>\n  <p>Welcome to BlocBooks!</p>\n  <p>Please start by reading Eloquent Ruby</p>\n</div>\n", last_response.body)
  end

end

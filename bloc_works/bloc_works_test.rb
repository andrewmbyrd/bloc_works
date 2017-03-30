require 'rack/test'
require 'test/unit'
require_relative './lib/bloc_works'
require '../bloc_books/app/controllers/books_controller'
require '../bloc_books/app/controllers/library_controller'
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

#  def test_it_invokes_controller_and_action_view
#    get '/books/welcome'
#    assert last_response.ok?
#  end

  def test_it_gets_routed_to_welcome
    get '/books/welcome'
    assert_equal("<div>\n  <p>Welcome to BlocBooks!</p>\n  <p>Please start by reading Super Ruby</p>\n</div>\n", last_response.body)
  end
=begin
  def test_it_can_do_stuff_for_show
    get '/books/show'
    assert_equal("Here is the page", last_response.body)
  end

  def test_it_can_do_stuff_for_edit
    put '/books/edit'
    assert_equal("the put verb works", last_response.body)
  end

  def test_it_can_do_stuff_for_create
    post '/books/create'
    assert_equal("the post verb works", last_response.body)
  end

  def test_it_can_do_stuff_for_delete
    delete '/books/delete'
    assert_equal("the delete verb works", last_response.body)
  end

  def test_it_gets_routed_to_library_welcome
    get '/library/show'
    assert_equal("<div>\n  <p>Welcome to Your Library!</p>\n  <p>Please select a book category</p>\n</div>\n", last_response.body)
  end

  def test_it_can_do_stuff_for_library_edit
    put '/library/edit'
    assert_equal("the library put verb works", last_response.body)
  end

  def test_it_can_do_stuff_for_library_create
    post '/library/create'
    assert_equal("the library post verb works", last_response.body)
  end

  def test_it_can_do_stuff_for_library_delete
    delete '/library/delete'
    assert_equal("the library delete verb works", last_response.body)
  end
=end
end

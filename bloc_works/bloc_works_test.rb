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


  def test_map
    app1 = app
    app1.route do
        map("", "books#welcome")
        map ":controller/:id/:action"
    end
    assert_equal(app1.router.rules[0][:destination], "books#welcome")
  end

  def test_look_up_url
    app1 = app
    app1.route do
        map("", "books#welcome")
        map ":controller/:id/:action"
    end

    assert_equal(app1.router.look_up_url("/").class, Proc)
  end

end

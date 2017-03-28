require 'bloc_works'
require_relative './bloc_books/app/controllers/books_controller'
require 'rack/test'

class BlocWorksTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    BlocWorks::Application
  end

  def test_it_puts_bloc_heads
    get '/'
    assert last_response.ok?
  end

end


class BooksController < BlocWorks::Controller

  def welcome
    render(:welcome, book: "Eloquent Ruby")
  end

  def index
    render(:index, books: Book.all)
  end

  def show
    book = Book.find(params['id'].to_i)
    render(:show, book: book)
  end

  #as examples, the URL books/home will redirect_to the welcome action,
  #list will redirect to the index action
  def home
    redirect_to("welcome")
  end

  def list
    redirect_to("index")
  end


end

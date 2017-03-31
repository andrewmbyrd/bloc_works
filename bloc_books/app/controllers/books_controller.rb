
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


end

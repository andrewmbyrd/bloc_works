
class BooksController < BlocWorks::Controller

  def welcome
    render(:welcome, book: "Eloquent Ruby")
  end

  def index
    render(:index, books: Book.all)
  end


end

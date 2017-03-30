
class BooksController < BlocWorks::Controller

  def welcome
    render(:welcome, book: "Eloquent Ruby")
  end

  def index
    render(:index, books: Book.all)
  end

  def show(book_num)
    render(:show, book: Book.find_one(book_num))
  end


end

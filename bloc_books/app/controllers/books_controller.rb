
class BooksController < BlocWorks::Controller

  def welcome
    render(:welcome, book: "Eloquent Ruby")
    @book = "Super Ruby"
  end

  def show
    "Here is the page"
  end

  def edit
    "the put verb works"
  end

  def delete
    "the delete verb works"
  end

  def create
    "the post verb works"
  end


end

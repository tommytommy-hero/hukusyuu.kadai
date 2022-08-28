class BooksController < ApplicationController

  def new
    @book=Book.new
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @newbook=Book.new
    @book_comment = BookComment.new
    @books=Book.all
    #book閲覧数について
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
  end

  def index
    @user = current_user
    @books = Book.all.order(params[:sort])
    @book = Book.new
  end


  def create
    @book = Book.new(book_params)
    @user=current_user
    @book.user_id = current_user.id
    tag_list = params[:book][:tag_name].split(',')
    if @book.save
       @book.save_tags(tag_list)
       redirect_to book_path(@book), notice: "You have created book successfully."
    else
       @books = Book.all
       render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user ==current_user
      render "edit"
    else
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :star)
  end
end

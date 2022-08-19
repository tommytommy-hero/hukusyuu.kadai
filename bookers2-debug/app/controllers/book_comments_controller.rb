class BookCommentsController < ApplicationController

  def create
    @book=Book.find(params[:book_id])
    @books=Book.all
    @comment = current_user.book_comments.new(book_comment_params)
    @comment.book_id = @book.id
    @comment.save
  end

  def destroy
    @books=Book.all
    BookComment.find(params[:id]).destroy
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end

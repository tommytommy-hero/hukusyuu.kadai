class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @search = params[:search]
    @word = params[:word]

    if @range == "User"
      @records = User.looks(@search, @word)
    elsif @range == "Book"
      @records = Book.looks(@search, @word)
    elsif @range == "Tag"
      @records = Tag.looks_for(@search, @word)
    end
  end
end

class ChaptersController < ApplicationController
  def index
    fields = [:title, :description, :content ]
    tables = [Chapter.index_name, Book.index_name]
    @chapters = Chapter.search(params).per(10).page(params[:page]).records
  end

  private
  def chapter_params
    params.require(:chapter).permit(:title, :description, :content, :q)
  end
end

class ChaptersController < ApplicationController
  def index
    @chapters = Chapter.search(params).page(params[:page]).records
  end

  private
  def chapter_params
    params.require(:chapter).permit(:title, :description, :content, :q)
  end
end

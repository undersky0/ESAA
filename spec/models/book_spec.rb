require 'rails_helper'
require 'spec_helper'




RSpec.describe Book, type: :model do
  include Docsplit

      before(:all) do

        @pdf_file = Rika::Parser.new(file_path("/Users/mac/RubymineProjects/ESAA/public/uploads/book/attachment/211/Richard_DLonesteen_CV.pdf"))
      end

    describe "testing alchemy API" do
      @file_path = "/Users/mac/RubymineProjects/ESAA/public/uploads/book/attachment/211/Richard_DLonesteen_CV.pdf"
      puts @pdf_file
      @title = Docsplit.extract_title("/Users/mac/RubymineProjects/ESAA/public/uploads/book/attachment/211/Richard_DLonesteen_CV.pdf")
      puts @title
      @length = Docsplit.extract_length("/Users/mac/RubymineProjects/ESAA/public/uploads/book/attachment/211/Richard_DLonesteen_CV.pdf")
      puts @length
      @pages = Docsplit.extract_from_pdf(@file_path, :pages => 1)
      puts @pages
    end
end

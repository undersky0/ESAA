require 'rails_helper'
require 'spec_helper'

RSpec.describe Book, type: :model do
   include Docsplit
   OUTPUT = 'spec/output'

      before(:all) do
        # FileUtils.rm_r(OUTPUT) if File.exists?(OUTPUT)11
        # converting to text files
        @file_path = Rails.root + "public/uploads/book/attachment/211/Richard_DLonesteen_CV.pdf"
        @sample = Rails.root + "spec/factories/sample.pdf"
        Docsplit.extract_text(@file_path, :output => OUTPUT)
        Docsplit.extract_text(@sample,{:pages => 'all', :output => OUTPUT, :pdf_opts => '-layout'})
      end

    describe "test_paged_extraction" do
      fit "reads text file" do
        files = Rails.root+"#{OUTPUT}/sample_1.txt"
        file = File.open(files, "r")
        data = ''
        file.each_line do | line|
          data += line
        end
        results1 = AlchemyAPI.search(:keyword_extraction, text: data)
        STDOUT.puts results1.inspect
        results2 = AlchemyAPI.search(:text_extraction, url: 'https://www.google.co.uk/')
        STDOUT.puts results2.inspect
        results3 = AlchemyAPI.search(:entity_extraction, text: data)
        STDOUT.puts results3.inspect
        puts "-" * 30
        keywords  = ''
          results1.each do |h|
              puts h
              puts "*" * 31
              puts "add text to variable: #{h['text']}" if h['relevance'].to_f > 0.5
              keywords << "#{h['text']}, " if h['relevance'].to_f > 0.5
              puts "-" *30
          end
        puts keywords
        end

      xit "finds file" do
        assert Dir[Rails.root+"#{OUTPUT}/*.txt"] == Dir[Rails.root+"#{OUTPUT}/Richard_DLonesteen_CV_1.txt"]
      end

      it "extracts title" do
        assert "Microsoft Word - RDLonesteen CV.docx" == Docsplit.extract_title(@file_path)
      end

      xit "extracts author" do
        puts "author:"
        puts Docsplit.extract_author(@file_path)
        #assert "" == Docsplit.extract_author(@file_path)
      end

      it "extracts date" do
        puts Docsplit.extract_date(@file_path)
        assert "Sun Mar  8 07:26:59 2015" == Docsplit.extract_date(@file_path)
      end

      it "extracts length" do
        puts Docsplit.extract_length(@file_path)
        assert 1 == Docsplit.extract_length(@file_path)
      end

      it "extracts producer" do
        puts Docsplit.extract_producer(@file_path)
        assert "Mac OS X 10.10.1 Quartz PDFContext" == Docsplit.extract_producer(@file_path)
      end

      it "extracts all info" do
        puts Docsplit.extract_info(@file_path)
        m = Docsplit.extract_info(@file_path)
        assert m[:date] == "Sun Mar  8 07:26:59 2015"
        assert m[:creator] == "Word"
        assert m[:keywords] == "Creator:        Word"
        assert m[:producer] == "Mac OS X 10.10.1 Quartz PDFContext"
        assert m[:length] == 1
        assert m[:title] == "Microsoft Word - RDLonesteen CV.docx"
      end
    end
end
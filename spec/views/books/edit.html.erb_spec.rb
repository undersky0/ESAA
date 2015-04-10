require 'rails_helper'

RSpec.describe "books/edit", type: :view do
  before(:each) do
    @book = assign(:book, Book.create!(
      :title => "MyString",
      :description => "MyString",
      :content => "MyText",
      :person_id => 1
    ))
  end

  it "renders the edit book form" do
    render

    assert_select "form[action=?][method=?]", book_path(@book), "post" do

      assert_select "input#book_title[name=?]", "book[title]"

      assert_select "input#book_description[name=?]", "book[description]"

      assert_select "textarea#book_content[name=?]", "book[content]"

      assert_select "input#book_person_id[name=?]", "book[person_id]"
    end
  end
end

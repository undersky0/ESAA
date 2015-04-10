require 'rails_helper'

RSpec.describe "articles/new", type: :view do
  before(:each) do
    assign(:article, Article.new(
      :title => "MyString",
      :description => "MyString",
      :content => "MyText",
      :person_id => 1
    ))
  end

  it "renders new article form" do
    render

    assert_select "form[action=?][method=?]", articles_path, "post" do

      assert_select "input#article_title[name=?]", "article[title]"

      assert_select "input#article_description[name=?]", "article[description]"

      assert_select "textarea#article_content[name=?]", "article[content]"

      assert_select "input#article_person_id[name=?]", "article[person_id]"
    end
  end
end

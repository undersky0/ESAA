require 'rails_helper'

RSpec.describe "articles/edit", type: :view do
  before(:each) do
    @article = assign(:article, Article.create!(
      :title => "MyString",
      :description => "MyString",
      :content => "MyText",
      :person_id => 1
    ))
  end

  it "renders the edit article form" do
    render

    assert_select "form[action=?][method=?]", article_path(@article), "post" do

      assert_select "input#article_title[name=?]", "article[title]"

      assert_select "input#article_description[name=?]", "article[description]"

      assert_select "textarea#article_content[name=?]", "article[content]"

      assert_select "input#article_person_id[name=?]", "article[person_id]"
    end
  end
end

require 'rails_helper'

RSpec.describe "people/index", type: :view do
  before(:each) do
    assign(:people, [
      Person.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :age => 1,
        :city => "City"
      ),
      Person.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :age => 1,
        :city => "City"
      )
    ])
  end

  it "renders a list of people" do
    render
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
  end
end

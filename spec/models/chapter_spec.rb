require 'rails_helper'

RSpec.describe Chapter, type: :model do
  p = Hash.new
  p['properties'] = {q: ""}

  describe "chapter search" do
    r = Chapter.search p
    puts r.inspect
    #a
  end
end
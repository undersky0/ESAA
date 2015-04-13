class Book < ActiveRecord::Base
  belongs_to :author
  has_many :chapters

  include BookSearch

end

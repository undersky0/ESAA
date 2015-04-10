class Person < ActiveRecord::Base

  has_many :articles
  has_many :books

  # after_update { self.articles.each(&:touch) }
  #
  # include ElasticsearchSearchable



end

require 'elasticsearch/model'
class Author < ActiveRecord::Base
  include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks
  # include Elasticsearch::Model::Indexing
  index_name 'author_books_chapters'
  has_many :books, dependent: :destroy
  include ElasticAfter
  index_name [Rails.env, model_name.collection.gsub(/\//, '-')].join('_')
  # include ParentChildSearchable

  # after_commit lambda { __elasticsearch__.index_document  },  on: :create
  # after_commit lambda { __elasticsearch__.update_document },  on: :update
  # after_commit lambda { __elasticsearch__.delete_document },  on: :destroy

  # settings index: { number_of_shards: 1, number_of_replicas: 1 } do
      mappings do
        indexes :lastname, type: :string
        indexes :firstname, type: :string
      end
    # end
end

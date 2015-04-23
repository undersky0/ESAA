require 'elasticsearch/model'
class Book < ActiveRecord::Base
  belongs_to :author
  has_many :chapters
  #include BookSearch
  include ElasticAfter
  include Elasticsearch::Model
  mount_uploader :attachment, AttachmentUploader
  # include Elasticsearch::Model::Callbacks
  # include Elasticsearch::Model::Indexing


  index_name [Rails.env, model_name.collection.gsub(/\//, '-')].join('_')
  # index_name 'author_books_chapters'
  # mappings _parent: { type: 'author', required: true } do
  # settings index: { number_of_shards: 1, number_of_replicas: 1 } do
  mappings do
      indexes :id, type: :integer
      indexes :book_type, type: :string
      indexes :title, type: :string
      indexes :fiction
      indexes :chapters_count, type: :integer
      indexes :price, type: :float
      indexes :author_id, type: :integer
      indexes :author_name
      indexes :updated_at, type: :date # Date example
  end
  def author_name
    " #{book.author.firstname} #{book.author.lastname} " if author.present?
  end
  def as_indexed_json(options = {})
    as_json methods: [:author_name]
  end

  # end




  # Book.__elasticsearch__.client.indices.delete index: Book.index_name rescue nil
  # #
  # # # Create the new index with the new mapping
  # Book.__elasticsearch__.client.indices.create index: Book.index_name, body: { settings: Book.settings.to_hash, mappings: Book.mappings.to_hash }
  # #
  # # # Index all article records from the DB to Elasticsearch
  # Book.import
  # after_commit lambda { __elasticsearch__.index_document(parent: author_id)  },  on: :create
  # after_commit lambda { __elasticsearch__.update_document(parent: author_id) },  on: :update
  # after_commit lambda { __elasticsearch__.delete_document(parent: author_id) },  on: :destroy
end

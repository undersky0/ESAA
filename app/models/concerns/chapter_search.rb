module ChapterSearch
  extend ActiveSupport::Concern

  included do
    require 'elasticsearch/model'
    include Elasticsearch::Model
    #include Elasticsearch::Model::Callbacks
    include Elasticsearch::Model::Indexing
    #It’s important to namespace the index somehow so that your environments don’t clash. We used this.
    index_name [Rails.env, model_name.collection.gsub(/\//, '-')].join('_')

    settings index: { number_of_shards: 5, number_of_replicas: 2 } do
        mappings dynamic: 'false' do
          indexes :id, type: :integer
          indexes :title, type: :string
          indexes :description, type: :string
          indexes :content, type: :string
          indexes :updated_at, type: :date # Date example

          indexes :book do
            indexes :id
            indexes :book_type
            indexes :title
            indexes :published_at
            indexes :author_id
            end
        end
      end


  def to_indexed_json
    to_json include: {book: { only: [:id, :book_type, :title, :published_at, :author_id]}}
  end
  end
end

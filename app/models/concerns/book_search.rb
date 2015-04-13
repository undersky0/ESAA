module BookSearch
  extend ActiveSupport::Concern

  included do
    require 'elasticsearch/model'
    include Elasticsearch::Model
    #include Elasticsearch::Model::Callbacks
    include Elasticsearch::Model::Indexing
    #It’s important to namespace the index somehow so that your environments don’t clash. We used this.
    index_name [Rails.env, model_name.collection.gsub(/\//, '-')].join('_')

  mappings dynamic: 'false' do
    indexes :id, type: :integer
    indexes :fiction?, type: :boolean, index: 'not_analyzed' # Boolean example
    indexes :chapter_count, type: :integer # Integer example
    indexes :price, type: :float # Float example
    indexes :published_at, type: :date # Date example

    # Nested document examples
    # indexes :chapters do
    #   indexes :id
    #   indexes :title
    #   indexes :content
    #   indexes :description
    # end

    indexes :author do
      indexes :id
      indexes :first_name, type: :string, analyzer: :keyword
      indexes :last_name, type: :string, analyzer: :keyword
    end
  end
  end


def to_indexed_json
   to_json include: {author: { only: [:id, :firstname, :lastname]}}
end
  # <span>By <%= book.authors.map { |a| link_to a.name, author_path(a.id) }.join(', ').html_safe %></span>


end

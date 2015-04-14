require 'elasticsearch/model'
class Chapter < ActiveRecord::Base
  belongs_to :book, :counter_cache => true
  include Elasticsearch::Model
  #include Elasticsearch::Model::Callbacks
  include Elasticsearch::Model::Indexing

  include ElasticAfter
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

  def self.search_text_fields
    self.content_columns.select {|c| [:string,:text].include?(c.type) }.map {|c| c.name }
  end

  # return array of model attributes to facet
  def self.search_facet_fields
    self.content_columns.select {|c| [:boolean,:decimal,:float,:integer,:string,:text].include?(c.type) }.map {|c| c.name }
  end

  def self.search(params)
    options ||= {}
    @search_definition = {
        query: {},
        filter: {},
        facets: {},
        highlight: { pre_tags: ['<strong>'],
                     post_tags: ['</strong>'],fields: { title: {}, content: {} } }
    }
    __set_filters = lambda do |key, f|

      @search_definition[:filter][:and] ||= []
      @search_definition[:filter][:and]  |= [f]

      @search_definition[:facets][key.to_sym][:facet_filter][:and] ||= []
      @search_definition[:facets][key.to_sym][:facet_filter][:and]  |= [f]
    end
    @search_definition[:facets] = search_facet_fields.each_with_object({}) do |a,hsh|
      hsh[a.to_sym] = {
          terms: {
              field: a
          },
         facet_filter: {}
      }
      end

    unless params[:q].blank?

      @search_definition[:query] = {
          bool: {
              should: [
                  { multi_match: {
                      query: params[:q],
                      # limit which fields to search, or boost here:
                      fields: [:title,:content],
                      operator: 'and'
                  }
                  }
              ]
          }
      }
    else
      options.each do |key,value|
        next unless search_facet_fields.include?(key)

        f = { term: { key.to_sym => value } }

        __set_filters.(key, f)

      end


      @search_definition[:query] =  { match_all: { } }
    end

    return __elasticsearch__.search(@search_definition)
  end



  Chapter.__elasticsearch__.client.indices.delete index: Chapter.index_name rescue nil
  #
  # # Create the new index with the new mapping
   Chapter.__elasticsearch__.client.indices.create index: Chapter.index_name, body: { settings: Chapter.settings.to_hash, mappings: Chapter.mappings.to_hash }
  #
  # # Index all article records from the DB to Elasticsearch
   Chapter.import
end

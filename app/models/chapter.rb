require 'elasticsearch/model'

class Chapter < ActiveRecord::Base
  belongs_to :book, :counter_cache => true
  include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks
  # include Elasticsearch::Model::Indexing

  #index_name 'author_books_chapters'
  # include Tire::Model::Search
  # include Tire::Model::Callbacks
  include ElasticAfter
  #It’s important to namespace the index somehow so that your environments don’t clash. We used this.
  index_name [Rails.env, model_name.collection.gsub(/\//, '-')].join('_')

  # after_commit lambda { __elasticsearch__.index_document(parent: book_id)  },  on: :create
  # after_commit lambda { __elasticsearch__.update_document(parent: book_id) },  on: :update
  # after_commit lambda { __elasticsearch__.delete_document(parent: book_id) },  on: :destroy

  # settings index: { number_of_shards: 1, number_of_replicas: 1 } do
    mappings  do
      indexes :id, type: :integer
      indexes :title, type: :string
      indexes :description, type: :string
      indexes :content, type: :string
      indexes :updated_at, type: :date # Date example
      indexes :book_title
      indexes :book_type
      indexes :author_name
      indexes :book_id

      # indexes :book do
      #   indexes :id
      #   indexes :book_type
      #   indexes :title
      #   indexes :published_at
      #   indexes :author_id
      # end
    end
  # end

  def book_title
    book.title
  end
  def book_type
    book.book_type
  end
  def author_name
   " #{book.author.firstname} #{book.author.lastname} "
  end

  def as_indexed_json(options = {})
    as_json methods: [:book_title, :book_type, :author_name]
  end

  def self.search_text_fields
    self.content_columns.select {|c| [:string,:text].include?(c.type) }.map {|c| c.name }
  end

  # return array of model attributes to facet
  def self.search_facet_fields
    self.content_columns.select {|c| [:boolean,:decimal,:float,:integer,:string,:text].include?(c.type) }.map {|c| c.name }
  end

  # def self.search(params)
  #   tire.search do
  #     query { string params[:query], default_operator: "AND" } if params[:query].present?
  #     filter :range, published_at: {lte: Time.zone.now}
  #   end

    # def self.search(params)
    #   fields = [:title, :description, :content ]
    #   tables = [Chapter.index_name, Book.index_name]
    #   tire.search(tables, {load: true,page: params[:page], per_page: 5}) do
    #     query do
    #       boolean do
    #         must { string params[:q], default_operator: "AND" } if params[:q].present?
    #         must { range :published_at, lte: Time.zone.now }
    #         must { term :book_id, params[:book_id] } if params[:book_id].present?
    #       end
    #     end
    #
    #     sort { by :published_at, "desc" } if params[:q].blank?
    #     facet "Books" do
    #       terms :title, :size => 10
    #       #terms :book_type, :size => 20, :order => 'term'
    #     end
    #     facet "books_type" do
    #       terms :book_type, :size => 2, :order => 'term'
    #     end
    #     highlight *fields, :options => { :tag => '<strong>' }
    #     # raise to_curl
    #   end
    #
    # end


  def self.search(params)
    options ||= {}
    models = ['development_chapters', 'developement_books']
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

    return Elasticsearch::Model.search(@search_definition)
  end


  def self.refresh_all
    a = [Author, Book, Chapter]
    a.each do |b|
    b.__elasticsearch__.client.indices.delete index: b.index_name rescue nil
    b.__elasticsearch__.client.indices.create index: b.index_name, body: { settings: b.settings.to_hash, mappings: b.mappings.to_hash }
    puts b.mappings.to_hash
    #b.import
      end
  end
  #
  # Chapter.__elasticsearch__.client.indices.delete index: Chapter.index_name rescue nil
  # #
  # # # Create the new index with the new mapping
  #  Chapter.__elasticsearch__.client.indices.create index: Chapter.index_name, body: { settings: Chapter.settings.to_hash, mappings: Chapter.mappings.to_hash }
  # #
  # # # Index all article records from the DB to Elasticsearch
  #  Chapter.import

  #tests
  # def custom_index
  #   Chapter.__elasticsearch__.client.index index: 'development_chapters', type: 'chapter', id: '141', body: { title: 'TEST', description: 'test', content: "test book title", book_type: "test book type", author_name: "test authoer name" }, refresh: true
  # end
  #
  # def testing_analyzer
  #   Chapter.__elasticsearch__.client.indices.analyze text: 'The Quick Brown Jumping Fox', analyzer: 'snowball'
  # end


  end

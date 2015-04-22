class Article < ActiveRecord::Base

  belongs_to :person, touch: true
  validates_presence_of :title

  # include ElasticsearchSearchable
  # require 'elasticsearch/model'
  # include Elasticsearch::Model
  # include Elasticsearch::Model::Indexing

  settings index: { number_of_shards: 2 } do
    mappings dynamic: 'false' do
      indexes :title,  boost: 10
      indexes :content
      indexes :city

      indexes :person_name
    end
  end

  def self.search_text_fields
    self.content_columns.select {|c| [:string,:text].include?(c.type) }.map {|c| c.name }
  end

  # return array of model attributes to facet
  def search_facet_fields
    self.content_columns.select {|c| [:boolean,:decimal,:float,:integer,:string,:text].include?(c.type) }.map {|c| c.name }
  end

  def self.search(params)

    @search_definition = {
        query: {},
        filter: {},
        facets: {},
        highlight: { pre_tags: ['<strong>'],
                     post_tags: ['</strong>'],fields: { title: {}, content: {} } }
    }

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
      @search_definition[:query] =  { match_all: { } }
    end

    return __elasticsearch__.search(@search_definition)
  end



  def person_name
    [person.first_name, person.last_name].join " "
  end


end

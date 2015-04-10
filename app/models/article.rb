class Article < ActiveRecord::Base

  belongs_to :person, touch: true

  # include ElasticsearchSearchable
  # require 'elasticsearch/model'
  include Elasticsearch::Model
  include Elasticsearch::Model::Indexing

  settings index: { number_of_shards: 2 } do
    mappings dynamic: 'false' do
      indexes :title,  boost: 10
      indexes :content
      indexes :city

      indexes :person_name
    end
  end


  def self.search(params)
    @search_definition = {
        query: {},
        filter: {},
        facets: {},
    }

    unless params[:q].blank?

      @search_definition[:query] = {
                                   query: {
                                       multi_match: {
                                           query: params[:q],
                                           operator: 'and'
                                       }
                                   },
                                   highlight: {
                                       pre_tags: ['<em>'],
                                       post_tags: ['</em>'],
                                       fields: {
                                           title: {},
                                           content: {}
                                       }
                                   }
                               }
    else
      @search_definition[:query] =  { match_all: { } }
    end

    return __elasticsearch__.search(params[:q])
  end



  def person_name
    [person.first_name, person.last_name].join " "
  end
end

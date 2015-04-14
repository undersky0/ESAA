module ElasticAfter
  extend ActiveSupport::Concern
  included do
  after_commit on: [:create] do
    __elasticsearch__.index_document if self.published?
  end

  after_commit on: [:update] do
    __elasticsearch__.update_document if self.published?
  end

  after_commit on: [:destroy] do
    __elasticsearch__.delete_document if self.published?
  end
end
end
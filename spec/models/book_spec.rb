require 'rails_helper'

RSpec.describe Book, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"


  describe 'book search', elasticsearch: true do
    before do
      # Create and destroy Elasticsearch indexes
      # between tests to eliminate test pollution
      Book.__elasticsearch__.create_index! index: Book.index_name

      # There are two options for how you create your objects
      # 1. Create your objects here and they should be synchronised
      # through the Elasticsearch::Model callbacks
      Book.create!
      # 2. Call import on the model which should reindex
      # anything you've "let!"
      Book.import

      # Sleeping here to allow Elasticsearch test cluster
      # to index the objects we created
      sleep 1
    end

    after do
      Book.__elasticsearch__.client.indices.delete index: Book.index_name
    end
  end
end

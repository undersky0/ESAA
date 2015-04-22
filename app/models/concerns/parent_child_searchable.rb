module ParentChildSearchable
  extend ActiveSupport::Concern
  INDEX_NAME = 'author_books_chapters'
  module ClassMethods
      def create_index!(options={})
        client = Author.__elasticsearch__.client
        client.indices.delete index: INDEX_NAME rescue nil if options[:force]

        setting = Author.settings.to_hash.merge Book.settings.to_hash
        mapping = Author.mappings.to_hash.merge Book.mappings.to_hash
        settings = setting.merge Chapter.settings.to_hash
        mappings = mapping.merge Chapter.mappings.to_hash


        client.indices.create index: INDEX_NAME,
                              body: {
                                  settings: settings.to_hash,
                                  mappings: mappings.to_hash }
      end
    end
end
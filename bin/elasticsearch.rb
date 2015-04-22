namespace :elasticsearch do
  task :reindex => :environment do
    index_name = "#{Person.index_name}_#{SecureRandom.hex}"
    client = Person.__elasticsearch__.client
    Person.__elasticsearch__.create_index! index: index_name, force: true
    Person.all.find_in_batches(batch_size: 1000) do |group|
      #...
    end
    # to be sure there is no index named Person.index_name
    client.indices.delete(index: Person.index_name) rescue nil
    # collecting old indices
    old_indices = client.indices.get_alias(name: Person.index_name).map do |key, val|
      { index: key, name: val['aliases'].keys.first }
    end
    # creating new alias
    client.indices.put_alias(index: index_name, name: Person.index_name)
    # removing old indices
    old_indices.each do |index|
      client.indices.delete_alias(index)
      client.indices.delete(index: index[:index])
    end
  end
end

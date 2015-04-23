AlchemyAPI.configure do |config|
  config.apikey = ENV['alchemy_api_key']
  #config.output_mode = :xml # not yet supported
end
# #config/initializers/redis.rb
# require 'redis'
# require 'redis/objects'

# REDIS_CONFIG = YAML.load( File.open( Rails.root.join("config/redis.yml") ) ).symbolize_keys
# dflt = REDIS_CONFIG[:default].symbolize_keys
# cnfg = dflt.merge(REDIS_CONFIG[Rails.env.to_sym].symbolize_keys) if REDIS_CONFIG[Rails.env.to_sym]

# $redis = Redis.new(cnfg)
# Redis::Objects.redis = $redis
# #$redis_ns = Redis::Namespace.new(cnfg[:namespace], :redis => $redis) if cnfg[:namespace]

# # To clear out the db before each test
# $redis.flushdb if Rails.env == "test"


require 'redis'

## Added rescue condition if Redis connection is failed
begin
  $redis = Redis.new(:host => Rails.configuration.redis_host, :port => 6379) 
rescue Exception => e
  puts e
end
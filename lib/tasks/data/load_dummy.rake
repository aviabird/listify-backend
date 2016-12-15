require 'twitter'
namespace :data do
  desc 'Create Lists Data'
  task load_dummy: :environment do
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "TSOSvmRILlXHXeci9WJPFwmEX"
      config.consumer_secret     = "5hoSZ6AkGnJ3u6UCicBnTK66lWkK36NYDa1Bm4LwAw4r1P0JBL"
      config.access_token        = "2511010010-V6Fr7skWkw2n4YNA1JjO4iVnmAOSpAn8ERXLvuU"
      config.access_token_secret = "F7oQ7mYXqtWrdYy0tiDPZSPeptz9EA2bdHUvgPfZ3M9gr"
    end
    # Get First List and save in to db
    list = @client.lists.first
    list_attr = { name: list.to_hash[:name], description: list.to_hash[:description] }
    listy = List.new(list_attr)
    listy.save

    puts "Imported List and created list record"

    # Retrive members
    members = @client.list_members(list)

    members.attrs[:users].each do |lmname|
      mem_attr = {}
      mem_attr[:twitter_id] = lmname[:id]
      mem_attr[:screen_name] = lmname[:screen_name]
      mem_attr[:uri] = lmname[:url]
      mem_attr[:list_ids] = [listy.id]
      new_member = Member.new(mem_attr)
      new_member.save
      puts "Imported member #{mem_attr[:screen_name]}"
    end
    puts "End"
  end
end
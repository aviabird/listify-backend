# rails data:load_dummy
require 'twitter'
namespace :data do
  desc 'Create Lists Data'
  task load_dummy: :environment do
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = ENV['USER_ACCESS_TOKEN']
      config.access_token_secret = ENV['USER_SECRET_TOKEN']
    end
    
    # Get First List and save in to db
    @client.lists.each do |list|
      list_attr = { name: list.to_hash[:name], description: list.to_hash[:description] }
      listy = List.new(list_attr)
      listy.save
    end

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
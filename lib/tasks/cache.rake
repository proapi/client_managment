#encoding: utf-8

namespace :cache do
  desc "Usuwa wszystkie możliwe dane wrzucone do cache"
  task :expire => :environment do
    Address.first.try :expire_all_cache
    Agent.first.try :expire_all_cache
    Bill.first.try :expire_all_cache
    Clearing.first.try :expire_all_cache
    Client.first.try :expire_all_cache
    Company.first.try :expire_all_cache
    Country.first.try :expire_all_cache
    Document.first.try :expire_all_cache
    Message.first.try :expire_all_cache
    User.first.try :expire_all_cache
  end
end
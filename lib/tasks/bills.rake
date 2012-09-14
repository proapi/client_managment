#encoding: utf-8

namespace :bills do
  desc "Changes all numbers into /2010 from /10"
  task :change_number => :environment do
    puts 'Start'
    Bill.all.each do |bill|
      if bill.payment_form.eql?("Za pobraniem")
        bill.payment_form = "Pobranie"
        bill.save
      end
      if bill.number.chomp[-3..-1].eql?('/10')
        bill.update_attribute(:number, bill.number.chomp.insert(-3, '20'))
        bill.save
      end
      if bill.number.chomp[-3..-1].eql?('/11')
        bill.update_attribute(:number, bill.number.chomp.insert(-3, '20'))
        bill.save
      end
      if bill.number.chomp[-3..-1].eql?('/12')
        bill.update_attribute(:number, bill.number.chomp.insert(-3, '20'))
        bill.save
      end
    end
    Bill.first.expire_all_cache
    puts 'Stop'
  end
end
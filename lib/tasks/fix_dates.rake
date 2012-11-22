#encoding: utf-8

namespace :fix_dates do
  desc "Changes dates in clearings"
  task :patch => :environment do
    puts 'Fix dates in clearings start'
    Clearing.all.each do |clearing|
      if clearing.decision_date
        year = nil
        if clearing.decision_date.year.to_i > Date.today.year.to_i
          puts "before: #{ActionController::Base.helpers.localize(clearing.decision_date)}"
          year = "19#{clearing.decision_date.year.to_s}"
        end
        if clearing.decision_date.year.to_i < 1900
          puts "before: #{ActionController::Base.helpers.localize(clearing.decision_date)}"
          year = "20#{clearing.decision_date.year.to_s}"
        end

        if year
          clearing.update_attribute(:decision_date, Date.strptime("#{clearing.decision_date.day}-#{clearing.decision_date.month}-#{year}", '%d-%m-%Y'))
          puts "after: #{ActionController::Base.helpers.localize(clearing.decision_date)}"
        end
      end
    end
    Clearing.first.expire_all_cache
    puts 'Fix dates in clearings stop'
  end
end
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :miniprofiler

  #OPTIMIZE sprawdzić, czy nie można tego zrobić w szybszy sposób, bo teraz sprawdza każdą wartość w hash
  def check_number_with_comma(params)
    hash = Hash.new
    params.each do |key, val|
      if val.is_a? Hash
        hash[key] = check_number_with_comma val
      else
        if /[0-9]+\,[0-9]+/.match(val)
          hash[key] = val.split(",").join(".")
        else
          hash[key] = val
        end
      end
    end
    hash
  end

  private
  def miniprofiler
    Rack::MiniProfiler.authorize_request if current_user.admin?
  end
end

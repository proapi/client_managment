class ApplicationController < ActionController::Base
  protect_from_forgery

  #OPTIMIZE sprawdzić, czy nie można tego zrobić w szybszy sposób, bo teraz sprawdza każdą wartość w hash
  def check_number_with_comma(params)
    hash = Hash.new
    params.each do |key, val|
      if /[0-9]+\,[0-9]+/.match(val)
        hash[key] = val.split(",").join(".")
      else
        hash[key] = val
      end
    end
    hash
  end
end

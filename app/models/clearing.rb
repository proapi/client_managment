class Clearing < ActiveRecord::Base
  belongs_to :client
  belongs_to :country
  attr_accessible :account_number, :application_date, :commission_currency, :commission_date, :commission_final, :commission_min, :commission_percent, :decision_date, :exchange_rate, :maturity_date, :office_send_date, :payment_date, :rebate_calc, :rebate_final, :tax_number, :year
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :clearing do
    client nil
    country nil
    tax_number "MyString"
    year "MyString"
    application_date "2012-06-01"
    commission_percent "MyString"
    commission_min ""
    commission_currency ""
    rebate_calc ""
    office_send_date "2012-06-01"
    rebate_final ""
    decision_date "2012-06-01"
    commission_final ""
    commission_date "2012-06-01"
    exchange_rate ""
    maturity_date "2012-06-01"
    payment_date "2012-06-01"
    account_number "MyString"
  end
end

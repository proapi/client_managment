# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    source "MyString"
    origin "MyString"
    body "MyText"
    user nil
    client nil
  end
end

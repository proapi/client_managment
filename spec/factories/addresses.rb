# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    street "MyString"
    code "MyString"
    city "MyString"
    client nil
    kind "MyString"
  end
end

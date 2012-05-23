# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client do
    lastname "MyString"
    firstname "MyString"
    birthdate "2012-05-21 16:25:06"
    telephone "MyString"
    mobile "MyString"
    email "MyString"
    identifier "MyString"
    description "MyText"
  end
end

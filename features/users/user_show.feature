Feature: Show Users
  As a visitor to the website
  I want to see registered users listed on the homepage
  so I can know if the site has users

    Scenario: Viewing users
      Given I exist as a user
      When I go to the list of users
      Then I should see my name

    Scenario: Viewing single user
      Given I am logged in
      When I go to the list of users
      And I click on my name
      Then I should see my accounts detailsI

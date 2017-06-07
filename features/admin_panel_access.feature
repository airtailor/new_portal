Feature: Admin Panel Access

    Scenario: Admin user can access admin panel
      Given I am on the "/users/sign_in" page
      And I log in as a "admin" user
      Then I should be redirected to the "/" page 
      When I click the "Users" link
      Then I should see "All Users"
      And I should see "Create User"

    Scenario: Tailor user cannot access admin panel
      Given I am on the "/users/sign_in" page
      And I log in as a "tailor" user
      Then I should be redirected to the "/" page 
      And I should not see "Users"
      When I go to the "/admin/users" page
      Then I should be redirected to the "/" page 
      And I should see "Access Denied" 



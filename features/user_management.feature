Feature: User Management

  Background:
    Given I am on the "/users/sign_in" page
    And I log in as a "admin" user
    Then I should be redirected to the "/" page 
    When I click the "Users" link
    Then I should see "All Users"
    And I should see "Create User"

    Scenario Outline: Creating Users
      When I click the "Create New User" link
      Then I should be brought to the "/admin/users/new" page
      And I should see "New User"
      When I create a new "<user_type>" user
      And I click the "Create User" button
      Then I should see "User created successfully"
      #And I should see the new user's "email"
      #And I should see the new user's "role"

      Examples: 
        | user_type | 
        | tailor    |
        | admin     |
    

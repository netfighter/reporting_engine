Feature: Permissions

  Scenario: Anonymous user sees no costs
    Given I am not logged in
    And there is 1 Project with the following:
      | Name      | Test |
    And the project "Test" has 1 cost entry    
    And I am on the Cost Reports page for the project called Test
    Then I should see "Login:"
    And I should see "Password:"
    
  Scenario: Admin user sees everything
    Given I am admin
    And there is 1 project with the following:
      | Name | Test |
    And there is 1 cost type with the following:
      | name      | Translation |
      | cost rate | 1           |
    And the project "Test" has 1 cost entry with the following:
      | units | 424 |
    And I am on the Cost Reports page for the project called Test
    Then I should not see "No data to display"
    And I start debugging
    And I should see "424.00"
    And I should see "Translation"

  Scenario: User who can see own costs, ONLY sees own costs
    Given I am not logged in
    And there is 1 project with the following:
      | Name | Test |
    And there is 1 User with:
      | Login | bob |
      | Firstname | Bob |
      | Lastname | Bobbit |
    And the user "bob" is a "Developer" in the project "Test"
    And the role "Developer" may have the following rights:
      | View own cost entries |
    And there is 1 cost type with the following:
      | name      | Translation |
      | cost rate | 1           |
    And the user "bob" has 1 issue with the following:
      | subject | bobs issue |
    And the issue "bobs issue" has 1 cost entry with the following:
      | user      | bob         |
      | units     | 5           |
      | cost type | Translation |
    And there is 1 cost type with the following:
      | name | Hidden Costs |
    And the project "Test" has 1 cost entry with the following:
      | units | 128128 |
    And I am logged in as "bob"
    And I am on the Cost Reports page for the project called "Test"
    Then I should not see "No data to display"
    And I should see "5.00"          # 5 Translations x 10 EUR
    And I should not see "128128.00"  # The other cost entries
    And I should not see "128,128.00" # The other cost entries in american writing

  Scenario: User who can see own time entries, ONLY sees own time entries
    Given I am not logged in
    And there is 1 project with the following:
      | Name | Test |
    And there is 1 User with:
      | Login 				| bob 		|
      | Firstname 		| Bob 		|
      | Lastname 			| Bobbit 	|
      | default rate  | 20.0    |
    And the user "Bob" is a "Developer" in the project "Test"
    And the role "Developer" may have the following rights:
      | View own time entries |
    And the user "Bob" has 1 time entry
    And the project "Test" has 2 time entries with the following:
      | hours | 11 |
    And I am logged in as "bob"
    And I am on the Cost Reports page for the project called "Test"
    Then I should not see "No data to display"
    And I should not see "0.00"
    And I should not see "11"
    And I should not see "220.00"

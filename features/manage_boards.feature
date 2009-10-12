Feature: Manage Boards
  In Order to rent or lend my surfboards to people
  As a surfer or a boardshop
  I want to list the baords I have available to rent or borrow

  Scenario: Boards List
    Given I have boards made by Channel Islands and Hurley
    When I go to my list of boards
    Then I should see "Channel Islands"
    And I should see "Hurley"

  @js
  Scenario: Create Valid Board
    Given I have no boards
    And the following user record
      | first_name | last_name   | email            | password |
      | Kelly | Slater | sl8ts@domain.com | secret   |
    And I am on the home page
    And I am logged in as "sl8ts@domain.com" with password "secret"
    When I follow "rent"
    And I fill in "addressInput" with "122 Newport Ave, Grover Beach, CA 93433, USA"
    And I press "addressLookup"
    And I fill in "Maker" with "Town and Country"
    And I fill in "board_length_feet" with "7"
    And I fill in "board_length_inches" with "2"
    And I fill in "board_style_name" with "gun"
    And I press "Create"
    Then I should see "Your board has been added"
    And I should see "Town & Country"
    And I should see "7'2\""
    And I should see "gun"
    And I should have 1 board

Feature: Manage Boards
  In Order to rent or lend my surfboards to people
  As a surfer or a boardshop
  I want to list the baords I have available to rent or borrow

  Scenario: Boards List
    Given I have boards made by Channel Islands and Hurley
    When I go to my list of boards
    Then I should see "Channel Islands"
    And I should see "Hurley"

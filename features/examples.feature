Feature: Examples of syntax not recognized

  These are some steps that RubyMine flags as having bad syntax (e.g. not
  recognized steps, etc.)



# In this Scenario, the following lines are not recognized as steps by
# RubyMine, even though they _are_ defined and they pass when run:
#   Then I should see "Hello there"
#   And I should not see "Howdy"
#
Scenario: I should see with parameter types is not recognized
  Given I am on the home page
  Then I should see "Hello there"
  And I should not see "Howdy"


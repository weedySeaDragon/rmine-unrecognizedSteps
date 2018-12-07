# README

This is a simple Ruby on Rails application so that I can show the cucumber steps that 
RubyMine has trouble recognizing.

## Application Setup
* Ruby version 2.5.1
* Rails version '~> 5.2.2'
* Rubymine version 2018.3
  - Build #RM-183.4284.145, built on November 20, 2018
  - JRE: 1.8.0_152-release-1343-b15 x86_64
  - JVM: OpenJDK 64-Bit Server VM by JetBrains s.r.o
  - macOS 10.13.6

I created a Rails application in Rubymine and added (and installed where appropriate) these gems:
 
* devise
* rspec-rails
* database_cleaner
* cucumber
* cucumber-rails

I created a basic User model with `rails g scaffold User firstname:string, lastname:string`
and did the appropriate `db:migrate`s


### Feature, Scenario, Steps, Parameter Types

Here's what I did to create the cucumber stuff needed to show some steps that Rubymine has problems with:
* added `parameter types` by coping `features/support/parameter_types.rb` from the SHF project
* added some cucumber steps.  
  - created a simple navigation step (_go to the home page_).
  - copied `assertion_steps.rb` from the SHF project.  I removed any steps that specifically
    involved SHF domain objects.  I left the rest of the steps in there even though I'm not using them at the moment.  

* created a feature file `features/examples.feature`
  - wrote a simple scenario that shows that RubyMine doesn't recognize 2 steps that
use `parameter types`: 
    ```
     I should see steps that use parameter types are not recognized
    ```
    which means that _"I should see ..." steps that use parameter types are not recognized by Rubymine.
    
    
##### The Scenario passes even though Rubymine reports that the steps are not defined.     



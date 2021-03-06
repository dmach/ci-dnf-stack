Feature: Enabling module stream

  @setup
  Scenario: Testing repository Setup
      Given I run steps from file "modularity-repo-1.setup"
       When I enable repository "modularityABDE"
        And I successfully run "dnf makecache"

  Scenario: I can enable a module when specifying stream
       When I successfully run "dnf module enable ModuleA:f26 -y"
       Then a module ModuleA config file should contain
          | Key     | Value   |
          | state   | enabled |
          | stream  | f26     |
       And the command stdout should match regexp "Enabling module streams:"
       And the command stdout should match regexp "ModuleA +f26"

  Scenario: I can enable a module when specifying both stream and corrent version
       When I successfully run "dnf module enable ModuleB:f26:1 -y"
       Then a module "ModuleB" config file should contain
          | Key     | Value   |
          | state   | enabled |
          | stream  | f26     |
       And the command stdout should match regexp "Enabling module streams:"
       And the command stdout should match regexp "ModuleB +f26"

  Scenario: Enabling of an already enabled module would pass
       When I successfully run "dnf module enable ModuleA:f26 -y"
       Then a module ModuleA config file should contain
          | Key     | Value   |
          | state   | enabled |
          | stream  | f26     |
       And the command stdout should match regexp "Nothing to do."

  Scenario: I can't enable a different stream of an already enabled module
       When I run "dnf module enable ModuleA:f27 --assumeyes"
       Then the command should fail
        And a module ModuleA config file should contain
          | Key     | Value   |
          | state   | enabled |
          | stream  | f26     |
       And the command stderr should match regexp "The operation would result in switching of module 'ModuleA' stream 'f26' to stream 'f27'"
       And the command stderr should match regexp "Error: It is not possible to switch enabled streams of a module."

  Scenario: Enabling a module doesn't install any packages
        When I save rpmdb
        And I successfully run "dnf -y module enable ModuleA:f26"
        Then a module ModuleA config file should contain
           | Key     | Value   |
           | state   | enabled |
           | stream  | f26     |
        And rpmdb does not change

Feature: Enabling module stream - error handling

  @setup
  Scenario: Testing repository Setup
      Given I run steps from file "modularity-repo-1.setup"
       When I enable repository "modularityABDE"

  Scenario: Disabling a module stream by referring the wrong version should fail
       When I successfully run "dnf module enable ModuleA:f26 -y"
        And I run "dnf module disable ModuleA:f26:999"
       Then the command exit code is 1
        And the command stderr should match regexp "Unable to resolve argument ModuleA:f26:999\nError: Problems in request:\nmissing groups or modules: ModuleA:f26:999\n"

  Scenario: Disabling a module by referring the wrong stream should fail
       When I run "dnf module disable ModuleA:f00 -y"
       Then the command exit code is 1
        And the command stderr should match regexp "Unable to resolve argument ModuleA:f00\nError: Problems in request:\nmissing groups or modules: ModuleA:f00\n"

  Scenario: Disabling a non-existing module should fail
       When I run "dnf module disable ModuleC -y"
       Then the command exit code is 1
        And the command stderr should match regexp "Unable to resolve argument ModuleC\nError: Problems in request:\nmissing groups or modules: ModuleC\n"

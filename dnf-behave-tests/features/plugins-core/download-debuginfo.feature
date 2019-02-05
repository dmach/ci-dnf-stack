Feature: dnf download --debuginfo command


Scenario: Download a debuginfo for an RPM that doesn't exist
  Given I enable plugin "download"
    And I use the repository "dnf-ci-fedora"
   When I execute dnf with args "download --debuginfo does-not-exist"
   Then the exit code is 1
    And stderr contains "No package does-not-exist available"


Scenario: Download a debuginfo for an existing RPM
  Given I enable plugin "download"
    And I use the repository "dnf-ci-fedora-updates"
   When I execute dnf with args "download --debuginfo libzstd"
   Then the exit code is 0
    And stdout contains "libzstd-debuginfo-1.3.6-1.fc29.x86_64.rpm"
    And file sha256 checksums are following
        | Path                                          | sha256                                                                                                        |
        | libzstd-debuginfo-1.3.6-1.fc29.x86_64.rpm     | file://{context.dnf.fixturesdir}/repos/dnf-ci-fedora-updates/x86_64/libzstd-debuginfo-1.3.6-1.fc29.x86_64.rpm |


Scenario: Download a debuginfo for an existing RPM with a different name
  Given I enable plugin "download"
    And I use the repository "dnf-ci-fedora"
   When I execute dnf with args "download --debuginfo nscd"
   Then the exit code is 0
    And stdout contains "glibc-debuginfo-2.28-9.fc29.x86_64.rpm"
    And stdout does not contain "glibc-debuginfo-common-2.28-9.fc29.x86_64.rpm"
    And file sha256 checksums are following
        | Path                                          | sha256                                                                                                |
        | glibc-debuginfo-2.28-9.fc29.x86_64.rpm        | file://{context.dnf.fixturesdir}/repos/dnf-ci-fedora/x86_64/glibc-debuginfo-2.28-9.fc29.x86_64.rpm    |
        | glibc-debuginfo-common-2.28-9.fc29.x86_64.rpm | -                                                                                                     |

# TODO: glibc-debuginfo-common should be ideally downloaded as well


Scenario: Download an existing --debuginfo RPM with --verbose option
  Given I enable plugin "download"
    And I use the repository "dnf-ci-fedora-updates"
   When I execute dnf with args "download --debuginfo libzstd --verbose"
   Then the exit code is 0
    And stdout contains "libzstd-debuginfo-1.3.6-1.fc29.x86_64.rpm"
    And file sha256 checksums are following
        | Path                                          | sha256                                                                                                        |
        | libzstd-debuginfo-1.3.6-1.fc29.x86_64.rpm     | file://{context.dnf.fixturesdir}/repos/dnf-ci-fedora-updates/x86_64/libzstd-debuginfo-1.3.6-1.fc29.x86_64.rpm |

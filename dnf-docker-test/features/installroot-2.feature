Feature: DNF/Behave test (installroot test)

Scenario: Install package from installroot repository into installroot, and test metadata handling in installroot
  Given _deprecated I use the repository "test-1"
  When _deprecated I execute "dnf" command "config-manager --setopt=reposdir=/dockertesting/etc/yum.repos.d --add-repo /etc/yum.repos.d/test-1.repo" with "success"
  Then _deprecated the path "/dockertesting/etc/yum.repos.d/test-1.repo" should be "present"
# Install first package from installroot repo into installroot and make cache for metadata in installroot.
# It have to prefer installroot repo
  Given _deprecated I use the repository "upgrade_1"
  When _deprecated I execute "dnf" command "install --installroot=/dockertesting --releasever=23 -y TestC" with "success"
  When _deprecated I execute "bash" command "rpm -q --root=/dockertesting TestC" with "success"
  Then _deprecated line from "stdout" should "start" with "TestC-1.0.0-1."
  When _deprecated I execute "bash" command "rpm -q TestC" with "fail"
# Install package from host repo into host and make host cache for metadata in host
  When _deprecated I execute "dnf" command "install -y TestB" with "success"
  Then _deprecated transaction changes are as follows
    | State        | Packages      |
    | installed    | TestB-1.0.0-2 |
# Delete installroot cache and commands for installroot with -C should fail
  When _deprecated I execute "bash" command "rm -rf /dockertesting/var/cache/dnf/*" with "success"
  When _deprecated I execute "dnf" command "install --installroot=/dockertesting --releasever=23  -y -C TestB" with "fail"
  When _deprecated I execute "bash" command "rpm -q --root=/dockertesting TestB" with "fail"
# If makecache for installroot it downloads correct metadata for installroot and install package with -C into installroot
  When _deprecated I execute "dnf" command "--installroot=/dockertesting --releasever=23  makecache" with "success"
  When _deprecated I execute "dnf" command "install --installroot=/dockertesting --releasever=23  -y -C TestB" with "fail"
  When _deprecated I execute "bash" command "rpm -q --root=/dockertesting TestB" with "fail"
  When _deprecated I execute "dnf" command "install --installroot=/dockertesting --releasever=23  -y --downloadonly TestB" with "success"
  When _deprecated I execute "dnf" command "install --installroot=/dockertesting --releasever=23  -y -C TestB" with "success"
  When _deprecated I execute "bash" command "rpm -q --root=/dockertesting TestB" with "success"
  Then _deprecated line from "stdout" should "start" with "TestB-1.0.0-1."
  When _deprecated I execute "dnf" command "remove --installroot=/dockertesting --releasever=23 -y TestB" with "success"
  When _deprecated I execute "bash" command "rpm -q --root=/dockertesting TestB" with "fail"
  When _deprecated I execute "bash" command "rpm -q TestB" with "success"
  Then _deprecated line from "stdout" should "start" with "TestB-1.0.0-2."

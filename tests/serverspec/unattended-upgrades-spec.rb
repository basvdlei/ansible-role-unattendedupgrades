require_relative "spec_helper"

describe package("unattended-upgrades") do
  it { should be_installed }
end

describe "Config files" do
  describe file("/etc/apt/apt.conf.d/20auto-upgrades") do
    it { should exist }
    its(:content) { should match /^APT::Periodic::Update-Package-Lists "1";$/ }
    its(:content) { should match /^APT::Periodic::Unattended-Upgrade "1";$/ }
  end

  describe file("/etc/apt/apt.conf.d/50unattended-upgrades") do
    it { should exist }
    its(:content) { should match /^\s*"origin=Debian,codename=\${distro_codename},label=Debian";$/ }
    its(:content) { should match /^\s*"origin=Debian,codename=\${distro_codename},label=Debian-Security";$/ }
    its(:content) { should match /^Unattended-Upgrade::AutoFixInterruptedDpkg "true";$/ }
    its(:content) { should match /^Unattended-Upgrade::MinimalSteps "false";$/ }
    its(:content) { should match /^Unattended-Upgrade::InstallOnShutdown "false";$/ }
    its(:content) { should match /^Unattended-Upgrade::Mail "";$/ }
    its(:content) { should match /^Unattended-Upgrade::MailOnlyOnError "false";$/ }
    its(:content) { should match /^Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";$/ }
    its(:content) { should match /^Unattended-Upgrade::Remove-New-Unused-Dependencies "true";$/ }
    its(:content) { should match /^Unattended-Upgrade::Remove-Unused-Dependencies "false";$/ }
    its(:content) { should match /^Unattended-Upgrade::Automatic-Reboot "false";$/ }
    its(:content) { should match /^Unattended-Upgrade::Automatic-Reboot-WithUsers "true";$/ }
    its(:content) { should match /^Unattended-Upgrade::Automatic-Reboot-Time "now";$/ }
    its(:content) { should match /^Unattended-Upgrade::SyslogEnable "false";$/ }
    its(:content) { should match /^Unattended-Upgrade::SyslogFacility "daemon";$/ }
    its(:content) { should match /^Unattended-Upgrade::Verbose "false";$/ }
    its(:content) { should match /^Unattended-Upgrade::Debug "false";$/ }
  end
end

describe "Systemd unit" do
  describe service("unattended-upgrades.service") do
    it { should be_enabled }
    it { should be_running }
  end

  describe service("apt-daily.timer") do
    it { should be_enabled }
    it { should be_running }
  end

  describe service("apt-daily-upgrade.timer") do
    it { should be_enabled }
    it { should be_running }
  end
end

describe "Dry run" do
  describe command("unattended-upgrades -d --dry-run") do
    its(:exit_status) { should eq 0 }
  end
end

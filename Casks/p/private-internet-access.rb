cask "private-internet-access" do
  version "3.5.5-08091"
  sha256 "52608158c462d8cabb4a7159da621d60543206aa560605d96f78c4738a98270b"

  url "https://installers.privateinternetaccess.com/download/pia-macos-#{version}.zip"
  name "Private Internet Access"
  desc "VPN client"
  homepage "https://www.privateinternetaccess.com/"

  livecheck do
    url "https://www.privateinternetaccess.com/installer/x/download_installer_osx"
    regex(/pia-macos-(\d+(?:.\d+)*)\.zip/i)
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  installer script: {
    executable: "Private Internet Access Installer.app/Contents/Resources/vpn-installer.sh",
    sudo:       true,
  }

  uninstall launchctl: [
              "com.privateinternetaccess.vpn.daemon",
              "com.privateinternetaccess.vpn.installhelper",
            ],
            quit:      "com.privateinternetaccess.vpn",
            delete:    [
              "/Applications/Private Internet Access.app",
              "/usr/local/bin/piactl",
            ]

  # The uninstall script should only be used with --zap because it removes all preference files
  zap script: {
    executable: "/Applications/Private Internet Access.app/Contents/Resources/vpn-installer.sh",
    args:       ["uninstall"],
    sudo:       true,
  }, trash: [
    "~/Library/Application Support/com.privateinternetaccess.vpn",
    "~/Library/LaunchAgents/com.privateinternetaccess.vpn",
    "~/Library/LaunchAgents/com.privateinternetaccess.vpn.client.plist",
    "~/Library/Preferences/com.privateinternetaccess.vpn",
    "~/Library/Preferences/com.privateinternetaccess.vpn.plist",
    "~/Library/Preferences/com.privateinternetaccess.vpn.support-tool.com.privateinternetaccess.vpn.plist",
  ]
end

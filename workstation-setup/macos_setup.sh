defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5
killall Dock
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES 
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder AppleShowAllFiles TRUE
killall Finder
defaults write com.apple.screencapture location ~/Pictures/Screenshots
mkdir ~/git
cp ~/Library/Preferences/com.apple.symbolichotkeys.plist ~/Library/Preferences/com.apple.symbolichotkeys.plist.bak
cp com.apple.symbolichotkeys.plist ~/Library/Preferences
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
killall SystemUIServer

sudo launchctl load /Library/LaunchDaemons/com.custom.ttl.ipv4.plist
sudo launchctl load /Library/LaunchDaemons/com.custom.ttl.ipv6.plist
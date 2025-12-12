cp com.custom.ttl.ipv4.plist /Library/LaunchDaemons/com.custom.ttl.ipv4.plist
cp com.custom.ttl.ipv6.plist /Library/LaunchDaemons/com.custom.ttl.ipv6.plist

sudo launchctl load /Library/LaunchDaemons/com.custom.ttl.ipv4.plist
sudo launchctl load /Library/LaunchDaemons/com.custom.ttl.ipv6.plist
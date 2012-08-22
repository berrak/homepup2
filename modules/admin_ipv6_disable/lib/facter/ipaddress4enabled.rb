# Fact: ipaddress6enabled
#
# Purpose: Returns either nil (no ipv6) or
# string 'ipv6' if enabled an ipv6 enabled system.
#
# Resolution:
# Test if Linux kernel exports the ipv6 variables to user space.
#
Facter.add(:ipaddress4enabled) do
  confine :kernel => :linux
  setcode do
    output = Facter::Util::Resolution.exec('/bin/ls /proc/sys/net')
    ip = nil
    
    output.scan(/ipv4/).each do |str|
      ip = str.to_s
    end
    
  end
end


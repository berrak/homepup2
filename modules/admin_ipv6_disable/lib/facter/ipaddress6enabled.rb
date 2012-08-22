# Fact: ipaddress6enabled
#
# Purpose: Returns either nil (no ipv6) or
# string 'ipv6' if enabled an ipv6 enabled system.
#
# Resolution:
# Test if Linux kernel exports the ipv6 variables to user space.
#
def get_ipv6_label(output)
  ip = nil

  output.scan(/ipv6/).each do |match|
    match = match.first
  end
  
  ip = match
end

Facter.add(:ipaddress6enabled) do
  confine :kernel => :linux
  setcode do
    output = Facter::Util::Resolution.exec('/bin/ls /proc/sys/net')
    get_ipv6_label(output)
  end
end


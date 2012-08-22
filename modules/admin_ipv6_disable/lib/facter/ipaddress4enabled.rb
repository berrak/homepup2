# Fact: ipaddress4enabled
#
# Purpose: Returns either nil (no ipv4) or
# string 'ipv4' in an ipv4 enabled system.
#
# Resolution:
# Test if Linux kernel exports the ipv4 variables to user space.
# Fact as complementary to 'ipaddress6enabled' for test.
#
# Copyright (C) (2012) K-B.Kronlund <bkronmailbox-copyright@yahoo.se>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
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


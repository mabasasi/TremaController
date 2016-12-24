require 'ipaddr'

class NetworkTable

  def initialize()
    @db = {}
    @db[1] = IPAddr.new("172.16.0.0/24")
    @db[2] = IPAddr.new("192.168.100.0/24")
    @db[3] = IPAddr.new("192.168.200.0/24")
  end

  def dump()
    if (@db.size == 0)
      puts "  permission table empty."
      return
    end

    @db.each{|key, value|
      puts "  port#{key} : #{value}"
    }
  end




end

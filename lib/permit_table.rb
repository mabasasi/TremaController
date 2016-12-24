# Permit table
require 'ipaddr'
require 'pio'

class PermitTable

  class PermitEntity
    attr_reader :ip_address
    attr_reader :first_access_time
    attr_reader :last_access_time
    attr_reader :access_count

    def initialize(ip_address)
      @ip_address        = ip_address
      @first_access_time = Time.now
      @last_access_time  = Time.now
      @access_count      = 1
    end

    def access()
      @last_access_time = Time.now
      @access_count    += 1
    end

    def to_s()
      time = @last_access_time - @first_access_time

      return " #{@ip_address}, fa: #{@first_access_time}, la: #{@last_access_time}"+
        ", time: #{time}, conut: #{@access_count}"
    end
  end


  def initialize()
    @db = {}
  end


  def add(mac_address, ip_address)
    return unless (defined? mac_address or defined? ip_address)

    if @db[mac_address]
      #puts "already exists."
      @db[mac_address].access
    else
      #puts "new terminal."
      @db[mac_address] = PermitEntity.new(ip_address)
    end
  end



  def dump()
    if (@db.size == 0)
      puts "  permission table empty."
      return
    end

    @db.each{|key, value|
      puts "  #{key} : #{value}"
    }
  end

end

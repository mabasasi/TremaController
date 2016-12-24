

class PacketWrapper


  def initialize()
    @source_port        = nil
    @packet_class       = nil

    @source_ip_address  = nil
    @source_mac_address = nil
    @dest_ip_address    = nil
    @dest_mac_address   = nil
  end



  def parse_packet(packet_in)
    reset
    $data = packet_in.data

    @source_port  = packet_in.in_port
    @packet_class = packet_in.data.class

    if defined? $data.source_mac
      @source_mac_address = $data.source_mac
    end

    if defined? $data.destination_mac
      @dest_mac = $data.destination_mac
    end

    if defined? $data.source_ip_address
      @source_ip_address = $data.source_ip_address
    end

    if defined? $data.destination_ip_address
      @dest_ip_address = $data.destination_ip_address
    end
    return self
  end



  def show()
    puts "[#{@source_port}](#{@packet_class}): #{@source_mac_address}(#{@source_ip_address}) -> #{@dest_mac_address}(#{@dest_ip_address})"
  end

  def get_source_ip()
    return @source_ip_address
  end

  def get_source_mac()
    return @source_mac_address
  end



  private

  def reset()
    @source_ip_address  = nil
    @source_mac_address = nil
    @dest_ip_address    = nil
    @dest_mac_address   = nil
  end

end

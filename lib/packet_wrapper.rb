

class PacketWrapper


  def initialize()
    reset
  end



  def parse_packet(packet_in)
    reset
    data = packet_in.data

    @in_port  = packet_in.in_port
    @packet_class = packet_in.data.class


    # ARPブロック
    #if defined? packet_in.data.target_protocol_address
      puts "abc -> #{packet_in.data.respond_to?(:target_protocol_address)}"
    #end

    # IPブロック
    if defined? data.ip_protocol
      @ip_protocol = data.ip_protocol
    end

    if defined? data.source_mac
      @source_mac_address = data.source_mac
    end
    if defined? data.source_ip_address
      @source_ip_address = data.source_ip_address
    end
    if defined? data.transport_source_port
      @source_port = data.transport_source_port
    end

    if defined? data.destination_mac
      @dest_mac = data.destination_mac
    end
    if defined? data.destination_ip_address
      @dest_ip_address = data.destination_ip_address
    end
    if defined? data.transport_destination_port
      @dest_port = data.transport_destination_port
    end

    return self
  end



  def show()
    puts "[#{@in_port}](#{@packet_class.name} #{parse_ip_protocol(@ip_protocol)}): " +
      "#{@source_mac_address}(#{@source_ip_address}:#{@source_port}) -> " +
      "#{@dest_mac_address}(#{@dest_ip_address}:#{@dest_port})"
  end

  def get_source_ip()
    return @source_ip_address
  end

  def get_source_mac()
    return @source_mac_address
  end



  private

  def reset()
    @in_port            = nil
    @packet_class       = nil
    @ip_protocol        = nil

    @source_ip_address  = nil
    @source_mac_address = nil
    @source_port        = nil
    @dest_ip_address    = nil
    @dest_mac_address   = nil
    @dest_port          = nil
  end




  def parse_ip_protocol(pid)
    if pid == 1 then
      return "ICMP"
    elsif pid == 6 then
      return "TCP"
    elsif pid == 17 then
      return "UDP"
    end

    return pid
  end





end

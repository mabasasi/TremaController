require 'ipaddr'
require 'pio'

class NetworkTable
  # IANA勧告
  MASQ_PORT_RANGE = 49152..65535

  include Pio


  class NetworkEntity
    attr_reader :ip_address    #IPAddr     端末のIPアドレス＋ネットマスク
    attr_reader :mac_address   #PIO::MAC   端末のMACアドレス
    attr_reader :exist_port    #int        端末が存在するスイッチの物理ポート
    attr_reader :masq_port     #int        NAPT使用時のIP論理ポート

    attr_reader :use_count     #int        使用回数
    attr_reader :add_time      #unixTime   追加時間
    attr_reader :last_use_time #unixTime   最終使用時間
    attr_reader :traffic_ssize  #int        通信量

    def initialize(in_port, ip_address, mac_address)
      @ip_address = ip_address
      @mac_address = mac_address
      @exist_port  = in_port
      @masq_port   = -1

      @use_count     = 0
      @add_time      = Time.now
      @last_use_time = Time.now
      @traffic_size  = 0
    end

    def update(length)
      @use_count +=1
      @last_use_time = Time.now
      @traffic_size += length
    end

    def add_masquerade_port(port)
      @masq_port = port
    end

    def to_s
      return "#{@ip_address}(#{@mac_address})[#{@exist_port}->#{@masq_port}] | count:#{@use_count} use:#{(@last_use_time-@add_time)} size:#{@traffic_size} | st:#{@add_time} ed:#{@last_use_time}"
    end
  end

  class InterfaceEntity
    attr_reader :ip_address   #IPAddr     GWのIPアドレス
    attr_reader :mac_address  #PIO::MAC   GWのMACアドレス
    attr_reader :nw_address   #int        ネットワークアドレス

    def initialize(ip_address, mac_address, nw_address)
      @ip_address  = ip_address
      @mac_address = mac_address
      @nw_address  = nw_address
    end

  end

#===============================================================================


  def initialize()
    @random = Random.new

    @itf = {}
    @itf[1] = InterfaceEntity.new(IPAddr.new("172.16.0.2/32"),    Mac.new("01:01:01:01:01:01"), IPAddr.new("172.16.0.0/24"))
    @itf[2] = InterfaceEntity.new(IPAddr.new("192.168.100.1/32"), Mac.new("02:02:02:02:02:02"), IPAddr.new("192.168.100.0/24"))
    @itf[3] = InterfaceEntity.new(IPAddr.new("192.168.200.1/32"), Mac.new("03:03:03:03:03:03"), IPAddr.new("192.168.200.0/24"))
    @dgw = 1

    @table = []
  end

  # 自身が保持しているインターフェースかどうか
  def own_interface_address?(ip_address)
    @table.each{|value|
      return true if value.ip_address.include?(ip_address)
    }
    return false
  end

  # 自身が知っているネットワークアドレスかどうか
  def own_network_address?(in_port, ip_address)
    #自分自身のネットワークの場合
    return @itf[in_port] if (@itf[in_port].nw_address.include?(ip_address))

    #スイッチが知っているネットワークアドレスかどうか
    @itf.each{|key, value|
      return value if (value.nw_address.include?(ip_address))
    }

    #それ以外の場合は、DGWに転送
    return @itf[@dgw]
  end





  # インターフェースのmacアドレスを返却する
  def fetch_interface_mac_address(in_port, target_protocol_address)
    return unless @itf[in_port].ip_address == target_protocol_address
    return @itf[in_port].mac_address
  end



  # テーブル更新
  def update(in_port, ip_address, mac_address, length)
    nw = fetch_table(in_port, ip_address, mac_address)
    nw.update(length)
  end


  def dump()
    if (@table.size == 0)
      puts ">>network table empty."
      return
    end

    puts ">>network table"
    @table.each{|value|
      puts "#{value}"
    }
  end


#===============================================================================
private

  def generate_masq_port
    # ポート番号抽選
    pp = @random.rand(NetworkTable::MASQ_PORT_RANGE)
    puts "  generate port num. generate=#{pp}"

    # 使われているか確認
    @table.each{|value|
      return generate_masq_port if value.masq_port == pp
    }

    puts "confirm."
    return pp;
  end


  def fetch_table(in_port, ip_address, mac_address)
    # 存在するなら返却
    @table.each{|value|
      return value if value.exist_port == in_port and value.ip_address == ip_address and value.mac_address == mac_address
    }

    #ないなら末尾に追加して返却
    puts "create new record in network table"
    nw = NetworkEntity.new(in_port, ip_address, mac_address)
    nw.add_masquerade_port(generate_masq_port)
    @table.push nw
    return nw
  end





end

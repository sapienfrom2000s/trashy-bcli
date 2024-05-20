class Peer
  attr_reader :ip, :port, :peer_data, :conn

  def initialize(peer_data)
    @peer_data = peer_data
    @ip = "#{peer_data[0]}.#{peer_data[1]}.#{peer_data[2]}.#{peer_data[3]}"
    @port = peer_data[4] * 256 + peer_data[5]
    @available = false
  end

  def is_available?
    @available
  end

  def handshake
    hexdigest = Digest::SHA1.hexdigest BEncode.dump $metainfo.metadata['info']
    info_hash = [hexdigest].pack('H*')

    handshake_message = "\x13BitTorrent protocol\x00\x00\x00\x00\x00\x00\x00\x00#{info_hash}#{Client::ID}"
    begin
      Timeout.timeout(1.5) do
        @conn = TCPSocket.new(ip, port)
        @conn.puts handshake_message
        puts @conn.recv(1024)
        @available = true
      end
    rescue
      puts "Handshake failed for #{ip}:#{port}".colorize(:blue)
      @conn.close if @conn
    end
  end
end

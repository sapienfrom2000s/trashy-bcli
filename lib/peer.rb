class Peer
  attr_reader :ip, :port, :peer_data

  def initialize(peer_data)
    @peer_data = peer_data
    @ip = "#{peer_data[0]}.#{peer_data[1]}.#{peer_data[2]}.#{peer_data[3]}"
    @port = peer_data[4] * 256 + peer_data[5] 
  end

  def handshake
    hexdigest = Digest::SHA1.hexdigest BEncode.dump $metainfo.metadata['info'] 
    info_hash = [ hexdigest ].pack('H*')

    handshake_message = "\x13BitTorrent protocol\x00\x00\x00\x00\x00\x00\x00\x00#{info_hash}#{Client::ID}"
    begin
      Timeout::timeout(3) do
        TCPSocket.open(ip, port) do |s|
          s.send str
          s.recv(1024)
          p s.read
        end
      end
    rescue
      puts "Handshake failed for #{ip}:#{port}".colorize(:blue)
    end
  end
end

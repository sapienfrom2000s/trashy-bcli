require 'bencode'
require 'rest-client'
require 'cgi/escape'
require 'securerandom'
require 'digest/sha1'
require 'faraday'
require 'socket'
require 'timeout'

parsed_torrent_file = BEncode.load File.read('data.torrent')
url = parsed_torrent_file['announce-list'][0]

info_hash = Digest::SHA1.hexdigest BEncode.dump parsed_torrent_file['info'] 
info_hash = [ info_hash ].pack('H*')

peer_id = SecureRandom.alphanumeric(20)
port = 6881
uploaded = 0
downloaded = 0
left = parsed_torrent_file['info']['files'][0]['length']
compact = 1

params = {info_hash: info_hash, peer_id: , port: , uploaded: ,downloaded: , left: left, compact: }

res = Faraday.get('http://tracker.opentrackr.org:1337/announce', params)

peer_data = BEncode.load(res.body)['peers']

def build_handshake(info_hash, peer_id)
"\x13BitTorrent protocol\x00\x00\x00\x00\x00\x00\x00\x00#{info_hash}#{peer_id}"
end

arr = []

peer_data.bytes.each_slice(6) do |ip_data|
 ip = "#{ip_data[0]}.#{ip_data[1]}.#{ip_data[2]}.#{ip_data[3]}"
 port = ip_data[4] * 256 + ip_data[5]
 puts "Trying to connect to #{ip} #{port}"
 begin
   Timeout::timeout(1.5) do 
     client = TCPSocket.new(ip, port)
     client.puts(build_handshake(info_hash, peer_id))
     puts 'message sent'
     response = client.recv(1024)
     puts "Response from tracker: #{response}"
     arr << response
   end
 rescue
   puts "Handshake failed"
 end
end


binding.irb
# nyasaa


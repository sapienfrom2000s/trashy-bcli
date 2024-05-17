class BaseService
  def bencode_parse(data)
    BEncode.load(data)
  rescue Bencode::DecodeError => e
    puts e.colorize(:red)
    nil
  end
end

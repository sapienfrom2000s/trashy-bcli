require 'bencode'

class MetaInfo
  def initialize(file_path)
    @file_path = file_path
    @metadata = parse_torrent_file(file_path)
  end

  def trackers
    @metadata['announce-list']
  end

  private

  def parse_torrent_file(path)
    return unless path
    BEncode.load_file(File.expand_path(path))
  rescue BEncode::DecodeError => e
    raise e
  # no file is present at given path
  rescue StandardError => e
    raise e
  end
end

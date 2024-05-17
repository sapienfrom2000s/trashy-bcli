class Trackers
  attr_reader :metainfo, :list

  def initialize(metainfo)
    @metainfo = metainfo
    @list = { http: [], udp: [] }
    @metainfo.metadata['announce-list'].flatten.each do |tracker|
      @list[:udp] << tracker if tracker.start_with?('udp')
      @list[:http] << HTTPTracker.new(tracker, metainfo) if tracker.start_with?('http')
    end
  end

  def update_peer_list(peers)
    # iterate n trackers in phases(k at a time, k < n)
    # k threads at a time, wait for all 5 to finish and then go to next batch
    list[:http].each_slice(5) do |tracker_batch|
      parallel_request_for_peers(tracker_batch, peers)
    end
  end

  def parallel_request_for_peers(trackers, peers)
    mutex = Mutex.new
    arr = []
    trackers.each do |tracker|
      arr << Thread.new do
        res = begin
          Timeout.timeout(4) { tracker.request_peers }
        rescue StandardError => e
          puts e.to_s.colorize(:blue)
          puts "Timeout for #{tracker.source}".colorize(:blue)
          []
        end
        res.each do |peer_data|
          mutex.synchronize do
            peers.push(peer_data) # unless peers.include?(peer_data)
          end
        end
      end
    end
    arr.each(&:join)
  end
end

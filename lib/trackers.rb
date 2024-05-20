class Trackers
  attr_reader :list, :peers

  def initialize(peers)
    @peers = peers
    @list = { http: [], udp: [] }
    external_trackers = YAML.load_file('config/external_trackers.yaml')
    ($metainfo.metadata['announce-list'] + external_trackers['http']).flatten.each do |tracker|
      @list[:udp] << tracker if tracker.start_with?('udp')
      @list[:http] << HTTPTracker.new(tracker) if tracker.start_with?('http')
    end
  end

  def update_peer_list
    # iterate n trackers in phases(k at a time, k < n)
    # k threads at a time, wait for all 5 to finish and then go to next batch
    list[:http].each_slice(5) do |tracker_batch|
      parallel_request_for_peers(tracker_batch)
    end
  end

  def parallel_request_for_peers(trackers)
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
            peers.add(peer_data) unless peers.peer_present?(peer_data)
          end
        end
      end
    end
    arr.each(&:join)
  end
end

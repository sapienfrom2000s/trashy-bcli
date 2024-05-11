class Tracker
  attr_reader :source, :metainfo

  def initialize(source, metainfo)
    @source = source
    @metainfo = metainfo
  end

  def self.update_peer_list(http_trackers, peers)
    # iterate n trackers in phases(k at a time, k < n)
    # k threads at a time, wait for all 5 to finish and then go to next batch
    mutex = Mutex.new
    http_trackers.each_slice(5) do |tracker_batch|
      tracker_batch.each do |tracker|
        arr = []
        arr << Thread.new do
          res = begin
            Timeout::timeout(3){ tracker.peers }
          rescue StandardError => exception
            $logger.info "Unable to fetch peers from #{tracker.source}" 
            []
          end
          $logger.info "Fetched peers from #{tracker} #{res}" 
          res.each do |peer_data|
            mutex.synchronize do
              peers.push(peer_data) # unless peers.include?(peer_data)
            end
          end
        end
        arr.each(&:join)
      end
    end
  end
end

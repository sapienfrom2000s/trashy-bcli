require 'rest-client'

class HTTPTracker < Tracker
  def peers
    res = RestClient.get(tracker)
    res.body
  rescue
    log.info("Unable to fetch peers from #{tracker}")
    nil
  end

  # Is this responsibility of Tracker or should we move to Peer class
  def peer_active?(address)
  end
end

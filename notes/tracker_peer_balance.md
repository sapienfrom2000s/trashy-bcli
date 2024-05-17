A Queue(@trackers = Queue.new) to keep track of peers.

Spawn 10 threads to fetch peers. Insert the peer to queue if
it was not already there. Rerequest for peers every 3 minutes.


Try handshakes with all peers. Stop if you have optimal peers(30).
(spawn 10 threads for it(let's see))
Start asking for pieces.


1. Need peers. A point to hit to get peers. Basically a tracker class.
   We know that torrent-file contains announce-list, most modern torrent
   files do. Having 25 peers in pipeline is good. Keep track of pointer
   in trackers array so that if new peers are needed you can ask new trackers
   instead of the old one. Well, we can also do multithreading, ask all trackers
   at once and terminate once we get 25 unique peers. But that's for later.

2. From trackers we can get list of only potential peers. Only when
   handshake is complete you know that peer is available and potentially
   be interested in communicating.

---

What do we have till now?

A Tracker class. A Peer class. We can have `peer = Peer.new(address)`,
we get the instance. We can have an `#active?` which returns true when
handshake was successful. Create 2 tracker classes one is HTTPTracker
and second is UDPTracker. We should have a Torrent class as well to parse
torrent files. From peer instance we should also be able piece.

Okay, we have the torrent, trackers, peers, active peers.

---

3. Download pieces. Have a download class. We can get only 16 kb block at
   a time. Have the instance know which pieces it has and which pieces it
   doesn't. For now, since we are interacting with one peer. From pool of
   not-available pieces ask for 1. Then for another. Man, it will be
   terribly slow. Yeah, that's it. Let's build it.

import Foundation

class FSWatcher {
  struct Event {
    var path: String
    var flags: FSEventStreamEventFlags
    var id: FSEventStreamEventId
  }
  
  struct CreateFlags: OptionSet {
    let rawValue: FSEventStreamCreateFlags
    
    static let noDefer = CreateFlags(rawValue: FSEventStreamCreateFlags(kFSEventStreamCreateFlagNoDefer))
    static let watchRoot = CreateFlags(rawValue: FSEventStreamCreateFlags(kFSEventStreamCreateFlagWatchRoot))
    static let ignoreSelf = CreateFlags(rawValue: FSEventStreamCreateFlags(kFSEventStreamCreateFlagIgnoreSelf))
    static let fileEvents = CreateFlags(rawValue: FSEventStreamCreateFlags(kFSEventStreamCreateFlagFileEvents))
    static let markSelf = CreateFlags(rawValue: FSEventStreamCreateFlags(kFSEventStreamCreateFlagMarkSelf))
  }
  
  private var stream: FSEventStreamRef!
  private let queue = DispatchQueue(label: "FSWatcher queue")
  private let cb: ([Event]) -> ()
  
  init(paths: [String], latency: CFTimeInterval, cb: @escaping ([Event]) -> (), since: FSEventStreamEventId = FSEventStreamEventId(kFSEventStreamEventIdSinceNow), flags: CreateFlags = []) {
    self.cb = cb
    var context = FSEventStreamContext(
      version: 0,
      info: Unmanaged.passUnretained(self).toOpaque(),
      retain: nil,
      release: nil,
      copyDescription: nil
    )
    stream = FSEventStreamCreate(nil, { eventStream, info, numEvents, eventPathsC, eventFlagsC, eventIdsC in
      let eventPaths = Unmanaged<NSArray>.fromOpaque(eventPathsC).takeUnretainedValue() as! [String]
      let eventFlags = Array(UnsafeBufferPointer(start: eventFlagsC!, count: numEvents))
      let eventIds = Array(UnsafeBufferPointer(start: eventIdsC!, count: numEvents))
      
      let watcher = Unmanaged<FSWatcher>.fromOpaque(info!).takeUnretainedValue()
      watcher.cb(eventPaths.enumerated().map { Event(path: $1, flags: eventFlags[$0], id: eventIds[$0]) })
    }, &context, paths as CFArray, since, latency, flags.rawValue | FSEventStreamCreateFlags(kFSEventStreamCreateFlagUseCFTypes))!
    
    FSEventStreamSetDispatchQueue(stream, queue)
    FSEventStreamStart(stream)
  }
  
  deinit {
    FSEventStreamStop(stream)
    FSEventStreamRelease(stream)
  }
}

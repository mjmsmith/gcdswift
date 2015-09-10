import Foundation

public class GCDGroup {
 /**
  *  Returns the underlying dispatch group object.
  *
  *  - returns: The dispatch group object.
  */
  public let dispatchGroup: dispatch_group_t
  
  // MARK: Lifecycle
  
 /**
  *  Initializes a new group.
  *
  *  - returns: The initialized instance.
  *  - SeeAlso: dispatch_group_create()
  */
  public convenience init() {
    self.init(dispatchGroup: dispatch_group_create())
  }
  
 /**
  *  The GCDGroup designated initializer.
  *
  *  - parameter dispatchGroup: A dispatch_group_t object.
  *  - returns: The initialized instance.
  */
  public init(dispatchGroup: dispatch_group_t) {
    self.dispatchGroup = dispatchGroup
  }
  
  // MARK: Public methods
  
 /**
  *  Explicitly indicates that a block has entered the group.
  *
  *  - SeeAlso: dispatch_group_enter()
  */
  public func enter() {
    return dispatch_group_enter(self.dispatchGroup)
  }

 /**
  *  Explicitly indicates that a block in the group has completed.
  *
  *  - SeeAlso: dispatch_group_leave()
  */
  public func leave() {
    return dispatch_group_leave(self.dispatchGroup)
  }

 /**
  *  Waits forever for the previously submitted blocks in the group to complete.
  *
  *  - SeeAlso: dispatch_group_wait()
  */
  public func wait() {
    dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER)
  }
  
/**
  *  Waits for the previously submitted blocks in the group to complete.
  *
  *  - parameter seconds: The time to wait in seconds.
  *  - returns: `true` if all blocks completed, `false` if the timeout occurred.
  *  - SeeAlso: dispatch_group_wait()
  */
  public func wait(seconds: Double) -> Bool {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(GCDConstants.NanosecondsPerSecond)))
    
    return dispatch_group_wait(self.dispatchGroup, time) == 0
  }
}

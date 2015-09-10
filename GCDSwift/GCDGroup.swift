import Foundation

public class GCDGroup {
  public let dispatchGroup: dispatch_group_t
  
  // MARK: Lifecycle
  
  public convenience init() {
    self.init(dispatchGroup: dispatch_group_create())
  }
  
  public init(dispatchGroup: dispatch_group_t) {
    self.dispatchGroup = dispatchGroup
  }
  
  // MARK: Public methods
  
  public func enter() {
    return dispatch_group_enter(self.dispatchGroup)
  }

  public func leave() {
    return dispatch_group_leave(self.dispatchGroup)
  }

  public func wait() {
    dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER)
  }
  
  public func wait(seconds: Double) -> Bool {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(GCDConstants.NanosecondsPerSecond)))
    
    return dispatch_group_wait(self.dispatchGroup, time) == 0
  }
}

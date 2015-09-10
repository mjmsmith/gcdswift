import Foundation

public class GCDSemaphore {
  public let dispatchSemaphore: dispatch_semaphore_t

  // MARK: Lifecycle
  
  public convenience init() {
    self.init(value: 0)
  }

  public convenience init(value: CLong) {
    self.init(dispatchSemaphore: dispatch_semaphore_create(value))
  }

  public init(dispatchSemaphore: dispatch_semaphore_t) {
    self.dispatchSemaphore = dispatchSemaphore
  }

  // MARK: Public methods
  
  public func signal() -> Bool {
    return dispatch_semaphore_signal(self.dispatchSemaphore) != 0
  }

  public func wait() {
    dispatch_semaphore_wait(self.dispatchSemaphore, DISPATCH_TIME_FOREVER)
  }
  
  public func wait(seconds: Double) -> Bool {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(GCDConstants.NanosecondsPerSecond)))
    
    return dispatch_semaphore_wait(self.dispatchSemaphore, time) == 0
  }
}
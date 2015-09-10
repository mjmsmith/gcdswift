import Foundation

public class GCDQueue {
  public let dispatchQueue: dispatch_queue_t
  
  // MARK: Global queue accessors
  
  public class var mainQueue: GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_get_main_queue())
  }

  public class var globalQueue: GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
  }

  public class var highPriorityGlobalQueue: GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))
  }

  public class var lowPriorityGlobalQueue: GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0))
  }

  public class var backgroundPriorityGlobalQueue: GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
  }
  
  // MARK: Lifecycle
  
  public class func serialQueue() -> GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_queue_create("", DISPATCH_QUEUE_SERIAL))
  }
  
  public class func concurrentQueue() -> GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT))
  }
  
  public convenience init() {
    self.init(dispatchQueue: dispatch_queue_create("", DISPATCH_QUEUE_SERIAL))
  }
  
  public init(dispatchQueue: dispatch_queue_t) {
    self.dispatchQueue = dispatchQueue
  }
  
  // MARK: Public block methods
  
  public func queueBlock(block: dispatch_block_t) {
    dispatch_async(self.dispatchQueue, block)
  }
  
  public func queueBlock(block: dispatch_block_t, afterDelay seconds: Double) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(GCDConstants.NanosecondsPerSecond)))
    
    dispatch_after(time, self.dispatchQueue, block)
  }
  
  public func queueAndAwaitBlock(block: dispatch_block_t) {
    dispatch_sync(self.dispatchQueue, block)
  }
  
  public func queueAndAwaitBlock(block: ((Int) -> Void), iterationCount count: Int) {
    dispatch_apply(count, self.dispatchQueue, block)
  }
  
  public func queueBlock(block: dispatch_block_t, inGroup group: GCDGroup) {
    dispatch_group_async(group.dispatchGroup, self.dispatchQueue, block)
  }
  
  public func queueNotifyBlock(block: dispatch_block_t, inGroup group: GCDGroup) {
    dispatch_group_notify(group.dispatchGroup, self.dispatchQueue, block)
  }
  
  public func queueBarrierBlock(block: dispatch_block_t) {
    dispatch_barrier_async(self.dispatchQueue, block)
  }
  
  public func queueAndAwaitBarrierBlock(block: dispatch_block_t) {
    dispatch_barrier_sync(self.dispatchQueue, block)
  }
  
  // MARK: Misc public methods
  
  public func suspend() {
    dispatch_suspend(self.dispatchQueue)
  }
  
  public func resume() {
    dispatch_resume(self.dispatchQueue)
  }
}

import Foundation

public class GCDQueue {
 /**
  *  Returns the underlying dispatch queue object.
  *
  *  - returns: The dispatch queue object.
  */
  public let dispatchQueue: dispatch_queue_t
  
  // MARK: Global queue accessors
  
 /**
  *  Returns the serial dispatch queue associated with the application’s main thread.
  *
  *  - returns: The main queue. This queue is created automatically on behalf of the main thread before main is called.
  *
  *  - SeeAlso: dispatch_get_main_queue()
  */
  public class var mainQueue: GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_get_main_queue())
  }

 /**
  *  Returns the default priority global concurrent queue.
  *
  *  - returns: The queue.
  *  - SeeAlso: dispatch_get_global_queue()
  */
  public class var globalQueue: GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
  }

 /**
  *  Returns the high priority global concurrent queue.
  *
  *  - returns: The queue.
  *  - SeeAlso: dispatch_get_global_queue()
  */
  public class var highPriorityGlobalQueue: GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))
  }

 /**
  *  Returns the low priority global concurrent queue.
  *
  *  - returns: The queue.
  *  - SeeAlso: dispatch_get_global_queue()
  */
  public class var lowPriorityGlobalQueue: GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0))
  }

 /**
  *  Returns the background priority global concurrent queue.
  *
  *  - returns: The queue.
  *  - SeeAlso: dispatch_get_global_queue()
  */
  public class var backgroundPriorityGlobalQueue: GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
  }
  
  // MARK: Lifecycle
  
 /**
  *  Initializes a new serial queue.
  *
  *  - returns: The initialized instance.
  *  - SeeAlso: dispatch_queue_create()
  */
  public class func serialQueue() -> GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_queue_create("", DISPATCH_QUEUE_SERIAL))
  }
  
 /**
  *  Initializes a new concurrent queue.
  *
  *  - returns: The initialized instance.
  *  - SeeAlso: dispatch_queue_create()
  */
  public class func concurrentQueue() -> GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT))
  }
  
 /**
  *  Initializes a new serial queue.
  *
  *  - returns: The initialized instance.
  *  - SeeAlso: dispatch_queue_create()
  */
  public convenience init() {
    self.init(dispatchQueue: dispatch_queue_create("", DISPATCH_QUEUE_SERIAL))
  }
  
 /**
  *  The GCDQueue designated initializer.
  *
  *  - parameter dispatchQueue: dispatch_queue_t object.
  *  - returns: The initialized instance.
  */
  public init(dispatchQueue: dispatch_queue_t) {
    self.dispatchQueue = dispatchQueue
  }
  
  // MARK: Public block methods
  
 /**
  *  Submits a block for asynchronous execution on the queue.
  *
  *  - parameter block: The block to submit.
  *
  *  - SeeAlso: dispatch_async()
  */
  public func queueBlock(block: dispatch_block_t) {
    dispatch_async(self.dispatchQueue, block)
  }
  
 /**
  *  Submits a block for asynchronous execution on the queue after a delay.
  *
  *  - parameter block: The block to submit.
  *  - parameter afterDelay: The delay in seconds.
  *  - SeeAlso: dispatch_after()
  */
  public func queueBlock(block: dispatch_block_t, afterDelay seconds: Double) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(GCDConstants.NanosecondsPerSecond)))
    
    dispatch_after(time, self.dispatchQueue, block)
  }
  
 /**
  *  Submits a block for execution on the queue and waits until it completes.
  *
  *  - parameter block: The block to submit.
  *  - SeeAlso: dispatch_sync()
  */
  public func queueAndAwaitBlock(block: dispatch_block_t) {
    dispatch_sync(self.dispatchQueue, block)
  }
  
 /**
  *  Submits a block for execution on the queue multiple times and waits until all executions complete.
  *
  *  - parameter block: The block to submit.
  *  - parameter iterationCount: The number of times to execute the block.
  *  - SeeAlso: dispatch_apply()
  */
  public func queueAndAwaitBlock(block: ((Int) -> Void), iterationCount count: Int) {
    dispatch_apply(count, self.dispatchQueue, block)
  }
  
 /**
  *  Submits a block for asynchronous execution on the queue and associates it with the group.
  *
  *  - parameter block: The block to submit.
  *  - parameter inGroup: The group to associate the block with.
  *  - SeeAlso: dispatch_group_async()
  */
  public func queueBlock(block: dispatch_block_t, inGroup group: GCDGroup) {
    dispatch_group_async(group.dispatchGroup, self.dispatchQueue, block)
  }
 
 /**
  *  Schedules a block to be submitted to the queue when a group of previously submitted blocks have completed.
  *
  *  - parameter block: The block to submit when the group completes.
  *  - parameter inGroup: The group to observe.
  *  - SeeAlso: dispatch_group_notify()
  */
  public func queueNotifyBlock(block: dispatch_block_t, inGroup group: GCDGroup) {
    dispatch_group_notify(group.dispatchGroup, self.dispatchQueue, block)
  }
  
 /**
  *  Submits a barrier block for asynchronous execution on the queue.
  *
  *  - parameter block: The barrier block to submit.
  *  - SeeAlso dispatch_barrier_async()
  */
  public func queueBarrierBlock(block: dispatch_block_t) {
    dispatch_barrier_async(self.dispatchQueue, block)
  }
  
 /**
  *  Submits a barrier block for execution on the queue and waits until it completes.
  *
  *  - parameter block: The barrier block to submit.
  *  - SeeAlso: dispatch_barrier_sync()
  */
  public func queueAndAwaitBarrierBlock(block: dispatch_block_t) {
    dispatch_barrier_sync(self.dispatchQueue, block)
  }
  
  // MARK: Misc public methods
  
 /**
  *  Suspends execution of blocks on the queue.
  *
  *  - SeeAlso: dispatch_suspend()
  */
  public func suspend() {
    dispatch_suspend(self.dispatchQueue)
  }
  
 /**
  *  Resumes execution of blocks on the queue.
  *
  *  - SeeAlso: dispatch_resume()
  */
  public func resume() {
    dispatch_resume(self.dispatchQueue)
  }
}

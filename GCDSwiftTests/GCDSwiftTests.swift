import XCTest
import GCDSwift

class GCDSwiftTests: XCTestCase {

  func testMainQueue() {
    XCTAssertTrue(GCDQueue.mainQueue.dispatchQueue === dispatch_get_main_queue())
  }

  func testGlobalQueues() {
    XCTAssertTrue(GCDQueue.globalQueue.dispatchQueue === dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
    XCTAssertTrue(GCDQueue.highPriorityGlobalQueue.dispatchQueue === dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))
    XCTAssertTrue(GCDQueue.lowPriorityGlobalQueue.dispatchQueue === dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0))
    XCTAssertTrue(GCDQueue.backgroundPriorityGlobalQueue.dispatchQueue === dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
  }
  
  func testQueueBlock() {
    let semaphore = GCDSemaphore()
    let queue = GCDQueue()
    var val = 0
  
    queue.queueBlock({
      val += 1
      semaphore.signal()
    })
  
    semaphore.wait()
    XCTAssertEqual(val, 1)
  }
  
  func testQueueBlockAfterDelay() {
    let semaphore = GCDSemaphore()
    let queue = GCDQueue()
    let then = NSDate()
    var val = 0
  
    queue.queueBlock({
      val += 1
      semaphore.signal()
    }, afterDelay: 0.5)
  
    XCTAssertEqual(val, 0)
    semaphore.wait()
    XCTAssertEqual(val, 1)
    
    let now = NSDate()
    XCTAssertTrue(now.timeIntervalSinceDate(then) > 0.4 && now.timeIntervalSinceDate(then) < 0.6)
  }
  
  func testQueueAndAwaitBlock() {
    let queue = GCDQueue()
    var val = 0
    
    queue.queueAndAwaitBlock({
      val += 1
    })
    
    XCTAssertEqual(val, 1)
  }
  
  func testQueueAndAwaitBlockIterationCount() {
    let queue = GCDQueue.concurrentQueue()
    var val: Int32 = 0
    
    queue.queueAndAwaitBlock({ _ in OSAtomicIncrement32(&val) }, iterationCount: 100)

    XCTAssertEqual(val, 100)
  }

  func testQueueBlockInGroup() {
    let queue = GCDQueue.concurrentQueue()
    let group = GCDGroup()
    var val: Int32 = 0
    
    for (var i = 0; i < 100; ++i) {
      queue.queueBlock({ OSAtomicIncrement32(&val) }, inGroup: group)
    }
  
    group.wait()
    XCTAssertEqual(val, 100)
  }

  func testQueueNotifyBlockForGroup() {
    let queue = GCDQueue.concurrentQueue()
    let semaphore = GCDSemaphore()
    let group = GCDGroup()
    var val: Int32 = 0
    var notifyVal: Int32 = 0

    for (var i = 0; i < 100; ++i) {
      queue.queueBlock({ OSAtomicIncrement32(&val) }, inGroup: group)
    }
    
    queue.queueNotifyBlock({
      notifyVal = val
      semaphore.signal()
    }, inGroup: group);

    semaphore.wait()
    XCTAssertEqual(notifyVal, 100)
  }
  
  func testQueueBarrierBlock() {
    let queue = GCDQueue.concurrentQueue()
    let semaphore = GCDSemaphore()
    var val: Int32 = 0
    var barrierVal: Int32 = 0

    for (var i = 0; i < 100; ++i) {
      queue.queueBlock({ OSAtomicIncrement32(&val) })
    }
    queue.queueBarrierBlock({
      barrierVal = val
      semaphore.signal()
    })
    for (var i = 0; i < 100; ++i) {
      queue.queueBlock({ OSAtomicIncrement32(&val) })
    }

    semaphore.wait()
    XCTAssertEqual(barrierVal, 100)
  }

  func testQueueAndAwaitBarrierBlock() {
    let queue = GCDQueue.concurrentQueue()
    var val: Int32 = 0

    for (var i = 0; i < 100; ++i) {
      queue.queueBlock({ OSAtomicIncrement32(&val) })
    }
    queue.queueAndAwaitBarrierBlock({})
    XCTAssertEqual(val, 100)
  }
}

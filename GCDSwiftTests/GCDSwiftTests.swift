//
//  GCDSwiftTests.swift
//  GCDSwiftTests
//
//  Created by Mark Smith on 6/2/14.
//  Copyright (c) 2014 Camazotz Limited. All rights reserved.
//

import XCTest

class GCDSwiftTests: XCTestCase {

  func testMainQueue() {
    XCTAssertEqual(GCDQueue.mainQueue.dispatchQueue, dispatch_get_main_queue())
  }

  func testGlobalQueues() {
    XCTAssertEqual(GCDQueue.globalQueue.dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
    XCTAssertEqual(GCDQueue.highPriorityGlobalQueue.dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))
    XCTAssertEqual(GCDQueue.lowPriorityGlobalQueue.dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0))
    XCTAssertEqual(GCDQueue.backgroundPriorityGlobalQueue.dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
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
    XCTAssertTrue(now.timeIntervalSinceDate(then) > 0.4)
    XCTAssertTrue(now.timeIntervalSinceDate(then) < 0.6)
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
    let queue = GCDQueue.initConcurrent()
    var val: Int32 = 0
    let pVal: CMutablePointer = &val
    
    queue.queueAndAwaitBlock({ i in OSAtomicIncrement32(UnsafePointer<Int32>(pVal)); return }, iterationCount: 100)

    XCTAssertEqual(val, 100)
  }

  func testQueueBlockInGroup() {
    let queue = GCDQueue.initConcurrent()
    let group = GCDGroup()
    var val: Int32 = 0
    let pVal: CMutablePointer = &val
    
    for (var i = 0; i < 100; ++i) {
      queue.queueBlock({ OSAtomicIncrement32(UnsafePointer<Int32>(pVal)); return }, inGroup: group)
    }
  
    group.wait()
    XCTAssertEqual(val, 100)
  }

  func testQueueNotifyBlockForGroup() {
    let queue = GCDQueue.initConcurrent()
    let semaphore = GCDSemaphore()
    let group = GCDGroup()
    var val: Int32 = 0
    let pVal: CMutablePointer = &val
    var notifyVal: Int32 = 0

    for (var i = 0; i < 100; ++i) {
      queue.queueBlock({ OSAtomicIncrement32(UnsafePointer<Int32>(pVal)); return }, inGroup: group)
    }
    
    queue.queueNotifyBlock({
      notifyVal = val
      semaphore.signal()
    }, inGroup: group);

    semaphore.wait()
    XCTAssertEqual(notifyVal, 100)
  }
  
  func testQueueBarrierBlock() {
    let queue = GCDQueue.initConcurrent()
    let semaphore = GCDSemaphore()
    var val: Int32 = 0
    let pVal: CMutablePointer = &val
    var barrierVal: Int32 = 0

    for (var i = 0; i < 100; ++i) {
      queue.queueBlock({ OSAtomicIncrement32(UnsafePointer<Int32>(pVal)); return })
    }
    queue.queueBarrierBlock({
      barrierVal = val
      semaphore.signal()
    })
    for (var i = 0; i < 100; ++i) {
      queue.queueBlock({ OSAtomicIncrement32(UnsafePointer<Int32>(pVal)); return })
    }

    semaphore.wait()
    XCTAssertEqual(barrierVal, 100)
  }

  func testQueueAndAwaitBarrierBlock() {
    let queue = GCDQueue.initConcurrent()
    var val: Int32 = 0
    let pVal: CMutablePointer = &val

    for (var i = 0; i < 100; ++i) {
      queue.queueBlock({ OSAtomicIncrement32(UnsafePointer<Int32>(pVal)); return })
    }
    queue.queueAndAwaitBarrierBlock({})
    XCTAssertEqual(val, 100)
  }
}

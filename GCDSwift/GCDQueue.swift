//
//  GCDQueue.swift
//  GCDSwift
//
//  Created by Mark Smith on 6/2/14.
//  Copyright (c) 2014 Camazotz Limited. All rights reserved.
//

import Foundation

class GCDQueue {
  let dispatchQueue: dispatch_queue_t
  
  // Global queue accessors.
  
  class var mainQueue: GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_get_main_queue())
  }

  class var globalQueue: GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
  }

  class var highPriorityGlobalQueue: GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))
  }

  class var lowPriorityGlobalQueue: GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0))
  }

  class var backgroundPriorityGlobalQueue: GCDQueue {
  return GCDQueue(dispatchQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
  }
  
  // Lifecycle.
  
  class func initSerial() -> GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_queue_create("", DISPATCH_QUEUE_SERIAL))
  }
  
  class func initConcurrent() -> GCDQueue {
    return GCDQueue(dispatchQueue: dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT))
  }
  
  convenience init() {
    self.init(dispatchQueue: dispatch_queue_create("", DISPATCH_QUEUE_SERIAL))
  }
  
  init(dispatchQueue: dispatch_queue_t) {
    self.dispatchQueue = dispatchQueue
  }
  
  // Public block methods.
  
  func queueBlock(block: dispatch_block_t) {
    dispatch_async(self.dispatchQueue, block)
  }
  
  func queueBlock(block: dispatch_block_t, afterDelay seconds: Double) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NanosecondsPerSecond)))
    
    dispatch_after(time, self.dispatchQueue, block)
  }
  
  func queueAndAwaitBlock(block: dispatch_block_t) {
    dispatch_sync(self.dispatchQueue, block)
  }
  
  func queueAndAwaitBlock(block: ((UInt) -> Void), iterationCount count: UInt) {
    dispatch_apply(count, self.dispatchQueue, block)
  }
  
  func queueBlock(block: dispatch_block_t, inGroup group: GCDGroup) {
    dispatch_group_async(group.dispatchGroup, self.dispatchQueue, block)
  }
  
  func queueNotifyBlock(block: dispatch_block_t, inGroup group: GCDGroup) {
    dispatch_group_notify(group.dispatchGroup, self.dispatchQueue, block)
  }
  
  func queueBarrierBlock(block: dispatch_block_t) {
    dispatch_barrier_async(self.dispatchQueue, block)
  }
  
  func queueAndAwaitBarrierBlock(block: dispatch_block_t) {
    dispatch_barrier_sync(self.dispatchQueue, block)
  }
  
  // Misc public methods.
  
  func suspend() {
    dispatch_suspend(self.dispatchQueue)
  }
  
  func resume() {
    dispatch_resume(self.dispatchQueue)
  }
}

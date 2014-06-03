//
//  GCDSemaphore.swift
//  GCDSwift
//
//  Created by Mark Smith on 6/2/14.
//  Copyright (c) 2014 Camazotz Limited. All rights reserved.
//

import Foundation

class GCDSemaphore {
  let dispatchSemaphore: dispatch_semaphore_t

  // Lifecycle.
  
  convenience init() {
    self.init(value: 0)
  }

  convenience init(value: CLong) {
    self.init(dispatchSemaphore: dispatch_semaphore_create(value))
  }

  init(dispatchSemaphore: dispatch_semaphore_t) {
    self.dispatchSemaphore = dispatchSemaphore
  }

  // Public methods.
  
  func signal() -> Bool {
    return dispatch_semaphore_signal(self.dispatchSemaphore) != 0
  }

  func wait() {
    dispatch_semaphore_wait(self.dispatchSemaphore, DISPATCH_TIME_FOREVER)
  }
  
  func wait(seconds: Double) -> Bool {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NanosecondsPerSecond)))
    
    return dispatch_semaphore_wait(self.dispatchSemaphore, time) == 0
  }
}
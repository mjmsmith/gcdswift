//
//  GCDGroup.swift
//  GCDSwift
//
//  Created by Mark Smith on 6/2/14.
//  Copyright (c) 2014 Camazotz Limited. All rights reserved.
//

import Foundation

class GCDGroup {
  let dispatchGroup: dispatch_group_t
  
  // Lifecycle.
  
  convenience init() {
    self.init(dispatchGroup: dispatch_group_create())
  }
  
  init(dispatchGroup: dispatch_group_t) {
    self.dispatchGroup = dispatchGroup
  }
  
  // Public methods.
  
  func enter() {
    return dispatch_group_enter(self.dispatchGroup)
  }

  func leave() {
    return dispatch_group_leave(self.dispatchGroup)
  }

  func wait() {
    dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER)
  }
  
  func wait(seconds: Double) -> Bool {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NanosecondsPerSecond)))
    
    return dispatch_group_wait(self.dispatchGroup, time) == 0
  }
}

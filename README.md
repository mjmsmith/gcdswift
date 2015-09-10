# GCDSwift

GCDSwift is a Swift wrapper for the most commonly used features of Grand Central Dispatch.  It has four main aims:

* Organize the flat C API into appropriate classes.
* Use intention-revealing names to distinguish between synchronous and asynchronous functions. 
* Use more convenient arguments such as time intervals.
* Add convenience methods.

__GCDSwift__ defines the same API as [GCDObjC](https://github.com/mjmsmith/gcdobjc).

## Usage

__GCDSwift__ requires Swift 2.0.

For usage examples, see [GCDSwiftTests.m](https://github.com/mjmsmith/gcdswift/blob/master/GCDSwiftTests/GCDSwiftTests.m).

## GCDQueue

Queues are implemented in the __GCDQueue__ class.

* convenience accessors for global queues

```swift
class var mainQueue: GCDQueue { get }
class var globalQueue: GCDQueue { get }
class var highPriorityGlobalQueue: GCDQueue { get }
class var lowPriorityGlobalQueue: GCDQueue { get }
class var backgroundPriorityGlobalQueue: GCDQueue { get }
```

* creating serial and concurrent queues

```swift
class func serialQueue() -> GCDQueue
class func concurrentQueue() -> GCDQueue
```

* queueing blocks for asynchronous execution

```swift
func queueBlock(block: dispatch_block_t)
func queueBlock(block: dispatch_block_t, afterDelay seconds: Double)
func queueBlock(block: dispatch_block_t, inGroup group: GCDGroup)
```

* queueing blocks for synchronous execution

```swift
func queueAndAwaitBlock(block: dispatch_block_t)
func queueAndAwaitBlock(block: ((Int) -> Void), iterationCount count: Int)
```

* queueing barrier blocks for synchronous or asynchronous execution

```swift
func queueBarrierBlock(block: dispatch_block_t)
func queueAndAwaitBarrierBlock(block: dispatch_block_t)
```

* queueing notify blocks on groups

```swift
func queueNotifyBlock(block: dispatch_block_t, inGroup group: GCDGroup)
```

* suspending and resuming a queue

```objc
func suspend()
func resume()
```

## GCDSemaphore

Semaphores are implemented in the __GCDSemaphore__ class.

* creating semaphores

```swift
GCDSemaphore()
GCDSemaphore(value: CLong)
```

* signaling and waiting on a semaphore

```swift
func signal() -> Bool
func wait()
func wait(seconds: Double) -> Bool
```

## GCDGroup

Groups are implemented in the __GCDGroup__ class.

* creating groups

```swift
GCDGroup()
```

* entering and leaving a group

```swift
func enter()
func leave()
```

* waiting on completion of a group

```swift
func wait()
func wait(seconds: Double) -> Bool
```

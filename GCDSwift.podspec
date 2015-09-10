Pod::Spec.new do |s|
  s.name         = "GCDSwift"
  s.version      = "0.2.0"
  s.summary      = "Swift wrapper for Grand Central Dispatch."
  s.description  = <<-DESC
                      GCDSwift is a Swift wrapper for the most commonly used features of Grand Central Dispatch.
                      It has four main aims:

                      * Organize the flat C API into appropriate classes.
                      * Use intention-revealing names to distinguish between synchronous and asynchronous functions.
                      * Use more convenient arguments.
                      * Add convenience methods.
                   DESC
  s.homepage     = "https://github.com/mjmsmith/gcdswift"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Mark Smith" => "mark@camazotz.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/mjmsmith/gcdswift.git", :tag => "v#{s.version}" }
  s.source_files = "GCDSwift"
end

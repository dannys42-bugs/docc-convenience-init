// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A sample library
public class SomeLibrary {
    /// Intializer
    /// - Parameter string: Give me a string
    public init(string: String) {
        print("Initialized with string: '\(string)'")
    }
    
    /// Convenience intializer.
    ///
    /// Note: This initializer is really convient.  Please call me!
    public convenience init() {
        self.init(string: "Convience initializer")
    }
}

//
//  SynchronizedDictionary.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 13.11.2022.
//

import Foundation

public final class SynchronizedDictionary<Element> {
    private final let defaultQueue = DispatchQueue(
        label: "SynchronizedDictionary",
        qos: .userInitiated,
        attributes: .concurrent)
    
    private final let queue: DispatchQueue!
    private final var dict: [String: Element]!
    
    /**
     Initialize the dictionary with an option of passing a custom queue and/or an existing dictionary
     - Parameter queue: A custom queue to be used for the synchronization
     - Parameter dict: A dictionary to be used as the starting state
     */
    public init(queue: DispatchQueue? = nil, dict: [String: Element] = [String: Element]()) {
        self.queue = queue == nil ? defaultQueue : queue
        self.dict = dict
    }
}

// MARK: - Reads
public extension SynchronizedDictionary {
    
    /// Returns the number of elements in the dictionary
    func count() -> Int {
        var result = 0
        queue.sync {
            result = dict.count
        }
        return result
    }
    
    /// Reurns a boolean indicating if the dictionary is empty or not
    func isEmpty() -> Bool {
        var result = true
        queue.sync {
            result = dict.isEmpty
        }
        return result
    }
    
    /**
     Returns a boolean indicating if the dictionary contains the requested ***Key***
     - Parameter key: The key of the object to check
     */
    func containsKey(key: String) -> Bool {
        var result = false
        queue.sync {
            result = dict.keys.contains(key)
        }
        return result
    }
    
    /**
     Returns an optional element for the requested ***Key***
     - Parameter key: The key of the object to retrieve
     */
    func get(key: String) -> Element? {
        var result: Element?
        queue.sync {
            result = dict[key]
        }
        return result
    }
    
    /// Returns the complete dictionary
    func getAll() -> [String: Element] {
        var result: [String: Element]!
        queue.sync {
            result = dict
        }
        return result
    }
}

public extension SynchronizedDictionary where Element: Equatable {
    
    /// Reurns the Keyset of the dictionary
    func keys() -> Dictionary<String, Element>.Keys {
        var result: Dictionary<String, Element>.Keys!
        queue.sync {
            result = dict.keys
        }
        return result
    }
    
    /**
     Reurns a boolean indicating if the dictionary contains the requested ***Value***
     - Parameter value: The value of the object to check
     */
    func containsValue(value: Element) -> Bool {
        var result = false
        queue.sync {
            result = dict.values.contains(value)
        }
        return result
    }
    
    /// Returns the Valueset of the dictionary
    func values() -> Dictionary<String, Element>.Values {
        var result: Dictionary<String, Element>.Values!
        queue.sync {
            result = dict.values
        }
        return result
    }
    
    /**
     Returns the object for the requested ***Key*** if found
     Returns the ***Default Value*** if no object was found for the requested ***Key***
     - Parameter key: The key of the object to retrieve
     - Parameter defaultValue: Default value to return if no object was found for the requested ***Key***
     */
    func getOrDefault(key: String, defaultValue: Element) -> Element {
        var result: Element!
        queue.sync {
            result = dict[key] ?? defaultValue
        }
        return result
    }
    
    /// Reurns the label of the queue being used for synchronization
    func getQueueLabel() -> String {
        return queue.label
    }
    
}

// MARK: - Writes
public extension SynchronizedDictionary {
    
    /**
     Put the element if its not already in the dictionary or update its value if its present
     - Parameter key: The key of the object to insert/update
     - Parameter value: The value of the object to insert/update
     */
    func putOrUpdate(key: String, value: Element) {
        queue.async(flags: .barrier) {
            self.dict[key] = value
        }
    }
    
    /**
     Puts the element in the fictionary only if its missing
     - Parameter key: The key of the object to insert
     - Parameter value: The value of the object to insert
     */
    func putIfAbsent(key: String, value: Element) {
        queue.async(flags: .barrier) {
            if !self.dict.keys.contains(key) {
                self.dict[key] = value
            }
        }
    }
    
    /**
     Removes the element associated with the provided key
     - Parameter key: The key of the object to remove
     */
    func remove(key: String) -> Element? {
        var result: Element?
        queue.async(flags: .barrier) {
            result = self.dict.removeValue(forKey: key)
        }
        return result
    }
    
    /**
     It merges the current dictionary with the one provided
     - Parameter dict: The dictionary to be merged with the current one
     */
    func merge(dict: [String: Element]) {
        queue.async(flags: .barrier) {
            self.dict.merge(dict, uniquingKeysWith: { (_, new) in new })
        }
    }
    
    /// Removes all the objects in the dictionary
    func removeAll() {
        queue.async(flags: .barrier) {
            self.dict.removeAll()
        }
    }
}

// MARK: - LazyBox<>
enum LazyBox<T> {
    
    case instance(T)
    case recipe(() -> T)
    
    func get() -> T {
        switch self {
        case .instance(let instance):
            return instance
        case .recipe(let recipe):
            let inst = recipe()
            return inst
        }
    }
    
    mutating func unwrap() -> T {
        switch self {
        case .instance(let instance):
            return instance
        case .recipe(let recipe):
            let inst = recipe()
            self = .instance(inst)
            return inst
        }
    }
    
}

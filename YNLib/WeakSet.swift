//
//  Created by Adam Preble on 2/19/15.
//

/// Weak, unordered collection of objects.
public struct WeakSet<T where T: AnyObject, T: Hashable> {
    public typealias Element = T
    
    /// Maps Element hashValues to arrays of Entry objects.
    /// Invalid Entry instances are culled as a side effect of add() and remove()
    /// when they touch an object with the same hashValue.
    private var contents: [Int: [Entry<Element>]] = [:]
    
    public init(_ objects: T...) {
        self.init(objects)
    }
    
    public init(_ objects: [T]) {
        for object in objects {
            insert(object)
        }
    }
    
    /// Add an element to the set.
    public mutating func insert(newElement: Element) {
        var entriesAtHash = validEntriesAtHash(newElement.hashValue)
        var found = false
        for entry in entriesAtHash {
            if let existingElement = entry.element {
                if existingElement == newElement {
                    found = true
                    break
                }
            }
        }
        if found {
            return
        }
        let entry = Entry(element: newElement)
        entriesAtHash.append(entry)
        contents[newElement.hashValue] = entriesAtHash
    }
    
    /// Remove an element from the set.
    public mutating func remove(removeElement: Element) {
        let entriesAtHash = validEntriesAtHash(removeElement.hashValue)
        let entriesMinusElement = entriesAtHash.filter { $0.element != removeElement }
        if entriesMinusElement.isEmpty {
            contents[removeElement.hashValue] = nil
        }
        else {
            contents[removeElement.hashValue] = entriesMinusElement
        }
    }
    
    // Does the set contain this element?
    public func contains(element: Element) -> Bool {
        let entriesAtHash = validEntriesAtHash(element.hashValue)
        for entry in entriesAtHash {
            if entry.element == element {
                return true
            }
        }
        return false
    }
    
    private func validEntriesAtHash(hashValue: Int) -> [Entry<Element>] {
        if let entries = contents[hashValue] {
            return entries.filter {
                $0.element != nil
            }
        }
        else {
            return []
        }
    }
}

private struct Entry<T where T: AnyObject, T: Hashable> {
    typealias Element = T
    weak var element: Element?
}


// MARK: SequenceType

extension WeakSet : SequenceType {
    public typealias Generator = AnyGenerator<T>
    
    /// Creates a generator for the items of the set.
    public func generate() -> WeakSet.Generator {
        // This is not straightforward because we need to iterate over the arrays and then their contents.
        var contentsGenerator = contents.values.generate()         // generates arrays of entities
        var entryGenerator = contentsGenerator.next()?.generate()  // generates entries

        return AnyGenerator {
            // Note: If entryGenerator is nil, the party is over. No more.
            if let element = entryGenerator?.next()?.element {
                return element
            }
            else { // Ran out of entities in this array. Get the next one, if there is one.
                entryGenerator = contentsGenerator.next()?.generate()
                return entryGenerator?.next()?.element
            }
        }
    }

}
//: [Previous](@previous)

import Foundation

//MARK: Iterator design pattern
///In this design pattern any object can be converted to iterator and its inner implementation of how the collection
///is handled will be hidden from the outside world.


///In this example, we convert he Emojis struct to a sequence and the iteration can be directly done on the struct itself.
///To implement this in Swift, we implement the Sequence protocol to the Class/ Struct we want to iterate
struct Emojis: Sequence {
    private let emojis: [String]
    init(emojis: [String]) {
        self.emojis = emojis
    }
    
    ///Returns a IteratorProtocol that should be implemented to handle the iteration on Class/ Struct
    func makeIterator() -> some IteratorProtocol {
        return EmojiIterator(emojis)
    }
}

struct EmojiIterator: IteratorProtocol {
    private let values: [String]
    private var index: Int?
    
    init(_ values: [String]) {
        self.values = values
    }
    
    private func nextIndex(for index: Int?) -> Int? {
        if let index = index, index < self.values.count - 1 {
            return index + 1
        }
        if index == nil, !self.values.isEmpty {
            return 0
        }
        return nil
    }
    
    mutating func next() -> String? {
        if let index = self.nextIndex(for: self.index) {
            self.index = index
            return self.values[index]
        }
        return nil
    }
}

//let emojis = Emojis(emojis: ["🐶", "🐭", "🦁", "🙈", "🐣", "🦉", "🐴"])
//for emoji in emojis {
//    print("Emoji is \(emoji)")
//}

//_________________________________________________________

///Here, Favorites is a simple class that will be implementing the Collection Protocol and now we can access
///the Favorites as a collection
class Favorites {
    typealias FavoriteType = [String: [String]]
    private(set) var list: FavoriteType
    
    init(_ list: FavoriteType = FavoriteType()) {
        self.list = list
    }
}

extension Favorites: Collection {
    typealias Index = FavoriteType.Index
    typealias Element = FavoriteType.Element
    
    var startIndex: FavoriteType.Index {
        list.startIndex
    }
    
    var endIndex: FavoriteType.Index {
        list.endIndex
    }
    
    subscript(position: Index) -> Element {
        list[position]
    }
    
    func index(after i: Index) -> Index {
        list.index(after: i)
    }
}

extension Favorites {
    subscript(position: String) -> [String] {
        return self.list[position] ?? []
    }
    
    func add(_ value: String, category key: String) {
        if var values = list[key] {
            guard !values.contains(value) else {
                return
            }
            
            values.append(value)
            list[key] = values
        } else {
            list[key] = [value]
        }
    }
    
    func remove(_ value: String, category key: String) {
        guard var values = list[key] else {
            return
        }
        
        values = values.filter { $0 != value }
        if values.isEmpty {
            list.removeValue(forKey: key)
        } else {
            list[key] = values
        }
    }
    
    func remove(category key: String) {
        list.removeValue(forKey: key)
    }
}

var fav = Favorites([
    "animals": ["🐶", "🐭", "🦁", "🙈", "🐣", "🦉", "🐴"],
    "fruits": ["🍎", "🥭", "🍍", "🍓"]
])

for (key, value) in fav {
    print("\(key) - \(value)")
}

fav.add("🫐", category: "fruits")
for (key, value) in fav {
    print("\(key) - \(value)")
}

print("\(fav["animals"])")
print("\(fav.startIndex) - \(fav.endIndex)")
//: [Next](@next)

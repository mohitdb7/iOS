import Foundation
//MARK: - Object pool design pattern
///In this design pattern, the Pool class will hold some objects that it will dispatch based on request. The caller does instantiate the objects
///and the pool is the only provider. Best example of this was used in AVPlayer dispatch in DH, also FMP4 asset disatch is through object pool
class BooksPool {
    class Book {
        var name: String
        var author: String
        var index: Int
        
        init(name: String, author: String, index: Int) {
            self.name = name
            self.author = author
            self.index = index
        }
    }
    
    var books: [Book] = [
        Book(name: "ABC", author: "DEF", index: 1),
        Book(name: "ABC", author: "DEF", index: 2),
        Book(name: "ABC", author: "DEF", index: 3)
    ]
    
    func getBook() -> Book? {
        if books.count > 0 {
            let book = books.last
            books.removeLast()
            print("Book is issued!!!")
            return book
        }
        print("No books available!!!")
        return nil
    }
    
    func returnBook(_ book: Book) {
        books.append(book)
    }
}

var pool = BooksPool()
var book1 = pool.getBook()
var book2 = pool.getBook()
var book3 = pool.getBook()
var book4 = pool.getBook()

if let localBook = book1 {
    pool.returnBook(localBook)
    book1 = nil
}
if let localBook = book2 {
    pool.returnBook(localBook)
    book2 = nil
}
let book5 = pool.getBook()

import UIKit

var greeting = "Sukumar 😃😃😃😃😃😃😃😃 Hi"
var greeting2 = "Sukumar Hi"

func subString(line: String, start: Int, end: Int) -> String {
    let newLine = line as NSString
    let range = NSRange(location: start, length: end - start)
    let resultString = String(newLine.substring(with: range) as NSString)
    return resultString
}

print("Greeting count -> \(greeting.count)")
print("Greeting count -> \((greeting as NSString).length)")

print("Greeting count -> \(greeting2.count)")
print("Greeting count -> \((greeting2 as NSString).length)")

let result = subString(line: greeting, start: 25, end: 27)
print(result)

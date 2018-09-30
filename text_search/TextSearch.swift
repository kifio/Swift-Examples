import Foundation

func search(_ args: [String]) {

  guard args.count == 2 else {
  	print("Search string must be specified.")
    return
  }

  let results = searchInStdIn(args[1].lowercased())

  for (number, line) in results.reversed() {
    print("line \(number): \(line)")
  }
}

func searchInStdIn(_ arg: String) -> [Int: String] {
  var results = [Int: String]()
  var index = 1
  while let input = readLine() {
    if input.lowercased().range(of:arg) != nil {
      results[index] = input
    }
    index += 1
  }
  return results
}

search(CommandLine.arguments)

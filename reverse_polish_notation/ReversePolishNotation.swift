import Foundation

func convert(_ expression: String) -> String? {
  let tokens = expression.components(separatedBy: " ")
  var result = ""
  var operators = [String]()

  for token in tokens {
    if isOperand(token) {
      result += token
      result += " "
    } else if (isOpeningBracket(token)) {
      operators.append(token)
    } else if (isClosingBracket(token)) {
      var openingBracket: String? = nil
      let op = operators.reversed()

      for o in op {

        if (isOpeningBracket(o)) {
          openingBracket = o
          operators.removeLast()
          break
        }

        result += o
        result += " "

        operators.removeLast()
      }

      if (openingBracket == nil) {
        return nil
      }
    } else if (isOperator(token)) {
      if (!operators.isEmpty) {
        var lastOperator = operators[operators.count - 1]
        while isNeedPopOperator(token, lastOperator) {
          result += lastOperator
          result += " "
          operators.removeLast()
          if operators.isEmpty {
            break
          } else {
            lastOperator = operators[operators.count - 1]
          }
        }
      }
      operators.append(token)
    }
  }

  for (index, element) in operators.reversed().enumerated() {
    result += element
    if (index != operators.count - 1) {
      result += " "
    }
  }

  return result
}

func calc(_ expression: String) -> Double? {
  let tokens = expression.components(separatedBy: " ")
  var numbers = [Double]()

  for token in tokens {
    if isOperand(token) {
      numbers.append(Double(token)!)
    } else {
      guard calc(&numbers, token) else {
        return nil
      }
    }
  }

  return numbers[0]
}

func calc(_ operands: inout [Double], _ o: String) -> Bool {

  guard let b = operands.popLast(), let a = operands.popLast() else {
    return false
  }

  switch o {
    case "+":
      operands.append(a + b)
    case "-":
      operands.append(a - b)
    case "*":
      operands.append(a * b)
    case "/":
      operands.append(a / b)
    case "^":
      operands.append(pow(a, b))
    default:
      print("Operator \(o) doesn't support")
  }

  return true
}

func isOperand(_ token: String) -> Bool {
  return Double(token) != nil
}

func isOperator(_ token: String) -> Bool {
  return ["+", "-", "*", "/", "^"].contains(token)
}

func isOpeningBracket(_ token: String) -> Bool {
  return "(" == token
}

func isClosingBracket(_ token: String) -> Bool {
  return ")" == token
}

func isOperatorsStackEmpty(_ operators: [String]) -> Bool {

  if operators.isEmpty {
    return true
  }

  for o in operators {
    if (!isOpeningBracket(o)) {
      return false
    }
  }

  return true
}

func getPriority(_ o: String) -> Int {
  switch o {
  case "+", "-": return 0
  case "*", "/": return 1
  case "^": return 2
  default: return -1
  }
}

func isRightAssociative(_ o: String) -> Bool {
  return o == "^"
}

func isLeftAssociative(_ o: String) -> Bool {
  return o != "^"
}

func isNeedPopOperator(_ token: String, _ lastOperator: String) -> Bool {
  return !isOpeningBracket(lastOperator)
    && ((isRightAssociative(token) && getPriority(token) < getPriority(lastOperator))
      || (isLeftAssociative(token) && getPriority(token) <= getPriority(lastOperator)))
}

func convertFileToArray(_ path: String) -> [String]? {
  do {
    let text = try String(contentsOfFile: path)
    return text.components(separatedBy: CharacterSet.newlines)
  } catch let err as NSError {
    print(err)
    return nil
  }
}

func printErrorMessage(_ index: Int, _ reason: String) {
  print("""
    \(index): Test failed.
    Reason: \(reason)
  """)
}

func printErrorMessage(_ index: Int, _ reason: String, _ actuals: Any, _ excepted: Any) {
  print("""
    \(index): Test failed.
    Reason: \(reason)
    Actuals: \(actuals)
    Excepted: \(excepted)
   """)
}

func test() {

    guard
     let exArr = convertFileToArray("input/examples"),
     let inpArr = convertFileToArray("input/reversed"),
     let resArr = convertFileToArray("input/results")
    else {
      return
    }

    for (index, line) in exArr.enumerated() {

      guard !line.isEmpty && !line.hasPrefix("#") else {
          continue
      }

      guard let converted = convert(line) else {
        printErrorMessage(index, "Can't convert expression: \(line)")
        continue
      }

      guard converted == inpArr[index] else {
        printErrorMessage(index, "Wrong result of convertation", converted, inpArr[index])
        continue
      }

      guard let excepted = Double(resArr[index]) else {
        printErrorMessage(index, "Can't parse excepted value")
        continue
      }

      guard let result = calc(converted) else {
        printErrorMessage(index, "Can't calc expression \(line)")
        continue
      }

      checkResult(index, result, excepted)
    }
}

func checkResult(_ index: Int, _ actuals: Double?, _ excepted: Double) {
  if actuals == excepted {
    print("\(index): Test passed. Result: \(actuals!)")
  } else {
    printErrorMessage(index, "Wrong result of calculation", actuals, excepted)
  }
}

func readStdIn() {
  while let input = readLine() {
    if let convertedExpression = convert(input) {
      guard let result = calc(convertedExpression) else {
        print("Can't calc \(convertedExpression)")
        continue
      }
      print("Result of \(convertedExpression) is \(result)")
    } else {
      print("Non convertable expression: \(input)")
    }
  }
}

test()
readStdIn()

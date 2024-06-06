import UIKit

// 1
func twoSum(_ num1: Int,_ num2: Int) -> Double {
    return Double(num1 + num2)
}
print("Sum is:", twoSum(10,20)) //result 30.0

// 2
func studentExists(_ studentNames: [String],_ student: String) -> Bool {
    return studentNames.contains(student)
}
let studentNames = ["Keval","Darshan","Sakshi","Yajurva","Shivam"]
print("\nArray contains string:", studentExists(studentNames,"Keval")) //result true
print("Array contains string:", studentExists(studentNames,"Nikhil")) //result false

// 3
func reduce(_ numbersArray: [Int]) -> Int {
    return numbersArray.reduce(0, +)
}
print("\nSum of array is:", reduce([1,2,3,4])) //result 10

// 4
func calculateHypotenuse(_ a: Double, _ b: Double) -> Double {
    return sqrt(pow(a, 2) + pow(b, 2))
}
print("\nHypotenuse is: \(calculateHypotenuse(1, 2)) \n") //result 2.23

// 5
func match(key: Int, dictionary: [Int: String]) -> String? {
    return dictionary[key]
}
let dictionary = [1: "Keval", 2: "Vishal", 3: "Patel"]
print(match(key: 1, dictionary: dictionary)!) // result Keval
print(match(key: 3, dictionary: dictionary)!) // result Patel
print(match(key: 4, dictionary: dictionary) as Any) // result nil

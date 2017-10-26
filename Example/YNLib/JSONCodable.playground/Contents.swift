//: Playground - noun: a place where people can play

import UIKit

var jsonstring: String = """
{
"date": 1505381507.12943,
"userId": 1,
"id": 1,
"title": "delectus aut autem",
"completed": false,
"address": {
"street": "Kulas Light",
"suite": "Apt. 556",
"city": "Gwenborough",
"zipcode": "92998-3874",
"geo": {
"lat": "-37.3159",
"lng": "81.1496"
}
}
}
"""
let jsondata = jsonstring.data(using: String.Encoding.utf8)!

var jsonstrings: String = """
[
{
"userId": 1,
"id": 1,
"title": "delectus aut autem",
"completed": false,
},
{
"userId": 1,
"id": 1,
"title": "delectus aut autem",
"completed": false,
}
]
"""
let jsondatas = jsonstrings.data(using: String.Encoding.utf8)!

struct Todo: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case todoId = "id"
        case userId
        case completed
        case date
        case address
    }
    var title: String
    var todoId: Int?
    var userId: Int
    var completed: Int
    var date: Date?
    var address: Address?
}

struct Address: Codable {
    let city: String
    let zipcode: String
}

struct Test: Codable {
    var title: String
}

//print(Date().timeIntervalSince1970)
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .custom({ (de) -> Date in
    let container = try de.singleValueContainer()
    let time = try container.decode(Double.self)
    return Date(timeIntervalSince1970: time)
})
let encoder = JSONEncoder()
do {
    let todo = try decoder.decode(Todo.self, from: jsondata)
    print("\(todo)")
} catch (let error) {
    print("error trying to convert data to JSON")
    print(error)
}

do {
    let todos = try decoder.decode([Todo].self, from: jsondatas)
    print("\(todos.count)")
    let todojsondata = try encoder.encode(todos.first!)
    let todojsonstring = String(data: todojsondata, encoding: String.Encoding.utf8)
    print("\(todojsonstring)")
} catch (let error) {
    print("error trying to convert data to JSON")
    print(error)
}

do {
    let test = try decoder.decode(Test.self, from: jsondata)
    print("\(test)")
} catch (let error) {
    print("error trying to convert data to JSON")
    print(error)
}

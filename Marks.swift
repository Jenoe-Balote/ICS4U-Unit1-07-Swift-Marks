//
//  Marks.swift
//
//  Created by Jenoe Balote
//  Created on 2021-12-03
//  Version 1.0
//  Copyright (c) 2021 Jenoe Balote. All rights reserved.
//
//  This program calculates a 2d array, populates it with random marks
//  and outputs it to CSV.
//
import Foundation

// Returns a random number from the gaussian distribution
// Java's Random().nextGaussian() method translated to swift since swift
// does not have a gaussian function.
// new Random().nextGaussian * 10 + 75
func nextGaussian() -> Double {

    // Generates random mark betwee 0 and 100
    var nextNextGaussian: Double? = {
        srand48(Int.random(in: 0...100))
        return nil
    }()

    if let gaussian = nextNextGaussian {
        nextNextGaussian = nil
        return gaussian
    } else {
        var value1: Double
        var value2: Double
        var sum: Double
        let lowBound = 0.0
        let highBound = 1.0

        repeat {
            value1 = 2 * Double.random(in: lowBound...highBound) - 1
            value2 = 2 * Double.random(in: lowBound...highBound) - 1
            sum = pow(value1, 2) + pow(value1, 2)
        } while sum >= 1 || sum == 0

        let multiplier = sqrt(-2 * log(sum)/sum)
        nextNextGaussian = value2 * multiplier
        return value1 * multiplier
    }
}

// Generates 2d array of marks and student names
func generateTable(students: [String], assignments: [String]) -> [[String]] {
    let numStudents = students.count
    let numAssignments = assignments.count

    var markArray: [[String]] = []

    for row in 0..<numStudents {
        markArray.append([String]())
        markArray[row].append(students[row])

        for _ in 0..<numAssignments {
            let mark = Int(floor(nextGaussian() * 10 + 75))
            markArray[row].append(String(mark))
        }
    }

    return markArray
}

// Converts file to an array of strings based on lines
func fileContentsToArray(fileName: String) throws -> [String] {
    do {
        let contents = try String(contentsOfFile: fileName)
        let lines = contents.split(separator: "\n")
        var stringArray = [String]()
        stringArray.reserveCapacity(lines.count)

        for line in lines where !line.isEmpty {
            stringArray.append(String(line))
        }

        return stringArray
    } catch {
        print("Something went wrong. Try again.")
        print("\nDone.")
        exit(001)
    }
}

// Gathers input from CLI, makes a 2d array and outputs it to marks.csv
let students = try fileContentsToArray(fileName: CommandLine.arguments[1])
let assignments = try fileContentsToArray(fileName: CommandLine.arguments[2])

// Randomly generated table associated to students and assignments
let markArray = generateTable(students: students, assignments: assignments)

// Clears the file
let text = ""
do {
    try text.write(to: URL(fileURLWithPath: "./marks.csv"), atomically: false, encoding: .utf8)
} catch {
    print(error)
}

// Formats all arrays in 2d array and appends them to
// marks.csv
if let fileWriter = try? FileHandle(forUpdating:
    URL(fileURLWithPath: "./marks.csv")) {

    let assignmentsArray = ", " + assignments.joined(separator: ", ") + "\n"

    fileWriter.seekToEndOfFile()
    fileWriter.write(assignmentsArray.data(using: .utf8)!)

    for array in markArray {
        let arrayToString = array.joined(separator: ", ") + "\n"
        fileWriter.seekToEndOfFile()
        fileWriter.write(arrayToString.data(using: .utf8)!)
    }

    fileWriter.closeFile()
}

print("\nDone.")

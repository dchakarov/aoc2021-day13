//
//  main.swift
//  No rights reserved.
//

import Foundation
import RegexHelper

func main() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }
    
    let lines = inputString.components(separatedBy: "\n")

    var dots = [(x: Int, y: Int)]()
    var instructions = [(String, Int)]()

    var parsingDots = true
    lines.forEach { line in
        if line.isEmpty {
            parsingDots = false
            return
        }
        if parsingDots {
            let ar = line.components(separatedBy: ",").map { Int($0)! }
            dots.append((ar[0], ar[1]))
        } else {
            let ar = line.components(separatedBy: " ").last!.components(separatedBy: "=")
            let coord = ar[0]
            let val = Int(ar[1])!
            instructions.append((coord, val))
        }
    }
//    let newDots = apply(instructions.removeFirst(), dots: dots)
//    print(newDots.count)

    var newDots = dots
    while !instructions.isEmpty {
        newDots = apply(instructions.removeFirst(), dots: newDots)
    }

    printDots(newDots)
}

func printDots(_ dots: [(x: Int, y: Int)]) {
    var maxX = 0
    var maxY = 0
    dots.forEach { dot in
        maxX = max(maxX, dot.x)
        maxY = max(maxY, dot.y)
    }

    for j in 0 ... maxY {
        var row = [String]()
        for i in 0 ... maxX {
            if dots.contains(where: { $0.x == i && $0.y == j }) {
                row.append("#")
            } else {
                row.append(" ")
            }
        }
        print(row.joined(separator: ""))
    }

}

func apply(_ instruction: (String, Int), dots: [(x: Int, y: Int)]) -> [(x: Int, y: Int)] {

    var newDots = [(x: Int, y: Int)]()

    if instruction.0 == "x" {
        dots.forEach { dot in
            if dot.x < instruction.1 {
                newDots.append(dot)
            } else if dot.x > instruction.1 {
                let newX = 2 * instruction.1 - dot.x
                if !dots.contains(where: { $0.x == newX && $0.y == dot.y }) {
                    newDots.append((x: newX, y: dot.y))
                }
            }
        }
    } else {
        dots.forEach { dot in
            if dot.y < instruction.1 {
                newDots.append(dot)
            } else if dot.y > instruction.1 {
                let newY = 2 * instruction.1 - dot.y
                if !dots.contains(where: { $0.x == dot.x && $0.y == newY }) {
                    newDots.append((x: dot.x, y: newY))
                }
            }
        }
    }

    return newDots
}

main()

//
//  ColorExtensions.swift
//  NotLang
//
//  Created by Amier Davis on 2/9/26.
//

import SwiftUI

extension Color {
    static func randomNonWhite() -> Color {
        var red: Double = 0.0
        var green: Double = 0.0
        var blue: Double = 0.0

        repeat {
            red = Double.random(in: 0...1)
            green = Double.random(in: 0...1)
            blue = Double.random(in: 0...1)
        } while red > 0.9 && green > 0.9 && blue > 0.9

        return Color(red: red, green: green, blue: blue)
    }
}

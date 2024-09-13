//
//  Array + Extension.swift
//  ImageApp
//
//  Created by Egor Kruglov on 13.09.2024.
//

import Foundation

extension Array where Element: Equatable {
    mutating func addUniquesFrom(_ array: [Element]) {
        for item in array {
            if !self.contains(item) { append(item) }
        }
    }
}

//
//  SwiftExtensions.swift
//  Addition
//
//  Created by john martin on 9/23/22.
//

import Foundation

// I'm not sure where you are using these extentions but they seem cool. Commenting what do they do would be great practice especially if they are not a fileprivate extension and are general use for all others. Something to keep in mind is that extensions like these can be dangerious if used in a large project. They can cause undesired dependencies from unkown consumers who think they are methods created from Apple. When in reality they are not. Nothing wrong with them here in your project just again something to consider when applying extensions in larger projects with many other coders. Adding comments or making them exlusive to a use case is smart to do.

extension Array {
    func splitBy(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map({ (startIndex) -> [Element] in
            let endIndex = (startIndex.advanced(by: chunkSize) > self.count) ? self.count-startIndex : chunkSize
            return Array(self[startIndex..<startIndex.advanced(by: endIndex)])
        })
    }
}

extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let newLength = self.count
        if newLength < toLength {
            return String(repeatElement(character, count: toLength - newLength)) + self
        } else {
            // .substring is deprecated, a subscript with a partial or closed range is super cool and very helpful. I'd recommend taking the time to learn how that works in swift
            return self.substring(from: index(self.startIndex, offsetBy: newLength - toLength))
        }
    }
}

//
//  Animals.swift
//  Addition
//
//  Created by john martin on 9/23/22.
//

import Foundation

// TODO: Change name of enum,
// TODO: Remove `= "string values"`
/// Generally in Swift Enums are not all caps. `Animals` would be the "proper" swift nameing convention
enum ANIMALS: String, CaseIterable {
    /// Because you have declared this enums `rawValue` type as a `String` it is redundant to set the string values as the exact same string value.
    /// `case owel` rawvalue will be `owel` without having to put the `= "owel"` after it because the enum conforms to `String`
    case owel // This is an example
    case cow = "cow"
    case pig = "pig"
    case frog = "frog"
    case giraffe = "giraffe"
    case snake = "snake"
    case slawth = "slawth"
    case crocodile = "crocodile"
    case rhino = "rhino"
    case monkey = "monkey"
    case elephant = "elephant"
    case narwhal = "narwhal"
}

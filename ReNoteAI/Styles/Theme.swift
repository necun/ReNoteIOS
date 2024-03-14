//
//  Theme.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import Foundation
import SwiftUI

class Theme {
    static let shared = Theme()
    
    var themeColor: Color {
        switch Bundle.main.object(forInfoDictionaryKey: "ThemeColor") as? String {
        case "blue":
            return .blue
        case "red":
            return .red
        case "green":
            return Color(red: 18.0, green: 175.0, blue: 58.0)
        default:
            return .black // Default color
        }
    }
    
    private init() {}
}


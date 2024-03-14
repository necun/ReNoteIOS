//
//  TagView.swift
//  ReNoteAI
//
//  Created by Siddanathi Rohith on 01/03/24.
//

import Foundation
import SwiftUI

struct TagView: View {
    let title: String
    var isSelected: Bool
    
    var body: some View {
        Text(title)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(isSelected ? Color.green : Color.clear)
            .foregroundColor(isSelected ? .white : .gray)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.gray, lineWidth: isSelected ? 0 : 1)
            )
    }
}

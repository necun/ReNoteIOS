//
//  RegisterToSyncView.swift
//  ReNoteAI
//
//  Created by Siddanathi Rohith on 02/03/24.
//

import Foundation
import SwiftUI

struct RegisterToSyncView: View {
    
    @State private var showProfileView = false
    var buttonAction: () -> Void

    init(buttonAction: @escaping () -> Void) {
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.red.opacity(0.1))
                .frame(height: 80)
                .overlay(
                    HStack {
                        Text("Register to Sync your Files in order to backup or restore your Data")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.gray)
                            .padding(.leading)
                        
                        Spacer()
                        
                        Button("Register") {
                            showProfileView = true
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .cornerRadius(20)
                        .padding(.trailing)
                    }
                )
                .padding(.horizontal)
            
            Button(action: buttonAction) {
                SwiftUI.Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color.gray)
                    .padding(20)
            }
        }
        
        NavigationLink(
            destination: ProfileView(),
            isActive: $showProfileView
        ) {
            EmptyView()
        }.isDetailLink(false)
        
    }
}



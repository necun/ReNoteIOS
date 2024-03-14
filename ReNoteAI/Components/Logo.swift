//
//  OTPBoxView.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import Foundation
import SwiftUI


struct Logo: View {    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.size.width * 0.5)
                .padding(.top, UIScreen.main.bounds.size.height * 0.15)
            
            Image("Logo1")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.size.width * 0.5)
        }
    }
}

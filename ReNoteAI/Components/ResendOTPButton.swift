//
//  ResendOTPButton.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import Foundation
import SwiftUI

struct ResendOTPButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("Resend OTP")
                .foregroundColor(Theme.shared.themeColor)
                .underline()
        }
    }
}

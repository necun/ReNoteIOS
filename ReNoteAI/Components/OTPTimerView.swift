//
//  OTPTimerView.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 21/02/24.
//

import Foundation
import SwiftUI

struct OTPTimerView: View {
    @Binding var timeRemaining: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text("\(timeRemaining) sec")
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
    }
}

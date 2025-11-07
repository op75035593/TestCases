//
//  VideoCallView.swift
//  TestCases
//
//  Created by LAP1120 on 24/10/25.
//

import SwiftUI

import SwiftUI

struct VideoCallView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("🎥 Video Call")
                .font(.largeTitle)
                .padding()

            Spacer()

            Rectangle()
                .fill(Color.black.opacity(0.8))
                .frame(height: 300)
                .overlay(Text("Remote Video").foregroundColor(.white))

            Spacer()

            Button(action: { dismiss() }) {
                Text("End Call")
                    .font(.title2)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
        }
    }
}

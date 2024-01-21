//
//  InitialView.swift
//  FIBInit
//
//  Created by Ainul Kazi on 21/1/24.
//

import SwiftUI

struct InitialView: View {
    var body: some View {
        ZStack {
            Image("initial_scene_bg")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Image("Logo")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.22)
                
                TextMediumRegular(text: "Instant Cash Transfers at Your Fingertips. Effortless, Secure, Anytime, Anywhere.",fg_color: .textBackground)
                    .padding(.horizontal, 50)
                    .padding(8)
                    .multilineTextAlignment(.center)
                
                
                Spacer()
                XVerticalBtn(title: "Log In With FIB", textColor:.primary500) {}
                    .padding()
                Spacer()
            }

        }
       // .padding()
    }
}

#Preview {
    InitialView()
}

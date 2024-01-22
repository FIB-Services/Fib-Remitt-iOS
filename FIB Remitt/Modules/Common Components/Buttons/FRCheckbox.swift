//
//  FRCheckbox.swift
//  FIB Remitt
//
//  Created by Ainul Kazi on 22/1/24.
//

import SwiftUI

struct FRCheckbox: View {
    
    @Binding var isSelected : Bool
    var radioColor = Color.primary_500
    var body: some View {
        HStack(alignment: .top,spacing: 13){
            Toggle("", isOn: $isSelected)
                .toggleStyle(SquareRadioButtonStyle(size: 22, color: radioColor))
            
            Text("I agree the")
                .font(UI.FRAppDesignedFont(style: .baseRegular))
                .foregroundColor(Color.textFade)
//                .tint(Color.btn_primary)
            Spacer()
        }
        .frame(maxHeight: 36)
    }
}


struct SquareRadioButtonStyle: ToggleStyle {
    let size: CGFloat
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            ZStack {
                Image(systemName: "square")
                    .frame(width: size, height: size)
                    .foregroundColor(Color.text_Mute)
                
                if configuration.isOn {
                    Image(systemName: "checkmark.square.fill")
                        .frame(width: size, height: size)
                        .foregroundColor(color)
                }
            }
        }
    }
}
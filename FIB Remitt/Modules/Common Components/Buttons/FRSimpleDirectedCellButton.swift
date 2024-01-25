//
//  FRSimpleDirectedCellButton.swift
//  FIB Remitt
//
//  Created by Ainul Kazi on 25/1/24.
//

import SwiftUI

struct FRSimpleDirectedCellButton: View {
    var title : String = "FIB Personal App"
    var action : () -> Void = {}
    var body: some View {
        Button {
            action()
        } label: {
            SimpleDirectedCellView(title: title)
        }

        
    }
}

#Preview {
    ZStack{
        Color.fr_background.ignoresSafeArea()
        FRSimpleDirectedCellButton()
    }
}

//
//  BeneficiaryAddSuccessfulView.swift
//  FIB Remitt
//
//  Created by Ainul Kazi on 23/1/24.
//

import SwiftUI

struct BeneficiaryAddSuccessfulView: View {
    let width = UIScreen.main.bounds.width
    var body: some View {
        VStack(spacing: 20){
            Spacer()
            Image("success_tick")
                .imageDefaultStyle()
                .frame(width: width * 0.25)
            TextH4Medium(text: "Congratulation!", fg_color: .textRegula)
            TextBaseRegular(text: "You have successfully added the Beneficiary", fg_color: .textFade)
                .padding(.horizontal)
                .multilineTextAlignment(.center)

            VStack(spacing:10){
                FRVerticalBtn(title:"OK", btnColor: .primary500) {self.okBtnPressed()}
                    .frame(width:80)

            }.padding()
            Spacer()
        }.navigationBarHidden(true)
    }
}

////MARK: - VIEW COMPONENTS
//extension BeneficiaryAddSuccessfulView{
//    private var bottomButton : some View{}
//}
//

//MARK: - ACTIONS
extension BeneficiaryAddSuccessfulView{
    private func okBtnPressed() {
        loadView(view: FRBottomBarContainer(selected: TabBarItem(icon: "beneficiary_ico", title: "Beneficiary", color: .red)))
    }
}
#Preview {
    BeneficiaryAddSuccessfulView()
}

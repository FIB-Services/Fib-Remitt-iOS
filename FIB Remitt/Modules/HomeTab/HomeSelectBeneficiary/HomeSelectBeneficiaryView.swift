//
//  HomeSelectBeneficiaryView.swift
//  FIB Remitt
//
//  Created by Ainul Kazi on 22/1/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct HomeSelectBeneficiaryView: View {
    @State var isSelected : Bool = false
    @State var isNotSelected : Bool = false
    @State var isFilePickerPresented = false
    @State private var isPickerShown = false
    @State private var selectedBeneficiaryID: String?
    
    @State private var selectedFileURL: URL?
    @ObservedObject var vm = HomeViewModel()
    @ObservedObject var beneficiaryVM = BeneficiaryViewModel()
    @State var type : SelectBeneficiaryType = .BankTransfer
    var homeData = HomeDataHandler.shared
    var body: some View {
        
        let filePickerView = FilePickerView(
            isPickerShown: $isPickerShown,
            allowedContentTypes: [UTType.pdf],
            onSelect: { url in
                homeData.invoicePath = url.absoluteString
                print("Selected file: \(url)")
                isFilePickerPresented = false
                if homeData.collectionPoint.lowercased() == "bank"{
                    bankReceivedApi()
                }else{
                    agentReceivedApi()
                }
              
                
            },
            onError: { error in
                print("Error: \(error.localizedDescription)")
            }
        )
        
        ZStack {
            
            VStack (spacing: 25){
                navigationBar
                topAccountCreation
                ScrollView{
                    contexContainer
                }
              
                bottomButton
            }
            .padding()
            .background(Color.frBackground.ignoresSafeArea())
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $vm.goToNext) {vm.destinationView}
            .onAppear{
                if homeData.deliveryMethodType.lowercased() == "bank transfer"{
                    beneficiaryVM.getBankBeneficiaries()
                    self.type = .BankTransfer
                    
                }else{
                    beneficiaryVM.getCashPickBeneficiaries()
                    self.type = .CashPickup
                }
            }
            
            if isFilePickerPresented {
                // Blur background
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 3)
                    .onTapGesture {
                        filePickerView.hidePicker()
                        isFilePickerPresented = false
                    }
                
                // Your FilePickerCellView centered
                FilePickerCellView(selected: $isFilePickerPresented)
                    .onTapGesture {
                        filePickerView.showPicker()
                    }
                    .fileImporter(
                        isPresented: $isPickerShown,
                        allowedContentTypes: filePickerView.allowedContentTypes,
                        onCompletion: filePickerView.handleResult
                    )
            }
            
        }
        
    }
    
    
    func bankReceivedApi(){
      
         let pdfData  = pdfData(from: URL(string: homeData.invoicePath) ?? URL(fileURLWithPath: ""))  //URL(string: urlString)
        
        vm.apiReceivedInBank(beneficiaryId: selectedBeneficiaryID ?? "" , fromCurrency: homeData.fromCurrency, amountToTransfer: homeData.amountToTransfer, toCurrency: homeData.toCurrency, paymentMethod: "Bank".uppercased(), collectionPoint: homeData.collectionPoint.uppercased(), purposeId: homeData.purposeId, invoice: pdfData)
        
    }
    
    
    func agentReceivedApi(){
        
       let pdfData  = pdfData(from: URL(string: homeData.invoicePath) ?? URL(fileURLWithPath: ""))  //URL(string: urlString)
        
        vm.apiCashPickUpFromAgent(beneficiaryId: selectedBeneficiaryID ?? "" , fromCurrency: homeData.fromCurrency, amountToTransfer: homeData.amountToTransfer, toCurrency: homeData.toCurrency, paymentMethod: "Bank".uppercased(), collectionPoint: homeData.collectionPoint.uppercased(), purposeId: homeData.purposeId, invoice: pdfData)
        
    }
    
    
}

//MARK: - View Components
extension HomeSelectBeneficiaryView{
    private var navigationBar : some View {
        FRNavigationBarView(title: "Select Beneficiary", rightView: AnyView(FRBarButton(icon: "bell_ico", action: {self.notificationBtnPressed()})))
    }
    private var topAccountCreation : some View{
        HStack{
            TextBaseMedium(text: homeData.collectionPoint.lowercased() == "bank" ? "Select Bank Account" : "Select Beneficiary Account",fg_color: .textMute)
            Spacer()
            Button(action: { self.createAccountBtnPressed()}, label: {
                TextBaseMedium(text: "+Add New",fg_color: .primary500).underline()
            })}
    }
    private var contexContainer : some View{
        Group{
            if type == .BankTransfer{
                VStack {
                    ForEach(beneficiaryVM.bankBeneficiaries ?? [], id: \.id) { beneficiary in
                        let selected = (beneficiary.id == selectedBeneficiaryID)
                        AccountInfoCellView(selected: selected, title: beneficiary.fullName ?? "", subtitle1:beneficiary.accountNumber ?? "" , subtitle2: beneficiary.bankBeneficiaryBankDTO?.name ?? "", icon: beneficiary.typeOfBeneficiary?.lowercased() == "personal" ? "personal_ico" : "business_ico",type: homeData.collectionPoint.lowercased() == "bank" ? .BankTransfer : .CashPickup)
                            .onTapGesture{
                                selectedBeneficiaryID = beneficiary.id
                                if  beneficiary.typeOfBeneficiary?.lowercased() == "business"{
                                    isFilePickerPresented = true
                                    selectedBeneficiaryID = beneficiary.id
                                }else{
                                   //
                                    selectedBeneficiaryID = beneficiary.id
                                }
                            }
                    }
                }
            }else{
                VStack {
                    ForEach(beneficiaryVM.cashPickUpBeneficiaries ?? [], id: \.id) { beneficiary in
                        let selected = (beneficiary.id == selectedBeneficiaryID)
                        AccountInfoCellView(selected: selected, title: beneficiary.fullName ?? "", subtitle1:beneficiary.phoneNumber ?? "" , subtitle2:  beneficiary.address ?? "", icon: beneficiary.typeOfBeneficiary?.lowercased() == "personal" ? "personal_ico" : "business_ico",type: homeData.collectionPoint.lowercased() == "bank" ? .BankTransfer : .CashPickup)
                            .onTapGesture{
                                selectedBeneficiaryID = beneficiary.id
                                if  beneficiary.typeOfBeneficiary?.lowercased() == "business"{
                                    isFilePickerPresented = true
                                    selectedBeneficiaryID = beneficiary.id
                                }else{
                                  //
                                    selectedBeneficiaryID = beneficiary.id
                                }
                            }
                    }
                }
            }
        }
        
    }
    
   
    private var bottomButton : some View{
        FRVerticalBtn(title: "Procced", btnColor: .primary500) {self.proccedBtnPressed()}
    }
}

//MARK: - ACTIONS
extension HomeSelectBeneficiaryView{
    private func createAccountBtnPressed() {
        
    }
    private func notificationBtnPressed() {
        
    }
    private func proccedBtnPressed() {
        //vm.navigateToBeneficiarySummary()
        if homeData.collectionPoint.lowercased() == "bank"{
            bankReceivedApi()
        }else{
            agentReceivedApi()
        }
    }
}

#Preview {
    HomeSelectBeneficiaryView()
}

//
//  HistoryRootView.swift
//  FIB Remitt
//
//  Created by Izak on 22/1/24.
//

import SwiftUI

struct HistoryRootView: View {
    
    @ObservedObject var vm = TransactionHistoryViewModel() // history view model
    //@State var selectedFilterValue: String = "All"
    @State var from = ""
    @State var to = ""
    var body: some View {
        VStack{
            navigationBar
            ScrollView{
                topFilterDropdown
                contextContainer
            }
        }
        .padding(.horizontal)
        .background(Color.frBackground.ignoresSafeArea())
        .navigationDestination(isPresented: $vm.goToNext) {vm.destinationView}
        .onAppear(perform: {
            vm.selectedFilterValue = "All"
            self.from = ""
            self.to = ""
            TransactionDataHandler.shared.clear()
            initialDataAll()
        })
    }
    
    func initialDataAll(from:String = "",to:String = ""){
        //vm.transactionHistoryDataOnly = []
        transactionListApi(from: from, to:to)
        
    }
    
    //MARK: - API CALL
    func transactionListApi(from:String = "",to:String = ""){
        vm.transactionListFetch(page: TransactionDataHandler.shared.currentTransactionPageNo,from: from,to: to)
    }
    
}
//MARK: - VIEW COMPONENTS
extension HistoryRootView{
    private var navigationBar : some View {
        FRNavigationBarView( leftView: nil, title: "Transfer History", rightView: AnyView(FRBarButton(icon: "bell_ico", action: {self.notificationBtnPressed()})))
    }
    private var topFilterDropdown : some View {
        HStack{
            FRTextDropDownButton(title: vm.selectedFilterValue, action: {self.filterBtnPressed()})
                .padding(.vertical, 5)
                .padding(.trailing, 20)
                .padding(.vertical, 10)
            Spacer()
        }
    }
    private var contextContainer : some View{
        VStack(spacing:10){
            LazyVStack{
                ForEach(vm.transactionHistoryDataOnly) { transactionData in
                    TransactionHistoryCellView(transaction: transactionData)
                        .onTapGesture { vm.navigateToTransactionDetails(transactionNumber: transactionData.transactionNumber ?? "") }
                        .onAppear()   { if transactionData == vm.transactionHistoryDataOnly.last{
                            TransactionDataHandler.shared.currentTransactionPageNo += 1
                            vm.transactionListFetch(page: TransactionDataHandler.shared.currentTransactionPageNo,from: from,to: to)
                        }}
                }
            }
            
            if self.vm.isMorePerpHistoryLoading {
                ProgressView()
            }
        }
    }
}

//MARK: - ACTIONS
extension HistoryRootView{
    private func notificationBtnPressed() {}
    private func filterBtnPressed() {
        showSheet(view: AnyView(FilterOptionsView(selectedValue: vm.selectedFilterValue) { selectedItem in
            self.vm.selectedFilterValue = selectedItem
            filterTheData()
        }))
    }
    
    func filterTheData(){
        if vm.selectedFilterValue == "All"{
            self.from = ""
            self.to = ""
            initialDataAll() //from:String = "",to:String = ""
        }else if vm.selectedFilterValue == "Today" {
            let dateRangeToday = vm.getDateRange(for: .today)
            self.from = dateRangeToday.from
            self.to = dateRangeToday.to
            initialDataAll(from:"\(dateRangeToday.from)",to: "\(dateRangeToday.to)")
        } else if vm.selectedFilterValue == "Last 7 Days" {
            let dateRangeLast7Days = vm.getDateRange(for: .last7Days)
            self.from = dateRangeLast7Days.from
            self.to = dateRangeLast7Days.to
            initialDataAll(from:"\(dateRangeLast7Days.from)",to: "\(dateRangeLast7Days.to)")
        } else if vm.selectedFilterValue == "This Month" {
            let currentMonthRange = vm.getDateRange(for: .currentMonth)
            self.from = currentMonthRange.from
            self.to = currentMonthRange.to
            initialDataAll(from:"\(currentMonthRange.from)",to: "\(currentMonthRange.to)")
        } else {
            let currentYearRange = vm.getDateRange(for: .currentYear)
            self.from = currentYearRange.from
            self.to = currentYearRange.to
            initialDataAll(from:"\(currentYearRange.from)",to: "\(currentYearRange.to)")
        }
    }
}

#Preview {
    HistoryRootView()
}

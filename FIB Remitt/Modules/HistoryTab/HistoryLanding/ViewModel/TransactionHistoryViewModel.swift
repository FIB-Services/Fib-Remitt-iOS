
//
import SwiftUI
import Combine


class TransactionHistoryViewModel : ObservableObject{
    @Published var goToNext        = false
    
    @Published var destinationView = AnyView(Text("Destination"))
    @Published var transactionHistoryResponse: TransactionHistoryResponse?
    @Published var transactionHistoryDataOnly: [TransactionListContent] = []
    @Published var transactionDetails : TransactionDetailsResponse?
    
    @Published var selectedFilterValue : String = "All"
    
    
    private var subscribers = Set<AnyCancellable>()
    let repo = TransactionListRepository()
    
    
    func navigateToEditBankBeneficiary() {
        self.destinationView = AnyView(EditBeneficiaryBankView())
        self.goToNext        = true
    }
    
    
    func navigateToTransactionDetails(transactionNumber:String){
        self.destinationView = AnyView(HistoryDetailView(id: transactionNumber))
        self.goToNext        = true
    }
    
//    func transactionDetailsFetch(transactionNumber:String) {
//        repo.transactionDetailsApi(transactionNumber: transactionNumber)
//        repo.$transactionDetails.sink { result in
//            self.transactionDetails = result
//        }.store(in: &subscribers)
//    }
    
    func transactionDetailsFetch(transactionNumber: String) {
        repo.transactionDetailsApi(transactionNumber: transactionNumber)
        repo.$transactionDetails
            .sink { [weak self] result in
                self?.transactionDetails = result
            }
            .store(in: &subscribers)
    }

    
    func transactionListFetch(page:Int, from: String, to : String) {
        repo.transactionListApi(page:page ,from:from, to:to)
        repo.$transactionHistoryList.sink { result in
//            self.transactionHistoryResponse = result
            print(self.transactionHistoryDataOnly.count)
            if page == 0{
                self.transactionHistoryDataOnly =   (result?.content ?? [])
            }else{
                self.transactionHistoryDataOnly =  self.transactionHistoryDataOnly  + (result?.content ?? [])
            }
        
        }.store(in: &subscribers)
        
    }
    
    
    //MARK: FOR FILTER
    
    enum DateRangeType {
        case today
        case last7Days
        case currentMonth
        case currentYear
    }

    func getDateRange(for rangeType: DateRangeType) -> (from: String, to: String) {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        switch rangeType {
            
        case .today:
            return (dateFormatter.string(from: currentDate), dateFormatter.string(from: currentDate))
            
            
        case .last7Days:
            guard let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: currentDate) else {
                fatalError("Failed to calculate the date for 7 days ago.")
            }
            return (dateFormatter.string(from: sevenDaysAgo), dateFormatter.string(from: currentDate))

        case .currentMonth:
            let components = calendar.dateComponents([.year, .month], from: currentDate)
            guard let startOfMonth = calendar.date(from: components),
                  let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
                fatalError("Failed to calculate the start or end of the month.")
            }
            return (dateFormatter.string(from: startOfMonth), dateFormatter.string(from: endOfMonth))

        case .currentYear:
            let yearStartComponents = calendar.dateComponents([.year], from: currentDate)
            guard let startOfYear = calendar.date(from: yearStartComponents),
                  let endOfYear = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: startOfYear) else {
                fatalError("Failed to calculate the start or end of the year.")
            }
            return (dateFormatter.string(from: startOfYear), dateFormatter.string(from: endOfYear))
        }
    }

    func getTodayDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    // Usage Today
//    let todayDateString = getTodayDateString()
//    print("Today: \(todayDateString)")
//
//
//
//    // Usage others range
//    let last7DaysRange = getDateRange(for: .last7Days)
//    print("Last 7 Days: From \(last7DaysRange.from) to \(last7DaysRange.to)")
//
//    let currentMonthRange = getDateRange(for: .currentMonth)
//    print("Current Month: From \(currentMonthRange.from) to \(currentMonthRange.to)")
//
//    let currentYearRange = getDateRange(for: .currentYear)
//    print("Current Year: From \(currentYearRange.from) to \(currentYearRange.to)")
}

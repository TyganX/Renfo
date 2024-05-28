//// MARK: - Active Indicator
//private var activeIndicator: some View {
//    AnyView(HStack {
//        Menu {
//            Button(action: {}) {
//                Label(viewModel.activeIndicatorText, systemImage: "calendar.badge.checkmark")
//            }
//        } label: {
//            PulsingView()
//                .foregroundColor(viewModel.activeIndicatorText == "Currently Active!" ? .green : .red)
//                .frame(width: 10, height: 10)
//        }
//    })
//}



//var activeIndicatorText: String {
//    let startDate = convertStringToDate(dateString: self.festival.dateStart) ?? Date.distantFuture
//    let endDate = convertStringToDate(dateString: self.festival.dateEnd) ?? Date.distantPast
//    let currentDate = Date()
//
//    if (currentDate >= startDate && currentDate <= endDate) {
//        return "Currently Active!"
//    } else if (currentDate < startDate) {
//        let daysUntilStart = Calendar.current.dateComponents([.day], from: currentDate, to: startDate).day ?? 0
//        return "\(daysUntilStart) Days Until Huzzah!"
//    } else {
//        return "TBA"
//    }
//}

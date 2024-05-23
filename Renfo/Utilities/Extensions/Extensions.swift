import Foundation

extension Date {
    func formattedDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy" // Change to abbreviated month format
        return formatter.string(from: self)
    }
}

extension FestivalModel {
    var isActive: Bool {
        guard let startDate = convertStringToDate(dateString: self.dateStart),
              let endDate = convertStringToDate(dateString: self.dateEnd) else {
            return false
        }
        let currentDate = Date()
        return currentDate >= startDate && currentDate <= endDate
    }
}

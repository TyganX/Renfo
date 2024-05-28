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
        guard let startDate = self.dateStart.toDate(format: "MM/dd/yyyy"),
              let endDate = self.dateEnd.toDate(format: "MM/dd/yyyy") else {
            print("Error parsing dates for \(self.name)")
            return false
        }
        let currentDate = Date()
        let active = currentDate >= startDate && currentDate <= endDate
        return active
    }
}

extension String {
    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }

    func toTime() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm" // Ensure the input time format is correct
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

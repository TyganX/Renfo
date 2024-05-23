import Foundation

func convertStringToDate(dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter.date(from: dateString)
}

func convertTimeString(timeString: String) -> String? {
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HHmm"
    guard let date = timeFormatter.date(from: timeString) else { return nil }
    timeFormatter.dateFormat = "h:mm a"
    return timeFormatter.string(from: date)
}

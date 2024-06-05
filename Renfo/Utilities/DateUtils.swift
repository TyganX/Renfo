import Foundation

func convertStringToDate(dateString: String, format: String = "yyyy-MM-dd") -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format // Use default format if not specified
    return dateFormatter.date(from: dateString)
}

func convertDateToString(date: Date, format: String = "yyyy-MM-dd") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

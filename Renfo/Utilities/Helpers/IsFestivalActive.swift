import SwiftUI

func isFestivalActive(_ festival: FestivalModel) -> Bool {
    let startDate = festival.dateStart.toDate(format: "MM/dd/yyyy") ?? Date.distantFuture
    let endDate = festival.dateEnd.toDate(format: "MM/dd/yyyy") ?? Date.distantPast
    let currentDate = Date()
    return currentDate >= startDate && currentDate <= endDate
}

import SwiftUI

// Define a structure for an event
struct Event: Identifiable {
    var id = UUID()
    var festivalName: String
    var eventName: String
    var date: Date
}

// Sample events data
let eventData = [
    Event(festivalName: "Festival 1", eventName: "Event 1", date: Date()),
    Event(festivalName: "Festival 1", eventName: "Event 2", date: Date()),
    Event(festivalName: "Festival 1", eventName: "Event 3", date: Date()),
    Event(festivalName: "Festival 2", eventName: "Event 1", date: Date().addingTimeInterval(86400)),
    Event(festivalName: "Festival 2", eventName: "Event 2", date: Date().addingTimeInterval(86400)), // Next day
    // Add more events here
]

// Group events by day
func groupEventsByDay(events: [Event]) -> [Date: [Event]] {
    let groupedEvents = Dictionary(grouping: events) { event in
        Calendar.current.startOfDay(for: event.date)
    }
    return groupedEvents
}

// Events view
struct EventsView: View {
    // Grouped events
    let groupedEvents: [Date: [Event]]

    var body: some View {
        List {
            ForEach(groupedEvents.keys.sorted(), id: \.self) { day in
                Section(header: Text(day.formatted(date: .abbreviated, time: .omitted))) {
                    ForEach(groupedEvents[day] ?? []) { event in
                        VStack(alignment: .leading) {
                            Text(event.eventName)
                                .font(.headline)
                            Text(event.festivalName)
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
    }
}

// Simple month view
struct MonthView: View {
    @AppStorage("appColor") var appColor: AppColor = .default // Retrieve the selected app color
    
    let daysInMonth: [Date]
    let daysOfWeek: [String] = ["S", "M", "T", "W", "R", "F", "A"]
    let eventsByDay: [Date: [Event]]

    // Make currentMonth a computed property
    var currentMonth: String {
        let today = Date()
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM yyyy"
        return monthFormatter.string(from: today)
    }
    
    init(events: [Event]) {
        // Get the current month and year
        let today = Date()
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // Set the first day of the week to Sunday
        let range = calendar.range(of: .day, in: .month, for: today)!
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        let sequenceDays = range.lowerBound..<range.upperBound
        daysInMonth = sequenceDays.map { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
        }

        // Group events by day
        eventsByDay = groupEventsByDay(events: events)
    }

    var body: some View {
        VStack {
            Group {
                // Day of the week headers
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
                    Text("S")
                        .frame(width: 30, height: 30)
                        .foregroundColor(appColor.color)
                    Text("M")
                        .frame(width: 30, height: 30)
                        .foregroundColor(appColor.color)
                    Text("T")
                        .frame(width: 30, height: 30)
                        .foregroundColor(appColor.color)
                    Text("W")
                        .frame(width: 30, height: 30)
                        .foregroundColor(appColor.color)
                    Text("T")
                        .frame(width: 30, height: 30)
                        .foregroundColor(appColor.color)
                    Text("F")
                        .frame(width: 30, height: 30)
                        .foregroundColor(appColor.color)
                    Text("S")
                        .frame(width: 30, height: 30)
                        .foregroundColor(appColor.color)
                }
                .background(Color.gray.opacity(0.25))
                
                // Days grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
                    // Add empty cells if the first day of the month is not Sunday
                    let weekdayOfFirstDay = Calendar.current.component(.weekday, from: daysInMonth.first!)
                    let emptyCells = weekdayOfFirstDay - 1
                    ForEach(0..<emptyCells, id: \.self) { _ in
                        Text("")
                            .frame(width: 30, height: 30)
                    }
                    ForEach(daysInMonth, id: \.self) { day in
                        Text("\(Calendar.current.component(.day, from: day))")
                            .frame(width: 30, height: 30)
                            .background(eventsByDay[day] != nil ? Color.gray.opacity(0.3) : Color.clear)
                            .cornerRadius(5)
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.25))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// Main view
struct CalendarView: View {
    // Group events by day
    let groupedEvents = groupEventsByDay(events: eventData)

    var body: some View {
        VStack {
            // Top half for the month view
            MonthView(events: eventData)
            //                    .frame(maxHeight: .infinity) // This will take half the space available
            
            // Bottom half for the scrollable list of events
            EventsView(groupedEvents: groupedEvents)
                .frame(maxHeight: .infinity) // This will take the remaining space
        }
        // Move the month name to the navigation title
        .navigationTitle(MonthView(events: eventData).currentMonth)
    }
}

// Preview
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CalendarView()
        }
    }
}

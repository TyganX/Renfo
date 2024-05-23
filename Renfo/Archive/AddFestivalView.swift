import SwiftUI

struct AddFestivalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var description = ""
    @State private var logoImageName = ""
    @State private var established = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var mapLink = ""
    @State private var websiteURL = ""
    @State private var ticketsURL = ""
    @State private var festivalMapImageName = ""
    @State private var campgroundMapImageName = ""
    @State private var lostAndFoundURL = ""
    @State private var startDate = ""
    @State private var endDate = ""
    @State private var startTime = ""
    @State private var endTime = ""
    @State private var street = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zip = ""
    @State private var facebook = ""
    @State private var instagram = ""
    @State private var x = ""
    @State private var youTube = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Festival Details")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    TextField("Logo Image Name", text: $logoImageName)
                    TextField("Established Year", text: $established)
                    TextField("Phone Number", text: $phoneNumber)
                    TextField("Email", text: $email)
                    TextField("Map Link", text: $mapLink)
                    TextField("Website URL", text: $websiteURL)
                    TextField("Tickets URL", text: $ticketsURL)
                    TextField("Festival Map Image Name", text: $festivalMapImageName)
                    TextField("Campground Map Image Name", text: $campgroundMapImageName)
                    TextField("Lost and Found URL", text: $lostAndFoundURL)
                }

                Section(header: Text("Date and Time")) {
                    TextField("Start Date", text: $startDate)
                    TextField("End Date", text: $endDate)
                    TextField("Start Time", text: $startTime)
                    TextField("End Time", text: $endTime)
                }

                Section(header: Text("Location")) {
                    TextField("Street", text: $street)
                    TextField("City", text: $city)
                    TextField("State", text: $state)
                    TextField("ZIP Code", text: $zip)
                }

                Section(header: Text("Social Media")) {
                    TextField("Facebook", text: $facebook)
                    TextField("Instagram", text: $instagram)
                    TextField("X", text: $x)
                    TextField("YouTube", text: $youTube)
                }
            }
            .navigationTitle("Add Festival")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: handleAddFestival) {
                        Text("Add")
                            .bold()
                    }
                    .disabled(fieldsAreEmpty)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private var fieldsAreEmpty: Bool {
        name.isEmpty || description.isEmpty || logoImageName.isEmpty || established.isEmpty || phoneNumber.isEmpty || email.isEmpty || mapLink.isEmpty || websiteURL.isEmpty || ticketsURL.isEmpty || festivalMapImageName.isEmpty || campgroundMapImageName.isEmpty || lostAndFoundURL.isEmpty || startDate.isEmpty || endDate.isEmpty || startTime.isEmpty || endTime.isEmpty || street.isEmpty || city.isEmpty || state.isEmpty || zip.isEmpty || facebook.isEmpty || instagram.isEmpty || x.isEmpty || youTube.isEmpty
    }

    private func handleAddFestival() {
        if fieldsAreEmpty {
            alertTitle = "Missing Information"
            alertMessage = "Please fill out all fields."
            showingAlert = true
        } else {
            // Save the new festival
            // Add your saving logic here
            dismiss()
        }
    }
}

// MARK: - Preview Provider
struct AddFestivalView_Previews: PreviewProvider {
    static var previews: some View {
        AddFestivalView()
    }
}

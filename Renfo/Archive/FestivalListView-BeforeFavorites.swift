//import Foundation
//import SwiftUI
//import MessageUI
//
//// MARK: - Home View
//struct FestivalListView: View {
//    // MARK: - State Properties
//    @State private var visibleStates: [String: Bool] = [:] {
//        didSet {
//            saveVisibleStates()
//        }
//    }
//    @State private var editMode: EditMode = .inactive
//    @State private var tempVisibleStates: [String: Bool] = [:]
//    @State private var searchText = ""
//    @Environment(\.scenePhase) private var scenePhase
//    @State private var showingMailView = false
//    @State private var result: MFMailComposeResult? = nil
//    @State private var showAlert = false
//    @State private var festivals: [FestivalModel] = []
//    @State private var selectedFestival: FestivalModel?
//    @State private var isFestivalViewActive = false
//
//    init() {
//        loadVisibleStates()
//    }
//
//    // MARK: - View Body
//    var body: some View {
//        List {
//            festivalSections
//            addFestivalFooter
//        }
//        .searchable(text: $searchText, prompt: "Search")
//        .navigationTitle("Festivals")
//        .environment(\.editMode, $editMode)
//        .toolbar {
//            EditButton(editMode: $editMode, visibleStates: $visibleStates, tempVisibleStates: $tempVisibleStates)
//        }
//        .sheet(isPresented: $showingMailView) {
//            MailView(result: $result)
//        }
//        .alert(isPresented: $showAlert) {
//            Alert(
//                title: Text("Cannot Send Mail"),
//                message: Text("Your device is not configured to send mail. Please configure a mail account in the Mail app or contact support."),
//                dismissButton: .default(Text("OK"))
//            )
//        }
//        .onAppear {
//            fetchFestivals()
//        }
//        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
//            saveVisibleStates()
//        }
//    }
//
//    private var festivalSections: some View {
//        ForEach(filteredFestivals.keys.sorted(), id: \.self) { state in
//            if editMode == .active || visibleStates[state] ?? true {
//                Section(header: EditableSectionHeader(state: state, tempVisibleStates: $tempVisibleStates, editMode: $editMode)) {
//                    ForEach(filteredFestivals[state] ?? []) { festival in
//                        NavigationLink(destination: FestivalView(festival: festival)) {
//                            HStack {
//                                if !festival.logoImage.isEmpty {
//                                    Image(festival.logoImage)
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 40, height: 40)
//                                }
//                                Text(festival.name)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    private var addFestivalFooter: some View {
//        Group {
//            if editMode == .inactive {
//                Section {
//                    HStack {
//                        Text("Don't see a festival?")
//                        Button(action: {
//                            if MFMailComposeViewController.canSendMail() {
//                                showingMailView.toggle()
//                            } else {
//                                showAlert = true
//                            }
//                        }) {
//                            Text("Let's add it!")
//                                .foregroundColor(.blue)
//                        }
//                    }
//                }
//                .frame(maxWidth: .infinity)
//                .listRowBackground(Color.clear)
//            }
//        }
//    }
//
//    private var filteredFestivals: [String: [FestivalModel]] {
//        var groupedFestivals = Dictionary(grouping: festivals, by: { $0.state })
//        if !searchText.isEmpty {
//            groupedFestivals = groupedFestivals.mapValues { $0.filter { $0.name.localizedCaseInsensitiveContains(searchText) } }
//        }
//        if editMode == .inactive {
//            groupedFestivals = groupedFestivals.mapValues { $0.filter { visibleStates[$0.state] ?? true } }
//        }
//        return groupedFestivals
//    }
//
//    private func fetchFestivals() {
//        FirestoreService().fetchAllFestivals { fetchedFestivals in
//            DispatchQueue.main.async {
//                self.festivals = fetchedFestivals
//                updateVisibleStates(with: fetchedFestivals)
//                saveFestivalsToCache()
//            }
//        }
//    }
//
//    private func updateVisibleStates(with fetchedFestivals: [FestivalModel]) {
//        var initialStates = [String: Bool]()
//        for festival in fetchedFestivals {
//            if let state = visibleStates[festival.state] {
//                initialStates[festival.state] = state
//            } else {
//                initialStates[festival.state] = true
//            }
//        }
//        visibleStates = initialStates
//    }
//
//    private func saveFestivalsToCache() {
//        if let encoded = try? JSONEncoder().encode(festivals) {
//            UserDefaults.standard.set(encoded, forKey: "cachedFestivals")
//        }
//    }
//
//    private func loadFestivalsFromCache() {
//        if let savedFestivals = UserDefaults.standard.data(forKey: "cachedFestivals"),
//           let decodedFestivals = try? JSONDecoder().decode([FestivalModel].self, from: savedFestivals) {
//            self.festivals = decodedFestivals
//        }
//    }
//
//    private func saveVisibleStates() {
//        if let encoded = try? JSONEncoder().encode(visibleStates) {
//            UserDefaults.standard.set(encoded, forKey: "visibleStates")
//        }
//    }
//
//    private func loadVisibleStates() {
//        if let savedStates = UserDefaults.standard.data(forKey: "visibleStates"),
//           let decodedStates = try? JSONDecoder().decode([String: Bool].self, from: savedStates) {
//            visibleStates = decodedStates
//        }
//    }
//}
//
//// MARK: - Editable Section Header
//struct EditableSectionHeader: View {
//    let state: String
//    @Binding var tempVisibleStates: [String: Bool]
//    @Binding var editMode: EditMode
//
//    var body: some View {
//        Button(action: {
//            if editMode == .active {
//                tempVisibleStates[state]?.toggle()
//            }
//        }) {
//            HStack {
//                if editMode == .active {
//                    Image(systemName: tempVisibleStates[state] ?? true ? "checkmark.circle.fill" : "circle")
//                        .foregroundColor(tempVisibleStates[state] ?? true ? nil : .gray)
//                }
//                Text(state)
//                    .font(.footnote)
//                    .fontWeight(.bold)
//                    .foregroundColor(.primary)
//                Spacer()
//            }
//        }
//        .disabled(editMode == .inactive)
//    }
//}
//
//// MARK: - Edit Button
//struct EditButton: View {
//    @Binding var editMode: EditMode
//    @Binding var visibleStates: [String: Bool]
//    @Binding var tempVisibleStates: [String: Bool]
//
//    var body: some View {
//        Button(action: {
//            withAnimation {
//                if editMode == .active {
//                    visibleStates = tempVisibleStates
//                } else {
//                    tempVisibleStates = visibleStates
//                }
//                editMode = editMode == .active ? .inactive : .active
//            }
//        }) {
//            Image(systemName: editMode == .active ? "checkmark.circle" : "ellipsis.circle")
//        }
//    }
//}
//
//// MARK: - Mail View
//struct MailView: UIViewControllerRepresentable {
//    @Binding var result: MFMailComposeResult?
//
//    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
//        @Binding var result: MFMailComposeResult?
//
//        init(result: Binding<MFMailComposeResult?>) {
//            _result = result
//        }
//
//        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//            defer {
//                controller.dismiss(animated: true, completion: nil)
//            }
//            self.result = result
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(result: $result)
//    }
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
//        let vc = MFMailComposeViewController()
//        vc.setToRecipients(["request@renfo.app"])
//        vc.setSubject("Festival Request")
//        vc.setMessageBody("I would like to request the addition of the following festival:\n\nFestival Name: ", isHTML: false)
//        vc.mailComposeDelegate = context.coordinator
//        return vc
//    }
//
//    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
//    }
//
//    static var canSendMail: Bool {
//        return MFMailComposeViewController.canSendMail()
//    }
//}
//
//// MARK: - Preview Provider
//struct FestivalListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            FestivalListView()
//        }
//    }
//}

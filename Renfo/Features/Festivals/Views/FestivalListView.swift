import SwiftUI
import MessageUI

// MARK: - Home View
struct FestivalListView: View {
    @EnvironmentObject var viewModel: FestivalListViewModel
    @State private var isShowingMailView = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var showAlert = false

    // MARK: - View Body
    var body: some View {
        VStack {
            festivalList
                .navigationTitle("Festivals")
//                .searchable(text: $viewModel.searchText, prompt: "Search")
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        sortMenu
                    }
                }
                .sheet(isPresented: $isShowingMailView) {
                    MailView(isShowing: $isShowingMailView, result: $mailResult)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Cannot Send Mail"),
                        message: Text("Your device is not configured to send mail. Please configure a mail account in the Mail app or contact support."),
                        dismissButton: .default(Text("OK"))
                    )
                }
        }
        .onAppear {
            viewModel.fetchFestivals()
        }
        .refreshable {
            viewModel.fetchFestivals()
        }
    }

    // MARK: - View Components
    private var festivalList: some View {
        List {
            ForEach(viewModel.sortedFestivals.keys.sorted(), id: \.self) { key in
                festivalSection(for: key)
            }
            addFestivalFooter
        }
    }

    private func festivalSection(for key: String) -> some View {
        Section(header: Text(key)) {
            ForEach(viewModel.sortedFestivals[key] ?? []) { festival in
                NavigationLink(destination: FestivalView(viewModel: FestivalViewModel(festival: festival))) {
                    FestivalRow(festival: festival)
                }
            }
        }
    }

    private var sortMenu: some View {
        Menu {
            Text("Sort")
            Picker(selection: $viewModel.sortOption, label: Text("Sorting options")) {
                Label("Name", systemImage: "textformat").tag(SortOption.name)
                Label("State", systemImage: "map").tag(SortOption.state)
                Label("Active", systemImage: "calendar").tag(SortOption.active)
                Label("Favorite", systemImage: "star").tag(SortOption.favorite)
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }

    private var addFestivalFooter: some View {
        HStack {
            Text("Don't see a festival?")
            Button(action: handleAddFestival) {
                Text("Let's add it!")
                    .foregroundColor(.blue)
            }
        }
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
    }

    // MARK: - Helper Methods
    private func handleAddFestival() {
        if MailView.canSendMail {
            isShowingMailView = true
        } else {
            showAlert = true
        }
    }
}

// MARK: - Festival Row
struct FestivalRow: View {
    let festival: FestivalModel
    @State private var logoImage: UIImage? = nil
    @EnvironmentObject var viewModel: FestivalListViewModel

    var body: some View {
        HStack {
            Image(uiImage: logoImage ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())  // Make the image a circle
                .redacted(reason: logoImage == nil ? .placeholder : [])
                .onAppear {
                    if logoImage == nil {
                        viewModel.fetchImage(for: festival.logoImage) { downloadedImage in
                            self.logoImage = downloadedImage
                        }
                    }
                }
            Text(festival.name)
                .fontDesign(.rounded)
                .redacted(reason: viewModel.isLoading ? .placeholder : [])
        }
    }
}

// MARK: - Preview Provider
#Preview {
    NavigationStack {
        FestivalListView()
            .environmentObject(FestivalListViewModel())
    }
}

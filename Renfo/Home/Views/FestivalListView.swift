import SwiftUI
import MessageUI

// MARK: - Home View
struct FestivalListView: View {
    @StateObject private var viewModel = FestivalListViewModel()
    @State private var isShowingMailView = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var showAlert = false

    // MARK: - View Body
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.sortedFestivals.keys.sorted(), id: \.self) { key in
                        Section(header: Text(key)) {
                            ForEach(viewModel.sortedFestivals[key] ?? []) { festival in
                                NavigationLink(destination: FestivalView(festival: festival)) {
                                    FestivalRow(festival: festival)
                                }
                            }
                        }
                    }
                    addFestivalFooter
                }
                .navigationTitle("Festivals")
                .searchable(text: $viewModel.searchText, prompt: "Search")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
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
        }
        .onAppear {
            viewModel.fetchFestivals()
        }
    }

    // MARK: - View Components
    private var sortMenu: some View {
        Menu {
            Text("Sort")
            Picker(selection: $viewModel.sortOption, label: Text("Sorting options")) {
                Label("Name", systemImage: "textformat").tag(SortOption.name)
                Label("State", systemImage: "map").tag(SortOption.state)
                Label("Active", systemImage: "calendar").tag(SortOption.active)
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

    var body: some View {
        HStack {
            if !festival.logoImage.isEmpty {
                Image(festival.logoImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            Text(festival.name)
        }
    }
}

// MARK: - Preview Provider
struct FestivalListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FestivalListView()
        }
    }
}

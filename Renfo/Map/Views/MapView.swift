import SwiftUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        MapViewRepresentable(viewModel: viewModel)
            .edgesIgnoringSafeArea(.top)
            .sheet(isPresented: $viewModel.showingFestivalView) {
                if let selectedFestival = viewModel.selectedFestival {
                    NavigationStack {
                        FestivalView(viewModel: FestivalViewModel(festival: selectedFestival, listViewModel: FestivalListViewModel()))
                    }
//                    .presentationDetents([.medium, .large])
                    .presentationDetents([.height(295), .large])
                }
            }
    }
}

// MARK: - Preview Provider
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

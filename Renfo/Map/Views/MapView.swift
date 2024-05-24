import SwiftUI

struct MapView: View {
    @State private var selectedFestival: FestivalModel?
    @State private var showingFestivalView = false

    var body: some View {
        MapViewRepresentable(selectedFestival: $selectedFestival, showingFestivalView: $showingFestivalView)
            .edgesIgnoringSafeArea(.top)
            .sheet(isPresented: $showingFestivalView) {
                if let selectedFestival = selectedFestival {
                    FestivalView(viewModel: FestivalViewModel(festival: selectedFestival))
                        .presentationDetents([
                            .medium,
                            .large
//                            .height(250),
//                            .fraction(0.5)
                        ])
                        .presentationDragIndicator(.visible)
                }
            }
    }
}

// MARK: - Preview Provider
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MapView()
        }
    }
}

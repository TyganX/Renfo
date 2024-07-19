import SwiftUI

struct MapSearch: View {
    let colors = ["Blue", "Cyan", "Teal", "Mint", "Green", "Yellow", "Orange", "Red", "Pink", "Purple", "Indigo"]
    
    var filteredColors: [String] { // 1
        if queryString.isEmpty {
            return colors
        } else {
            return colors.filter { $0.localizedCaseInsensitiveContains(queryString) }
        }
    }
    
    @State private var queryString = ""
    
    var body: some View {
        VStack {
            List(filteredColors, id: \.self) { color in // 2
                Text(color)
            }
        }
        .interactiveDismissDisabled()
        .presentationDetents([.height(100), .medium, .fraction(0.99)])
        .presentationBackground(.regularMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.99)))
//        .searchable(text: $queryString, prompt: "Color Search")
        .searchable(text: $queryString, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
    }
}

// MARK: - Preview Provider
struct MapSearch_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MapSearch()
        }
    }
}


//private var searchSheet: some View {
//    VStack(spacing: 0) {
//        HStack {
//            HStack {
//                Image(systemName: "magnifyingglass")
//                    .foregroundColor(.secondary)
//                TextField("Search Festivals", text: $searchText)
//                    .foregroundColor(.primary)
//                    .autocorrectionDisabled()
//            }
//            .padding(8)
//            .background(Color.gray.opacity(0.1))
//            .cornerRadius(10)
//            
//            Button(action: {
//                
//            }) {
//                Image(systemName: "person.crop.circle.fill")
//                    .resizable()
//                    .frame(width: 30, height: 30)
//                    .clipShape(Circle())
//                    .foregroundColor(.gray.opacity(0.8))
//            }
//        }
//        .padding(.horizontal)
//
//        
//        ScrollView {
//            VStack(spacing: 0) {
//                if sheetDetent != .fraction(0.1) {
//                    Divider()
//                    ForEach(firestoreService.festivals.filter { $0.name.contains(searchText) || searchText.isEmpty }.sorted(by: { $0.name < $1.name })) { festival in
//                        Button(action: {
//                            selectFestival(festival)
//                        }) {
//                            HStack(spacing: 12) {
//                                Text(festival.name)
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding()
//                            .background(Color.clear)
//                        }
//                        .foregroundColor(.primary)
//                        
//                        Divider()
//                    }
//                    .padding(.leading)
//                }
//            }
//        }
//        .padding(.top)
//    }
//    .padding(.top)
//    .interactiveDismissDisabled()
//    .presentationBackground(.regularMaterial)
//    .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.99)))
//}

import SwiftUI

struct ColoredButton: View {
    let systemImage: String
    let tint: Color
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .fontWeight(.bold)
                .padding(2)
                .frame(width: 18, height: 18)
                .foregroundStyle(tint)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.circle)
        .tint(tint)
    }
}

struct ColoredButton_Previews: PreviewProvider {
    static var previews: some View {
        // How to use button
        ColoredButton(systemImage: "xmark", tint: .red) {
            // Action for the button
            print("Button tapped")
        }
    }
}

// Old Button
//Button {
//    isSheetPresented = true
//} label: {
//    Image(systemName: "info")
//        .padding(1)
//        .fontWeight(.bold)
//}
//.buttonStyle(.borderedProminent)
//.buttonBorderShape(.circle)
//.tint(.blue.opacity(0.2))
//.foregroundStyle(.blue)
//.padding(10)

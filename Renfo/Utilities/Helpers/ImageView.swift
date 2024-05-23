import SwiftUI

struct ImageView: View {
    var imageName: String
    @State private var scale: CGFloat = 1.0
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var isZoomed: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .gesture(MagnificationGesture()
                        .onChanged { value in
                            let delta = value / self.lastScaleValue
                            self.lastScaleValue = value
                            self.scale *= delta
                        }
                        .onEnded { _ in
                            self.lastScaleValue = 1.0
                        }
                    )
                    .gesture(TapGesture(count: 2)
                        .onEnded {
                            withAnimation {
                                if isZoomed {
                                    scale = 1.0
                                } else {
                                    scale = 3.0
                                }
                                isZoomed.toggle()
                            }
                        }
                    )
            }
        }
    }
}

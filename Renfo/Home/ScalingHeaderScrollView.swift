import SwiftUI

struct ScalingHeaderScrollView<Content: View>: View {
    var content: Content
    var header: Image

    init(@ViewBuilder content: @escaping () -> Content, header: Image) {
        self.content = content()
        self.header = header
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    header
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: max(geometry.size.height / 2, 200))
                        .clipped()
                        .overlay(
                            GeometryReader { innerGeometry in
                                Color.clear
                                    .preference(key: ViewOffsetKey.self, value: innerGeometry.frame(in: .global).minY)
                            }
                        )
                    content
                }
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self, value: $0.size.height)
                })
            }
            .onPreferenceChange(ViewOffsetKey.self) { value in
                if value < 0 {
                    // Logic to scale the header
                }
            }
            .onPreferenceChange(ViewHeightKey.self) { value in
                // Logic to adjust content height
            }
        }
    }
}

private struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

private struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

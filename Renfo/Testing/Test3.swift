import SwiftUI

struct BottomSheet<Content: View>: View {
    @Binding var isOpen: Bool
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    @GestureState private var translation: CGFloat = 0

    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.secondary)
            .frame(
                width: 60,
                height: 6
            ).onTapGesture {
                withAnimation {
                    isOpen.toggle()
                }
            }
    }

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, minHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self._isOpen = isOpen
        self.maxHeight = maxHeight
        self.minHeight = minHeight
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
//            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
            .background(.ultraThinMaterial)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * 0.25
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    withAnimation {
                        self.isOpen = value.translation.height < 0
                    }
                }
            )
        }
    }
}

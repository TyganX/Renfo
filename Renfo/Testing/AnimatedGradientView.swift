import SwiftUI

struct AnimatedGradientView: View {
    let gradient = Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red])
    @State private var start = UnitPoint(x: 0, y: -1)
    @State private var end = UnitPoint(x: 1, y: 0)
    
    var body: some View {
        LinearGradient(gradient: gradient, startPoint: start, endPoint: end)
            .blur(radius: 50) // Add a blur effect
            .onAppear {
                withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                    self.start = UnitPoint(x: 1, y: 0)
                    self.end = UnitPoint(x: 0, y: 1)
                }
            }
    }
}

struct AnimatedGradientView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedGradientView()
    }
}

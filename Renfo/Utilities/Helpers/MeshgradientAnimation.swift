import SwiftUI

struct MeshgradientAnimation: View {
    @State private var isAnimating = false
    
    var body: some View {
        let colorsA: [Color] = [
            Color.yellow.opacity(0.7), Color.yellow.opacity(0.5), Color.yellow.opacity(0.1),
            Color.green.opacity(0.5), Color.green.opacity(0.5), Color.green.opacity(0.5),
            Color.blue.opacity(0.5), Color.blue.opacity(0.5), Color.blue.opacity(0.5)
        ]
        
        let colorsB: [Color] = [
//            Color.yellow.opacity(0.7), Color.yellow.opacity(0.7), Color.yellow.opacity(0.7),
            Color.orange.opacity(0.7), Color.orange.opacity(0.7), Color.orange.opacity(0.7),
            Color.green.opacity(0.1), Color.green.opacity(0.1), Color.green.opacity(0.1),
            Color.cyan.opacity(0.4), Color.cyan.opacity(0.8), Color.cyan.opacity(0.5)
//            Color.purple.opacity(0.4), Color.purple.opacity(0.8), Color.purple.opacity(0.5)
        ]
        
        let points: [SIMD2<Float>] = [
            SIMD2<Float>(0.0, 0.0), SIMD2<Float>(0.5, 0.0), SIMD2<Float>(1.0, 0.0),
            SIMD2<Float>(0.0, 0.5), SIMD2<Float>(0.5, 0.5), SIMD2<Float>(1.0, 0.5),
            SIMD2<Float>(0.0, 1.0), SIMD2<Float>(0.5, 1.0), SIMD2<Float>(1.0, 1.0)
        ]
        
        MeshGradient(
            width: 3,
            height: 3,
            points: points,
            colors: isAnimating ? colorsA : colorsB
        )
        .blendMode(.exclusion)
        .ignoresSafeArea()
        .background(Color.black)
        .onAppear {
            withAnimation(.easeInOut(duration: 5).repeatForever()) {
                isAnimating.toggle()
            }
        }
    }
}

struct MeshgradientAnimation_Previews: PreviewProvider {
    static var previews: some View {
        MeshgradientAnimation()
    }
}

import SwiftUI

struct ActiveIndicator: View {
    let isActive: Bool
    let daysUntilStart: Int?

    var body: some View {
        HStack {
            if isActive {
                PulsingView()
                    .foregroundColor(.green)
                    .frame(width: 10, height: 10)
            } else {
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 20, height: 20)
                    Text(daysUntilStart ?? 0 >= 0 ? "\(daysUntilStart!)" : "TBA")
                        .font(.system(size: 9))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

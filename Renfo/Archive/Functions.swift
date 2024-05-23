////
////  Functions.swift
////  Renfo
////
////  Created by Tyler Keegan on 4/30/24.
////
//
//import Foundation
//import SwiftUI
//import UIKit
//import SafariServices
//
//struct URLButton: View {
//    let label: String
//    let systemImage: String
//    let urlString: String
//
//    var body: some View {
//        Button(action: {
//            if let url = URL(string: urlString) {
//                UIApplication.shared.open(url)
//            }
//        }) {
//            Label(label, systemImage: systemImage)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//
//struct URLButtonCustom: View {
//    let label: String
//    let image: Image
//    let urlString: String
//
//    var body: some View {
//        Button(action: {
//            if let url = URL(string: urlString) {
//                UIApplication.shared.open(url)
//            }
//        }) {
//            Label {
//                Text(label)
//            } icon: {
//                image
//            }
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//
//// Custom button that opens a URL within the app
//struct URLButtonInApp: View {
//    let label: String
//    let systemImage: String
//    let urlString: String
//
//    @State private var showingSafariView = false
//
//    var body: some View {
//        Button(action: {
//            self.showingSafariView = true
//        }) {
//            HStack {
//                Label(label, systemImage: systemImage)
//                Spacer()
//            }
//        }
//        .buttonStyle(PlainButtonStyle())
//        .fullScreenCover(isPresented: $showingSafariView) {
//            if let url = URL(string: urlString) {
//                SafariView(url: url)
//                    .ignoresSafeArea()
//            }
//        }
//    }
//}
//
//struct SafariView: UIViewControllerRepresentable {
//    var url: URL
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
//        return SFSafariViewController(url: url)
//    }
//
//    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
//        // No action needed here.
//    }
//}
//
//// Custom view for displaying an image
//struct ImageView: View {
//    var imageName: String
//    @State private var scale: CGFloat = 1.0
//    @State private var lastScaleValue: CGFloat = 1.0
//    @State private var isZoomed: Bool = false
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ScrollView([.horizontal, .vertical], showsIndicators: false) {
//                Image(imageName)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .scaleEffect(scale)
//                    .frame(width: geometry.size.width, height: geometry.size.height)
//                    .gesture(MagnificationGesture()
//                        .onChanged { value in
//                            let delta = value / self.lastScaleValue
//                            self.lastScaleValue = value
//                            self.scale *= delta
//                        }
//                        .onEnded { _ in
//                            self.lastScaleValue = 1.0
//                        }
//                    )
//                    .gesture(TapGesture(count: 2)
//                        .onEnded {
//                            withAnimation {
//                                if isZoomed {
//                                    scale = 1.0
//                                } else {
//                                    scale = 3.0
//                                }
//                                isZoomed.toggle()
//                            }
//                        }
//                    )
//            }
//        }
//    }
//}
//
//func convertStringToDate(dateString: String) -> Date? {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "MM/dd/yyyy"
//    return dateFormatter.date(from: dateString)
//}
//
//func convertTimeString(timeString: String) -> String? {
//    let timeFormatter = DateFormatter()
//    timeFormatter.dateFormat = "HHmm"
//    guard let date = timeFormatter.date(from: timeString) else { return nil }
//    timeFormatter.dateFormat = "h:mm a"
//    return timeFormatter.string(from: date)
//}
//
//extension Date {
//    func formattedDateString() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM dd, yyyy" // Change to abbreviated month format
//        return formatter.string(from: self)
//    }
//}
//
//struct PulsingView: View {
//    @State private var isAnimating = false
//
//    var body: some View {
//        Circle()
//            .scaleEffect(isAnimating ? 1.3 : 1.0)
//            .opacity(isAnimating ? 0.5 : 1.0)
//            .onAppear {
//                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
//                    isAnimating = true
//                }
//            }
//    }
//}
//
//struct ImagePicker: UIViewControllerRepresentable {
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        let parent: ImagePicker
//
//        init(parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let uiImage = info[.originalImage] as? UIImage {
//                parent.image = uiImage
//            }
//
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//    }
//
//    @Environment(\.presentationMode) var presentationMode
//    @Binding var image: UIImage?
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//}

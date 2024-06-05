import SwiftUI
import PDFKit

struct ImagePDFViewer: UIViewRepresentable {
    let imageName: String

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.backgroundColor = UIColor.clear

        if let image = UIImage(named: imageName) {
            // Create a new image with a black background
            let rect = CGRect(origin: .zero, size: image.size)
            UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(UIColor(.primary).cgColor)
            context?.fill(rect)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            // Convert the new image to a PDF page
            let pdfDocument = PDFDocument()
            if let newImage = newImage {
                let pdfPage = PDFPage(image: newImage)
                pdfDocument.insert(pdfPage!, at: 0)
            }
            pdfView.document = pdfDocument
        }

        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // No update needed
    }
}

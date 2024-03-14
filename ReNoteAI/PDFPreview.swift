import PDFKit

func generatePDFPreview(url: URL) -> UIImage? {
    guard let pdfDocument = PDFDocument(url: url),
          let page = pdfDocument.page(at: 0) else {
        return nil
    }

    let pageSize = page.bounds(for: .mediaBox)
    let pdfScale = 200 / pageSize.width // Adjust scale to your preference
    let scaledPageSize = CGSize(width: pageSize.width * pdfScale, height: pageSize.height * pdfScale)
    let renderer = UIGraphicsImageRenderer(size: scaledPageSize)

    let img = renderer.image { ctx in
        UIColor.white.set()
        ctx.fill(CGRect(origin: .zero, size: scaledPageSize))

        ctx.cgContext.translateBy(x: 0, y: scaledPageSize.height)
        ctx.cgContext.scaleBy(x: pdfScale, y: -pdfScale)
        page.draw(with: .mediaBox, to: ctx.cgContext)
    }

    return img
}

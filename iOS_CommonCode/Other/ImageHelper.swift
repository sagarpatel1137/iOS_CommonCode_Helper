//
//  ImageHelper.swift
//  iOS_CommonCode
//
//  Created by IOS on 04/11/24.
//

import UIKit
import SVGKit
import PDFKit

public class ImageHelper {
    
    private static let imageCache = NSCache<NSString, UIImage>()
    
    static public func image(named: String, fallbackBundle bundle: Bundle? = nil) -> UIImage? {
        
        // Check cache
        if let cachedImage = imageCache.object(forKey: named as NSString) {
            return cachedImage
        }
        
        let imageExtensions = ["png", "jpg", "jpeg", "gif", "pdf", "svg"]
        
        // Check main bundle first
        if let mainImage = UIImage(named: named, in: .main, compatibleWith: nil) {
            imageCache.setObject(mainImage, forKey: named as NSString)
            return mainImage
        }
        
        // Check fallback bundle if provided
        if let bundle = bundle, let fallbackImage = UIImage(named: named, in: bundle, compatibleWith: nil) {
            imageCache.setObject(fallbackImage, forKey: named as NSString)
            return fallbackImage
        }
        
        // Load image with specified extensions
        for ext in imageExtensions {
            if let url = Bundle.main.url(forResource: named, withExtension: ext) {
                do {
                    let data = try Data(contentsOf: url)
                    var img: UIImage?
                    
                    switch ext {
                    case "svg":
                        img = loadSVGImage(fromData: data)
                    case "pdf":
                        img = loadPDFImage(fromURL: url)
                    default:
                        img = UIImage(data: data)
                    }
                    
                    if let finalImage = img {
                        imageCache.setObject(finalImage, forKey: named as NSString)
                        return finalImage
                    }
                    
                } catch {
                    print("Failed to load image: \(error)")
                    return nil
                }
            }
        }
        
        return nil
    }
    
    private static func loadSVGImage(fromData data: Data) -> UIImage? {
#if canImport(SVGKit)
        if let svgImage = SVGKImage(data: data) {
            return svgImage.uiImage
        }
#endif
        return nil
    }
    
    private static func loadPDFImage(fromURL url: URL) -> UIImage? {
        guard let pdfDocument = PDFDocument(url: url), let page = pdfDocument.page(at: 0) else {
            return nil
        }
        
        // Define the desired output size and scale
        let pdfPageBounds = page.bounds(for: .mediaBox)
        let scale = UIScreen.main.scale
        let imageSize = CGSize(width: pdfPageBounds.width * scale, height: pdfPageBounds.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Draw the PDF page into the context
        context.saveGState()
        context.translateBy(x: 0, y: imageSize.height)
        context.scaleBy(x: scale, y: -scale)
        page.draw(with: .mediaBox, to: context)
        context.restoreGState()
        
        let pdfImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return pdfImage
    }
}

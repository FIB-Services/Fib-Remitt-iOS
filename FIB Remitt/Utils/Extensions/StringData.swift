//
//  StringData.swift
//  FIB Remitt
//
//  Created by Raihan on 30/1/24.
//

import UIKit

extension Optional where Wrapped == String {
    var isBlankOrEmptyOrNil: Bool {
        return self?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }
}

extension String {
    var isBlankOrEmpty: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    //Generate from String
    func getQRCodeDate() -> Data? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = self.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()!
    }
    
    func extractFileName() -> String {
        if let url = URL(string: self) {
            return url.lastPathComponent.removingPercentEncoding ?? ""
        }
        return ""
    }
}

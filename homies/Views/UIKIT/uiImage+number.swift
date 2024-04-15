//
//  uiImage+number.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/26/23.
//

import Foundation
import UIKit

extension UIImage {
    convenience init?(number: Int, font: UIFont = UIFont.systemFont(ofSize: 5)) {
        let threshold = 1200
        let color = number>threshold ? UIColor.red : UIColor.blue
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color
        ]

        let string = "$\(number)"
        let size = string.size(withAttributes: attributes)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        string.draw(at: CGPoint.zero, withAttributes: attributes)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }

        UIGraphicsEndImageContext()

        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }
}

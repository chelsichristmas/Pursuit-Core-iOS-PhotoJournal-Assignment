//
//  UIImage+Extensions.swift
//  Photo-Journal
//
//  Created by Chelsi Christmas on 4/30/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
      let size = CGSize(width: width, height: height)
      let renderer = UIGraphicsImageRenderer(size: size)
      return renderer.image { (context) in
        self.draw(in: CGRect(origin: .zero, size: size))
      }
    }
}

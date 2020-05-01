//
//  ImageObject.swift
//  Photo-Journal
//
//  Created by Chelsi Christmas on 1/27/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import Foundation

struct EntryObject: Codable {
  let imageData: Data
  let date: Date
  let identifier = UUID().uuidString
    let caption: String?
}

//
//  FileManager.swift
//  Photo-Journal
//
//  Created by Chelsi Christmas on 1/27/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import Foundation

extension FileManager {
  
  static func getDocumentsDirectory() -> URL  {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  
  
  static func pathToDocumentsDirectory(with filename: String) -> URL {
    return getDocumentsDirectory().appendingPathComponent(filename)
  }
}

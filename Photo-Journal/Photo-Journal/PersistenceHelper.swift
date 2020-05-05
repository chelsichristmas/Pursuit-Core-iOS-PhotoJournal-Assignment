//
//  PersistenceHelper.swift
//  Photo-Journal
//
//  Created by Chelsi Christmas on 1/27/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import Foundation

enum DataPersistenceError: Error { // conforming to the Error protocol
  case savingError(Error) // associative value
  case fileDoesNotExist(String)
  case noData
  case decodingError(Error)
  case deletingError(Error)
}

class PersistenceHelper {
  
  
  private var items = [EntryObject]()
  
  private var filename: String
  
  init(filename: String) {
    self.filename = filename
  }
  
  public func save() throws {
    
     let url = FileManager.pathToDocumentsDirectory(with: filename)
    
    
    do {
      
      let data = try PropertyListEncoder().encode(items)
      
      
      try data.write(to: url, options: .atomic)
    } catch {
      
      throw DataPersistenceError.savingError(error)
    }
  }
  
  
  
  
    public func create(item: EntryObject) throws {
    
    items.insert(item, at: 0)
    
    do {
      try save()
    } catch {
      throw DataPersistenceError.savingError(error)
    }
  }

  
    
    public func sync(items: [EntryObject]) {
      self.items = items
      try? save()
    }
    
    public func saveEdit(item: EntryObject, index: Int) throws {
      
      items.insert(item, at: index)
      
      do {
        try save()
      } catch {
        throw DataPersistenceError.savingError(error)
      }
    }


    
    
    
  public func loadItems() throws -> [EntryObject] {
    
    let url = FileManager.pathToDocumentsDirectory(with: filename)
    
    
    if FileManager.default.fileExists(atPath: url.path) {
      if let data = FileManager.default.contents(atPath: url.path) {
        do {
          items = try PropertyListDecoder().decode([EntryObject].self, from: data)
        } catch {
          throw DataPersistenceError.decodingError(error)
        }
      } else {
        throw DataPersistenceError.noData
      }
    }
    else {
      throw DataPersistenceError.fileDoesNotExist(filename)
    }
    return items
  }
  
  
  public func delete(item index: Int) throws {
    
    items.remove(at: index)
    
    
    do {
      try save()
    } catch {
      throw DataPersistenceError.deletingError(error)
    }
  }
    
    public func update() {
        
    }
}

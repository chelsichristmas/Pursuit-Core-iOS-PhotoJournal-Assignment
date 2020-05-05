//
//  ViewController.swift
//  Photo-Journal
//
//  Created by Chelsi Christmas on 1/27/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit
import AVFoundation

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
        
    private var entryObjects = [EntryObject]()
      
      
    
    private let dataPersistence = PersistenceHelper(filename: "images.plist")
    
      public var selectedImage: UIImage? {
          didSet {
              
          }
      }
      
    private var selectedIndexPath: Int?
      //private let imagesVC = ImagesViewController()
      
      private var delegate: CreateEntryDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadEntryObjects()
        
        collectionView.reloadData()
        print(entryObjects.count)

    }
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
  }
    
  
  private func loadEntryObjects() {
    do {
      entryObjects = try dataPersistence.loadItems()
    } catch {
      print("loading objects error: \(error)")
    }
  }
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let createEntryVC = segue.destination as! CreateEntryViewController
        if segue.identifier == "editSegue" {
            

            
            guard let indexPath = selectedIndexPath else {
                return
            }
            createEntryVC.entry = self.entryObjects[indexPath]
            createEntryVC.eventIndex = indexPath
        
        }
   
    }
    
}


extension ImagesViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return entryObjects.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "entryCell", for: indexPath) as? EntryCell else {
      fatalError("could not downcast to an ImageCell")
    }
    let entryObject = entryObjects[indexPath.row]
    cell.configureCell(entryObject: entryObject)
    
    cell.delegate = self

    return cell
  }
    
    
}


extension ImagesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let maxWidth: CGFloat = UIScreen.main.bounds.size.width
    let itemWidth: CGFloat = maxWidth * 0.80
    return CGSize(width: itemWidth, height: itemWidth)  }
}


extension ImagesViewController: EntryCellDelegate {
  func didLongPress(_ imageCell: EntryCell) {
    
    guard let indexPath = collectionView.indexPath(for: imageCell) else {
      return
    }
    
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] alertAction in
      self?.deleteImageObject(indexPath: indexPath)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    alertController.addAction(deleteAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true)
  }
  
  private func deleteImageObject(indexPath: IndexPath) {
    dataPersistence.sync(items: entryObjects)
    do {
      entryObjects = try dataPersistence.loadItems()
    } catch {
      print("loading error: \(error)")
    }
    
    
    entryObjects.remove(at: indexPath.row)
    
    
    collectionView.deleteItems(at: [indexPath])
    
    do {
      
      try dataPersistence.delete(item: indexPath.row)
    } catch {
      print("error deleting item: \(error)")
    }
  }
    
    func pressedEditButton(_ cell: UICollectionViewCell, editButtonTapped: UIButton) {
        
        guard let indexPath = self.collectionView.indexPath(for: cell) else { fatalError("Unable to access index path")
            
        }
        
        selectedIndexPath = indexPath.row
       
    }
}

extension ImagesViewController: CreateEntryDelegate {
    func createdEntry(_ entry: EntryObject) {
        
        collectionView.reloadData()
        loadEntryObjects()
        
    }
    
    
    
}




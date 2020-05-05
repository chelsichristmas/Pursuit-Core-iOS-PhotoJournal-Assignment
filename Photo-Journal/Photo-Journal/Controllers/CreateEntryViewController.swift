//
//  CreateEntryViewController.swift
//  Photo-Journal
//
//  Created by Chelsi Christmas on 4/29/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit
import AVFoundation

protocol CreateEntryDelegate: AnyObject {
    func createdEntry(_ entry: EntryObject)
}
class CreateEntryViewController: UIViewController {
    
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postTextView: UITextView!
    
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var createAndSaveButton: UIBarButtonItem!
    
    
    weak var delegate: CreateEntryDelegate?
    
    private let dataPersistence = PersistenceHelper(filename: "images.plist")
    
    public var entry: EntryObject? {
        didSet {
       configureEditViewController()
        }
    }
    
    
    private var entryObjects = [EntryObject]()
    
    private let imagePickerController = UIImagePickerController()
    
    public var selectedImage: UIImage? {
        didSet {
            postImageView.image = selectedImage

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        
        loadEntryObjects()
                
    }
    
    private func loadEntryObjects() {
      do {
        entryObjects = try dataPersistence.loadItems()
      } catch {
        print("loading objects error: \(error)")
      }
    }
    
    private func configureEditViewController() {
        guard let entry = entry else {
                   fatalError("No entry object")
               }
        DispatchQueue.main.async {
                       self.postImageView.image = UIImage(data: entry.imageData)
                       
                       self.photoLibraryButton.isEnabled = false
                       self.cameraButton.isEnabled = false
                       self.createAndSaveButton.title = "Save"
            
            self.postImageView.alpha = 0.6
                   }
    }
    
    
    @IBAction func pressedPhotoLibrary(_ sender: Any) {
        
        showImageController(isCameraSelected: false)
    }
    
    
    @IBAction func pressedCameraButton(_ sender: Any) {
        
        showImageController(isCameraSelected: true)
    }
    
    
    
    private func showImageController(isCameraSelected: Bool) {
        
        imagePickerController.sourceType = .photoLibrary
        
        if isCameraSelected {
            imagePickerController.sourceType = .camera
        }
        present(imagePickerController, animated: true)
    }
    
    


@IBAction func createButtonPressed(_ sender: UIBarButtonItem) {
    
    if entry == nil {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    alertController.addAction(cancelAction)
    alertController.message = "Your post is missing a photo!"
        
    if let _ = selectedImage {
        
        appendNewPhotoToCollection()
        guard let entry = entry else { return }
        delegate?.createdEntry(entry)
        
        self.navigationController?.popViewController(animated: true)
    } else {
        present(alertController, animated: true)
    }
    } else {
        // update function
        
    }
    
    
}

 
private func appendNewPhotoToCollection() {
    
   
    guard let image = selectedImage else {
        print("image is nil")
        return
    }
    
    print("original image size is \(image.size)")
    
    
    let size = UIScreen.main.bounds.size
    
    
    let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
    
    
    let resizeImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
    
    print("resized image size is \(resizeImage.size)")
    
    
    guard let resizedImageData = resizeImage.jpegData(compressionQuality: 1.0) else {
        return
    }
    
    var caption: String?
    if postTextView.text == "Write a caption..." || postTextView.text == "" {
        caption = nil
    } else {
        caption = postTextView.text
    }
    let entryObject = EntryObject(imageData: resizedImageData, date: Date(), caption: caption)
    
    entryObjects.insert(entryObject, at: 0)
    
    print(" Entry Objects Count: \(entryObjects.count)")
   
    
    entry = entryObject
    delegate?.createdEntry(entryObject)
    do {
          try dataPersistence.create(item: entryObject)
      } catch {
          print("saving error: \(error)")
      }

  
}

}


extension CreateEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
      print("image selected not found")
      return
    }
    
    selectedImage = image
    
    dismiss(animated: true)
  }
}

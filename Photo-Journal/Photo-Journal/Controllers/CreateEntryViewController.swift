//
//  CreateEntryViewController.swift
//  Photo-Journal
//
//  Created by Chelsi Christmas on 4/29/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit
import AVFoundation

protocol CreateEntryDelegate {
    func createdEntry(_ entry: EntryObject)
}
class CreateEntryViewController: UIViewController {
    
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postTextView: UITextView!
    
    var delegate: CreateEntryDelegate?
    private let dataPersistence = PersistenceHelper(filename: "images.plist")
    private var entry: EntryObject?
    
    private var entryObjects = [EntryObject]()
    
    private let imagePickerController = UIImagePickerController()
    
    private var selectedImage: UIImage? {
        didSet {
            postImageView.image = selectedImage

        }
    }
    
    
    private lazy var tapImageGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(tappedImage(_gesture:)))
        return gesture
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        postImageView.addGestureRecognizer(tapImageGesture)
        
    }
    
    
    
    @objc private func tappedImage(_gesture: UITapGestureRecognizer) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] alertAction in
            self?.showImageController(isCameraSelected: true)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] alertAction in
            self?.showImageController(isCameraSelected: false)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func showImageController(isCameraSelected: Bool) {
        
        imagePickerController.sourceType = .photoLibrary
        
        if isCameraSelected {
            imagePickerController.sourceType = .camera
        }
        present(imagePickerController, animated: true)
    }
    
    


@IBAction func createButtonPressed(_ sender: UIBarButtonItem) {
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
    
    
    entry = entryObject
    
    do {
          try dataPersistence.create(item: entryObject)
      } catch {
          print("saving error: \(error)")
      }
//    entryObjects.insert(entryObject, at: 0)
    
  
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

//
//  ImageCell.swift
//  Photo-Journal
//
//  Created by Chelsi Christmas on 1/27/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit


protocol EntryCellDelegate: AnyObject {
    func didLongPress(_ imageCell: EntryCell)
    func pressedEditButton(_ cell: UICollectionViewCell, editButtonTapped: UIButton)
       
}

class EntryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: EntryCellDelegate?
    
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(longPressAction(gesture:)))
        return gesture
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20.0
        backgroundColor = .systemGroupedBackground
        
        
        addGestureRecognizer(longPressGesture)
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        
        self.delegate?.pressedEditButton(self, editButtonTapped: sender)
    }
    @objc
    private func longPressAction(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began { // if gesture is actived
            gesture.state = .cancelled
            return
        }
    
        delegate?.didLongPress(self)
       
    }
    
    public func configureCell(entryObject: EntryObject) {
        // converting Data to UIImage
//        guard let image = UIImage(data: entryObject.imageData) else {
//            return
//        }
        imageView.image = UIImage(data: entryObject.imageData)
        
        if let caption = entryObject.caption {
            captionLabel.text = caption
        } else {
            captionLabel.text = ""
        }
        
        dateLabel.text = ""
        
        
    }
}



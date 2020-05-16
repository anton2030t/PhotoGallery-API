//
//  ImageCollectionViewCell.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 16.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    var task: URLSessionDataTask?
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var collectionActivityIndicator: UIActivityIndicatorView!
    
    static let identifier = "ImageCollectionViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        collectionActivityIndicator.startAnimating()
        collectionImageView.backgroundColor = .systemGroupedBackground
        
        collectionImageView.image = nil
        isHidden = false
        isSelected = false
        isHighlighted = false
        
        task?.cancel()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}

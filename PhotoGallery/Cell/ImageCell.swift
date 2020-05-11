//
//  ImageCell.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 10.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var urlLabel: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let identifier = "ImageCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        activityIndicator.startAnimating()
        myImageView.backgroundColor = .systemGroupedBackground
        
        myImageView.image = nil
        isHidden = false
        isSelected = false
        isHighlighted = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func urlButton(_ sender: UIButton) {
        let webVC = WebViewController()
        webVC.publicUrl = urlLabel.titleLabel?.text
        self.window?.rootViewController?.present(webVC, animated: true, completion: nil)
    }
    
}

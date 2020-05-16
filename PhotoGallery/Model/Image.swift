//
//  Image.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 09.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

final class Image: Codable {
    let id: String
    let author: String
    let downloadURL: String
    let url: String
    
    var delegate: DetailViewControllerDelegate?
    
    var image: UIImage? {
        didSet {
            self.delegate?.update(with: image!)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case author = "author"
        case downloadURL = "download_url"
        case url = "url"
    }
}

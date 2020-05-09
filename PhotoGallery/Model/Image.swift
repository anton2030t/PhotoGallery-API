//
//  Image.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 09.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation

struct Image: Codable {
    let author: String
    let downloadURL: String
    
    enum CodingKeys: String, CodingKey {
      case author = "author"
      case downloadURL = "download_url"
    }
}

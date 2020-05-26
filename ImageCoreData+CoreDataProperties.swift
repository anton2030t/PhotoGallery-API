//
//  ImageCoreData+CoreDataProperties.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 17.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageCoreData> {
        return NSFetchRequest<ImageCoreData>(entityName: "ImageCoreData")
    }

    @NSManaged public var id: String?
    @NSManaged public var author: String?
    @NSManaged public var downloadURL: String?
    @NSManaged public var url: String?
    @NSManaged public var image: Data?

}

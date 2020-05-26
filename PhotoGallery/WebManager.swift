//
//  WebManager.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 05.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class WebManager {
    
    func baseURL(page: Int) -> String {
        return "https://picsum.photos/v2/list?page=\(page)&limit=20"
    }
    
    func loadData(with page: Int, completion: @escaping ([Image])->()) {
        guard let url = URL(string: baseURL(page: page)) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let images = try JSONDecoder().decode([Image].self, from: data)
                completion(images)
            } catch let error {
                print(error)
            }
            
        }.resume()
    }
    
    private func save(for data: Image, with image: UIImage, completion: @escaping (String) -> Void) {
      DispatchQueue.main.async {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        guard let entity = NSEntityDescription.entity(forEntityName: "ImageCoreData", in: context),
          let imageCoreDataObject = NSManagedObject(entity: entity, insertInto: context) as? ImageCoreData,
            let imageData = image.jpegData(compressionQuality: 1.0) as Data? else { return }

        imageCoreDataObject.id = data.id
        imageCoreDataObject.author = data.author
        imageCoreDataObject.url = data.url
        imageCoreDataObject.downloadURL = data.downloadURL
        imageCoreDataObject.image = imageData

        do {
          try context.save()
          completion(data.id)
        } catch {
          print("Error = \(error.localizedDescription)")
        }
      }
    }
    
    
//    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
//    do {
//        let results = try self.managedObjectContext.executeFetchRequest(fetchRequest)
//        for result in results as! [NSManagedObject] {
//            print("name - \(result.valueForKey("name")!)")
//        }
//    } catch {
//        print(error)
//    }
//    
//    
//    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
//    do {
//        let results = try self.managedObjectContext.executeFetchRequest(fetchRequest)
//        for result in results as! [Customer] {
//            print("name - \(result.name!)")
//        }
//    } catch {
//        print(error)
//    }
    
    
}

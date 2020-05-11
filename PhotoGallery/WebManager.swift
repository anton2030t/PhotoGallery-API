//
//  WebManager.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 05.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation
import UIKit

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
    
}

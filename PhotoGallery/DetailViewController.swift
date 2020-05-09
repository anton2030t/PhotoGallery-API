//
//  DetailViewController.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 07.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var imageScrollView: ImageScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollView()
        
        
        let imagePath = Bundle.main.path(forResource: "cars", ofType: "jpg")!
        let image = UIImage(contentsOfFile: imagePath)!
        
        self.imageScrollView.set(image: image)
        
    }
    
    func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

}

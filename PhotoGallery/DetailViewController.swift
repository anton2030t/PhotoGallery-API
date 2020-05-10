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
    
    public var publicImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollView()
        
        let image = UIImage(named: "oops")!
        // Как сделать чтобы при появлении "oops" (т.е. пока картинка не загрузилась),
        // на Detail автоматически поменялась картинка на скачанную вместо "oops"?
        self.imageScrollView.set(image: publicImage ?? image)
    }
    
    func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

}

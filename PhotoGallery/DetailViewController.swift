//
//  DetailViewController.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 07.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: class {
    func update(with image: UIImage)
}

class DetailViewController: UIViewController {
        
    var imageScrollView: ImageScrollView!
    
    var publicImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollView()
        
        let oopsImage = UIImage(named: "oops")!
        
        imageScrollView.set(image: publicImage ?? oopsImage)

    }
    
    func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

}

extension DetailViewController: DetailViewControllerDelegate {
    func update(with image: UIImage) {
        guard isViewLoaded else { return }
        imageScrollView.set(image: image)
    }
}

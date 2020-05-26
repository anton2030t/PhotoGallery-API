//
//  CollectionViewController.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 16.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    var images = [Image]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let webManager = WebManager()
    
    var pageCounter = 1
    var isEmpty = false
    
    var currentIndexPath: IndexPath?
    let pressedDownTransform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: ImageCollectionViewCell.identifier, bundle: Bundle.main), forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        
        response()
        
        setUpGR()
        setUpGR2()
        
    }
    
    func response() {
        guard (isEmpty == false) else { return }
        webManager.loadData(with: pageCounter) { [weak self] (images) in
            if images.count != 0 {
                self?.images += images
                self?.pageCounter += 1
            } else {
                self?.isEmpty = true
            }
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.collectionView)
            
            if let index = collectionView.indexPathForItem(at: touchPoint)  {
                
                let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let delete = UIAlertAction(title: "Delete", style: .destructive) {
                    (action: UIAlertAction) -> Void in
                    
                    let alertC = UIAlertController(title: nil, message: "Delete?", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .destructive) { (action) in
                        
                        self.collectionView.performBatchUpdates({
                            self.images.remove(at: index.item)
                            self.collectionView.deleteItems(at: [index])
                        }, completion: nil)
                        
                    }
                    alertC.addAction(ok)
                    let back = cancel
                    alertC.addAction(back)
                    self.present(alertC, animated: true, completion: nil)
                    
                }
                
                ac.addAction(cancel)
                present(ac, animated: true, completion: nil)
                ac.addAction(delete)
            }
        }
    }
    
    @objc func didTapLongPress(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)
        
        if sender.state == .began, let indexPath = indexPath, let cell = collectionView.cellForItem(at: indexPath) {
            
            animate(cell, to: pressedDownTransform)
            self.currentIndexPath = indexPath
        } else if sender.state == .changed {
            
            if indexPath != self.currentIndexPath, let currentIndexPath = self.currentIndexPath, let cell = collectionView.cellForItem(at: currentIndexPath) {
                if cell.transform != .identity {
                    animate(cell, to: .identity)
                }
            } else if indexPath == self.currentIndexPath, let indexPath = indexPath, let cell = collectionView.cellForItem(at: indexPath) {
                if cell.transform != pressedDownTransform {
                    animate(cell, to: pressedDownTransform)
                }
            }
        } else if let currentIndexPath = currentIndexPath, let cell = collectionView.cellForItem(at: currentIndexPath) {
            
            animate(cell, to: .identity)
            self.currentIndexPath = nil
        }
    }
    
}

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        let imageModel = images[indexPath.item]
        let url = URL(string: imageModel.downloadURL)!
        
        func setupCell(image: UIImage) {
            cell.collectionImageView.backgroundColor = .none
            cell.collectionImageView.image = image
            cell.collectionActivityIndicator.stopAnimating()
        }
        
        if let image = imageModel.image {
            setupCell(image: image)
        } else {
            cell.task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
                if let data = data, let imageData = UIImage(data: data) {
                    DispatchQueue.main.async {
                        setupCell(image: imageData)
                        imageModel.image = imageData
                    }
                }
            }
            cell.task?.resume()
            
        }
        
        if indexPath.row == images.count - 1 {
            response()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageModel = images[indexPath.item]
        let vc = DetailViewController()
        vc.publicImage = imageModel.image
        imageModel.delegate = vc
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = collectionView.frame.size.width - 80
        let scaleFactor = screenWidth / 3
        
        return CGSize(width: scaleFactor, height: scaleFactor)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}

private extension CollectionViewController {
    func setUpGR() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        collectionView.addGestureRecognizer(longPressRecognizer)
    }
    
    func setUpGR2() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didTapLongPress))
        longPressRecognizer.minimumPressDuration = 0.05
        longPressRecognizer.cancelsTouchesInView = false
        //        longPressRecognizer.delegate = self
        collectionView.addGestureRecognizer(longPressRecognizer)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func animate(_ cell: UICollectionViewCell, to transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        cell.transform = transform
        }, completion: nil)
    }
    
}

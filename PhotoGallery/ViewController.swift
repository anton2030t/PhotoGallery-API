//
//  ViewController.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 05.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    var images = [Image]()
    var myImage: UIImage?
    
    @IBOutlet weak var tableView: UITableView!
    
    private let webManager = WebManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        response()
        
        //   Вынеси добавление GR в отдельные методы. Не нужно заполнять viewDidLoad
        //   Для удобства делаешь extension с пометкой private и туда заносишь методы.
        //   Либо внутри самого класса создаешь private методы
        setUpGR()
    }
    
    func response() {
        webManager.loadData(with: 1) { [weak self] (images) in
            self?.images += images
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let index = tableView.indexPathForRow(at: touchPoint)  {
                
                let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let delete = UIAlertAction(title: "Delete", style: .destructive) {
                    (action: UIAlertAction) -> Void in
                    
                    let alertC = UIAlertController(title: nil, message: "Delete?", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .destructive) { (action) in

                        self.tableView.performBatchUpdates({
                            self.images.remove(at: index.row)
                            self.tableView.deleteRows(at: [index], with: .automatic)
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
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        let image = images[indexPath.row]
        let url = URL(string: image.downloadURL)!

        cell?.imageView?.kf.setImage(with: url)
        cell?.imageView?.contentMode = .scaleAspectFill
        
        return cell!

    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // detail image
        let vc = DetailViewController()
        vc.imageModel = images[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

private extension ViewController {
    func setUpGR() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        tableView.addGestureRecognizer(longPressRecognizer)
    }
}

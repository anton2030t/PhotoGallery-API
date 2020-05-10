//
//  ViewController.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 05.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var images = [Image]()
    let cellHeight = ImageCell()
    
    @IBOutlet weak var tableView: UITableView!
    
    private let webManager = WebManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: ImageCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: ImageCell.identifier)
        
        response()
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.identifier) as! ImageCell
        let imageModel = images[indexPath.row]
        let url = URL(string: imageModel.downloadURL)!

        URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.myImageView.image = UIImage(data: data)
                    imageModel.image = UIImage(data: data)
                }
            }
        }.resume()
        
        cell.authorLabel.text = imageModel.author
        cell.urlLabel.setTitle(imageModel.url, for: .normal)
        cell.urlLabel.titleLabel?.lineBreakMode = .byWordWrapping
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Здесь я хотел сделать автоматическое вычисление
        // высоты ячейки по высоте картинки
        // но код ниже не работает, точнее ставится 300 просто.
        var heightCell: CGFloat?
        
        if heightCell == nil {
            heightCell = 300
        } else {
            heightCell = cellHeight.myImageView.image?.size.height

        }
        
        return heightCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let imageModel = images[indexPath.row]
        let vc = DetailViewController()
        vc.publicImage = imageModel.image
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

private extension ViewController {
    func setUpGR() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        tableView.addGestureRecognizer(longPressRecognizer)
    }
}

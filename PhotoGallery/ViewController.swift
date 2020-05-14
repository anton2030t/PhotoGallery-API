//
//  ViewController.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 05.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var delegate: DetailViewControllerDelegate?
    
    var images = [Image]()
    
    @IBOutlet weak var tableView: UITableView!
    
    private let webManager = WebManager()
    
    var pageCounter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: ImageCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: ImageCell.identifier)
        
        response()
        
        setUpGR()

    }
    
    func response() {
        webManager.loadData(with: pageCounter) { [weak self] (images) in
            //Я тебе обозначил, что нужно прекращать загрузку, когда у нас данные уже не приходят.
            //Здесь это никак не обрабатывается
            self?.images += images
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                if images.count != 0 {
                    self?.pageCounter += 1
                }
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
        
        if let image = imageModel.image {
            //#1 Одинаковый код
            cell.myImageView.backgroundColor = .none
            cell.myImageView?.image = image
            cell.activityIndicator.stopAnimating()
            cell.authorLabel.text = imageModel.author
            cell.urlModel = imageModel.url
            cell.urlLabel.setTitle(cell.urlModel, for: .normal)
        } else {
            // [weak self] здесь
            cell.task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
                if let data = data, let imageData = UIImage(data: data) {
                    DispatchQueue.main.async {
                        //#1 Одинаковый код
                        //Здесь только картинку выставляй, а все остальное вынеси за запрос
                        cell.myImageView.backgroundColor = .none
                        cell.myImageView.image = imageData
                        cell.activityIndicator.stopAnimating()
                        cell.authorLabel.text = imageModel.author
                        cell.urlModel = imageModel.url
                        cell.urlLabel.setTitle(cell.urlModel, for: .normal)
                        imageModel.image = imageData
                        
                        self.delegate?.update(with: imageData)
                    }
                }
            }
            cell.task?.resume()
            
        }
        
        //Не надо использовать unowned. Пользуйся опционалами. unowned - риск краша.
        cell.webButton = { [unowned self] in
            let vc = WebViewController()
            if cell.urlModel != nil {
                vc.publicUrl = cell.urlModel
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        if indexPath.row == images.count - 1 {
            response()
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let imageModel = images[indexPath.row]
        let vc = DetailViewController()
        vc.publicImage = imageModel.image
        delegate = vc
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
}

private extension ViewController {
    func setUpGR() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        tableView.addGestureRecognizer(longPressRecognizer)
    }
}

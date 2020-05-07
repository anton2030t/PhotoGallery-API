//
//  ViewController.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 05.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dataArray = [[String:AnyObject]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        tableView.addGestureRecognizer(longPressRecognizer)
        
        
        let url = URL(string: "https://picsum.photos/v2/list?page=1&limit=20")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String:Any]] {
                    
                    self.dataArray = json as [[String : AnyObject]]
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print(json)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
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
                            self.dataArray.remove(at: index.row)
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
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if let urlString = dataArray[indexPath.row]["download_url"] as? String, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        cell?.imageView!.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
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
    }
    
}

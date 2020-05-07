//
//  MVVMViewModel.swift
//  PhotoGallery
//
//  Created by Артем Бурдейный on 07.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation

protocol MVVMViewModelDelegate: class {
    func didDownloadData()
}

final class MVVMViewModel {
    
    weak var delegate: MVVMViewModelDelegate?
    private let webManager = WebManager()
    private var modelList: [MVVMModel]?
    
    func viewDidLoad() {
        loadData { [weak self] in
            self?.delegate?.didDownloadData()
        }
    }
    
    private func loadData(completion: ()->()) {
        //webManager loadData c completion и моделькой внутри
        //self.modelList = modelList
        completion()
    }
}

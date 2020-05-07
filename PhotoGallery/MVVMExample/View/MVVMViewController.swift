//
//  MVVMViewController.swift
//  PhotoGallery
//
//  Created by Артем Бурдейный on 07.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

final class MVVMViewController: UIViewController {

    let viewModel = MVVMViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewModel()
        viewModel.viewDidLoad()
    }
    
    private func setUpViewModel() {
        viewModel.delegate = self
    }
}

//MARK: - MVVMViewModelDelegate

extension MVVMViewController: MVVMViewModelDelegate {
    func didDownloadData() {
        //обновляем таблицу, присваиваем данные и тд
    }
}

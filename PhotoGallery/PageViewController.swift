//
//  PageViewController.swift
//  PhotoGallery
//
//  Created by Антон Ларченко on 16.05.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var index = 0
    var identifiers: NSArray = ["FirstNavigationController", "SecondNavigationController"]
    override func viewDidLoad() {
        
        self.dataSource = self
        self.delegate = self
        
        let startingViewController = self.viewControllerAtIndex(index: self.index)
        let viewControllers: NSArray = [startingViewController!]
        self.setViewControllers(viewControllers as? [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
    }
    
    func viewControllerAtIndex(index: Int) -> UINavigationController! {
        
        if index == 0 {
            return self.storyboard?.instantiateViewController(withIdentifier: "FirstNavigationController") as? UINavigationController
        }
        
        if index == 1 {
            return self.storyboard?.instantiateViewController(withIdentifier: "SecondNavigationController") as? UINavigationController
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        let index = self.identifiers.index(of: identifier!)
        
        if index == identifiers.count - 1 {
            return nil
        }
        
        self.index = self.index + 1
        return self.viewControllerAtIndex(index: self.index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        let index = self.identifiers.index(of: identifier!)
        
        if index == 0 {
            return nil
        }
        
        self.index = self.index - 1
        return self.viewControllerAtIndex(index: self.index)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return self.identifiers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return 0
    }
    
}

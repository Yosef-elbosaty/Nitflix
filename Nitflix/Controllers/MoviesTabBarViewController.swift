//
//  MoviesTabBarViewController.swift
//  Nitflix
//
//  Created by yosef elbosaty on 10/3/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit

class MoviesTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let arrayOfImageNameForSelectedState = [#imageLiteral(resourceName: "upComing"),#imageLiteral(resourceName: "topRated"),#imageLiteral(resourceName: "popular"),#imageLiteral(resourceName: "nowPlaying")]
//        if let count = self.tabBar.items?.count {
//            for i in 0...(count-1) {
//                let imageNameForSelectedState   = arrayOfImageNameForSelectedState[i]
//                //                let imageNameForUnselectedState = arrayOfImageNameForSelectedState[i]
//                self.tabBar.items?[i].selectedImage = (imageNameForSelectedState.imageWithColor(color1: #colorLiteral(red: 0.6767168641, green: 0.5162627697, blue: 0.3887632191, alpha: 1))).withRenderingMode(.alwaysOriginal)
//                self.tabBar.items?[i].image = (imageNameForSelectedState.imageWithColor(color1: #colorLiteral(red: 0.6767168641, green: 0.5162627697, blue: 0.3887632191, alpha: 1))).withRenderingMode(.alwaysOriginal)
//            }
//        }
        
        //Make Four Navigation Controllers as The Root Controller "MoviesViewController"
        let popularNavigationController = navigation()
        let topRatedNavigationController = navigation()
        let upComingNavigationController = navigation()
        let nowPlayingNavigationController = navigation()
        
        //Set The MoviesViewController Depending On The Selected MovieType
        let popularMoviesVC = popularNavigationController.topViewController as! MoviesViewController
        let topRatedMoviesVC = topRatedNavigationController.topViewController as! MoviesViewController
        let upComingMoviesVC = upComingNavigationController.topViewController as! MoviesViewController
        let nowPlayingMoviesVC = nowPlayingNavigationController.topViewController as! MoviesViewController
        
        popularMoviesVC.moviesType = .popular
        topRatedMoviesVC.moviesType = .topRated
        upComingMoviesVC.moviesType = .upComing
        nowPlayingMoviesVC.moviesType = .nowPlaying
        
        //Customize Tab Items
        popularMoviesVC.prepareTabItem()
        topRatedMoviesVC.prepareTabItem()
        upComingMoviesVC.prepareTabItem()
        nowPlayingMoviesVC.prepareTabItem()
        
        //Set The Root View Controllers
        viewControllers = [popularMoviesVC, topRatedMoviesVC, upComingMoviesVC, nowPlayingMoviesVC]
    }
    
    func navigation()->UINavigationController{
        let storyBoard = self.storyboard!
        let controller = storyBoard.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
        return controller
    }
    
    
}
 extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

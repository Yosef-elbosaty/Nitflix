//
//  MoviesTabBarController.swift
//  Nitflix
//
//  Created by yosef elbosaty on 10/9/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit

class MoviesTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        viewControllers = [popularNavigationController, topRatedNavigationController, upComingNavigationController, nowPlayingNavigationController]
    }
    
    func navigation()->UINavigationController{
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
    }
}

//
//  ViewController.swift
//  Netflix
//
//  Created by yosef elbosaty on 10/2/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class MoviesViewController: UIViewController {
    
    //MARK: IBOutlet Initialization
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var switchButton: UIBarButtonItem!
    let activityIndicator = UIActivityIndicatorView()
    
    
    //MARK: Variables Initialization
    var movies = [Movie]()
    var isLoading = false
    var current_page = 1
    var last_page = 1
    var isShown = Array(repeating: false, count: 1000000)
    lazy var tableViewRefresher : UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(getMovies), for: .valueChanged)
        return refresher
    }()
    lazy var collectionViewRefresher : UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(getMovies), for: .valueChanged)
        return refresher
    }()
    enum switchType{
        case list
        case grid
    }
    
    
    var viewType : switchType = .list {
        didSet {
            switch viewType {
            case .list:
                self.tableView.isHidden = false
                self.collectionView.isHidden = true
            case .grid:
                self.tableView.isHidden = true
                self.collectionView.isHidden = false
            }
        }
    }
    
    enum MoviesType : String{
        case popular = "popular"
        case topRated = "top_rated"
        case upComing = "upcoming"
        case nowPlaying = "now_playing"
    }
    
    var moviesType = MoviesType.popular
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.separatorStyle = .none
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.separatorStyle = .singleLine
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        activityIndicator.center = view.center
        activityIndicator.color = .white
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        
        tableView.addSubview(tableViewRefresher)
        tableView.addSubview(activityIndicator)
        
        collectionView.addSubview(collectionViewRefresher)
        collectionView.addSubview(activityIndicator)
        
        tableView.separatorColor = .red
        tableView.separatorInset = UIEdgeInsets(top: -5, left: 50, bottom: -5, right: 50)
        tableView.backgroundColor = .darkGray
        
        tableViewRefresher.tintColor = .white
        collectionViewRefresher.tintColor = .white
        
        collectionView.alwaysBounceVertical = true
        getMovies()
    }
    
    //MARK: getMovies Function "get movies from server"
    @objc func getMovies(){
        self.tableViewRefresher.endRefreshing()
        self.collectionViewRefresher.endRefreshing()
        guard !isLoading else{return}
        isLoading = true
        API.movies(moviesType: moviesType.rawValue, page: current_page) { (error, movies, last_page) in
            if let movies = movies{
                self.movies = movies
                self.tableView.reloadData()
                self.collectionView.reloadData()
                self.current_page = 1
                self.last_page = last_page
                self.activityIndicator.stopAnimating()
                self.tableView.separatorStyle = .singleLine
            }
        }
    }
    
    //MARK: loadMore Function "used in pagination"
    func loadMore(){
        guard current_page < last_page else{return}
        guard !isLoading else{return}
        isLoading = true
        API.movies(moviesType: moviesType.rawValue, page: current_page+1) { (error, movies, last_page) in
            if let movies = movies{
                self.movies.append(contentsOf: movies)
                self.tableView.reloadData()
                self.collectionView.reloadData()
                self.current_page += 1
                self.last_page = last_page
            }
        }
    }
    
    //MARK: Switching Between List And Grid
    @IBAction func switchButton(_ sender: Any) {
        toggleViews()
    }
    
    func toggleViews(){
        switch viewType{
        case .list:
            switchButton.image = UIImage(named: "list")
            viewType = .grid
        case .grid:
            switchButton.image = UIImage(named: "grid")
            viewType = .list
        }
    }
    
    
    //Customizing Tab Bar Items
    func prepareTabItem () {
        let tabItem = navigationController!.tabBarItem!
        
        switch moviesType {
        case .nowPlaying:
            title = "Now Playing"
            tabItem.title = title
            tabItem.image = UIImage(named: "nowPlaying")
        case .popular:
            title = "Popular"
            tabItem.title = title
            tabItem.image = UIImage(named: "popular")
        case .topRated:
            title = "Top Rated"
            tabItem.title = title
            tabItem.image = UIImage(named: "topRated")
        case .upComing:
            title  = "Upcoming"
            tabItem.title = title
            tabItem.image = UIImage(named: "upComing")
        }
    }
    //MARK: Navigate To MovieDetailsViewController
    func goToMovieDetails(indexPath:IndexPath){
        let destination = storyboard?.instantiateViewController(withIdentifier: "details") as!  MovieDetailsViewController
        destination.movie = self.movies[indexPath.row]
        navigationController?.pushViewController(destination, animated: true)
    }
}

//MARK: Table View DataSource Methods
extension MoviesViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MoviesTableViewCell else{
            return UITableViewCell()
        }
        cell.configureCell(movie: movies[indexPath.row])
        return cell
    }
}

//MARK: Table View Delegate Methods
extension MoviesViewController : UITableViewDelegate{
    
    //    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    //        return false
    //    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.movies.count
        if indexPath.row == count-1{
            loadMore()
        }
        if isShown[indexPath.row]{
            return
        }
        isShown[indexPath.row] = true
        
        //Animating Cell
        let rotateTransform = CATransform3DRotate(CATransform3DIdentity, 90.0, 300, -100, 5)
        cell.layer.transform = rotateTransform
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToMovieDetails(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: Collection View DataSource & Delegate Methods
extension MoviesViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MoviesCollectionViewCell else{return UICollectionViewCell()}
        cell.configureCell(movie: movies[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let count = self.movies.count
        if indexPath.item == count-1{
            self.loadMore()
        }
        if isShown[indexPath.row]{
            return
        }
        isShown[indexPath.row] = true
        
        //Animating Cell
        let rotateTransform = CATransform3DRotate(CATransform3DIdentity, 90.0, 300, -100, 5)
        cell.layer.transform = rotateTransform
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToMovieDetails(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        var width = (screenWidth-10)/2
        width = width > 200 ? 200 : width
        return CGSize.init(width: width, height: 270)
    }
}


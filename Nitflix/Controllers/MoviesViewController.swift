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
    
    //MARK: Variables Initialization
    var movies = [Movie]()
    var isloading = false
    var current_page = 1
    var last_page = 1
    var isShown = Array(repeating: false, count: 1000000)
    lazy var refresher : UIRefreshControl = {
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
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        tableView.addSubview(refresher)
        collectionView.addSubview(refresher)
        tableView.separatorColor = .red
        tableView.separatorInset = UIEdgeInsets(top: -5, left: 50, bottom: -5, right: 50)
        tableView.backgroundColor = .darkGray
        refresher.tintColor = .white
        
        getMovies()
    }
    //MARK: getMovies Function "get movies from server"
    @objc func getMovies(){
        self.refresher.endRefreshing()
        API.popularMovies(page: current_page) { (error, movies, last_page) in
            if let movies = movies{
                self.movies = movies
                self.tableView.reloadData()
                self.collectionView.reloadData()
                self.current_page = 1
                self.last_page = last_page
            }
        }
    }
    //MARK: loadMore Function "used in pagination"
    func loadMore(){
        guard current_page < last_page else{return}
        API.popularMovies(page: current_page+1) { (error, movies, last_page) in
            if let movies = movies{
                self.movies.append(contentsOf: movies)
                self.tableView.reloadData()
                self.collectionView.reloadData()
                self.current_page += 1
                self.last_page = last_page
            }
        }
    }
    
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
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.movies.count
        if indexPath.row == count-1{
            loadMore()
        }
        if isShown[indexPath.row]{
            return
        }
        isShown[indexPath.row] = true
        let translateTransform = CATransform3DRotate(CATransform3DIdentity, 90.0, 300, -100, 5)
        cell.layer.transform = translateTransform
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
}

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
        let translateTransform = CATransform3DRotate(CATransform3DIdentity, 90.0, 300, -100, 5)
        cell.layer.transform = translateTransform
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        var width = (screenWidth-10)/2
        width = width > 200 ? 200 : width
        return CGSize.init(width: width, height: width)
    }
}


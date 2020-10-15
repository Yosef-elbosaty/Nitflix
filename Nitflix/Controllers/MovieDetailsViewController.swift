//
//  MovieDetailsViewController.swift
//  Nitflix
//
//  Created by yosef elbosaty on 10/12/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailsViewController: UIViewController {
    
    //MARK: IBOutlet Initialization
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var tagLine: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var runTime: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var revenue: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var recommendationsMoviesCollection: UICollectionView!
    @IBOutlet weak var trailerButton: UIButton!
    
    //MARK: Variables Initialization
    var movie : Movie!
    var recommendationsMovies : [Movie] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = movie.title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        loadDetails()
        loadRecommendationsMovies()
    }
    
    //Display Movie Details And Customize View
    func displayMovieDetails(){
        
        let backDropURL = URL(string: movie.backdrop)
        self.backdropImage.kf.indicatorType = .activity
        self.backdropImage.kf.setImage(with: backDropURL, placeholder: nil, options: [.transition(.fade(0.5))], progressBlock: .none)
        backdropImage.layer.borderColor = UIColor.red.cgColor
        backdropImage.layer.borderWidth = 1.5
        
        let posterURL = URL(string: movie.poster)
        self.posterImage.kf.setImage(with: posterURL, placeholder: nil, options: [.transition(.fade(0.5))], progressBlock: .none)
        let translateTransform = CATransform3DTranslate(CATransform3DIdentity, -500, -1000, 0)
        posterImage.layer.transform = translateTransform
        UIView.animate(withDuration: 1.5) {
            self.posterImage.layer.transform = CATransform3DIdentity
        }
        
        self.movieTitle.text = movie.title
        self.rate.text = "⭐️\(movie.rate)"
        self.releaseDate.text = movie.relaseYear()
        self.genres.text = movie.geners.joined(separator: ", ")
        self.overview.text = movie.overview
        self.runTime.text = "\("\(movie.runTime! / 60 )"+":"+"\(movie.runTime! & 60)")H"
        
        if movie.tagLine == ""{
            tagLine.text = "Tagline is not provided"
        }else{
            self.tagLine.text = movie.tagLine
        }
        
        if movie.revenue == 0 || movie.revenue == nil{
            revenue.text = "Revenue is not provided"
        }else{
            revenue.text = "\(movie.revenue!)$"
        }
        
    }
    
    //MARK: Get Movie Details From Server
    func loadDetails(){
        let id = movie.id
        API.getMovieDetails(movieId: id) { (error, movie) in
            if let movie = movie{
                self.movie = movie
                self.displayMovieDetails()
            }
        }
    }
    @IBAction func goToTrailer(_ sender: Any) {
        if let trailerKey = movie.trailerKey{
            if let url = URL(string:"http://www.youtube.com/watch?v=\(trailerKey)"){
                UIApplication.shared.open(url)
            }
        }
    }
    
    
}

//MARK: Collection View DataSource & Delegate Methods
extension MovieDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //MARK: Get Recommendations Movies
    func loadRecommendationsMovies(){
        API.getRecommendationsMovies(movieId: movie.id) { (error, movies) in
            if let movies = movies{
                self.recommendationsMovies.append(contentsOf: movies)
                self.recommendationsMoviesCollection.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendationsMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoviesCollectionViewCell
        cell.loadImage(movie: recommendationsMovies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "details") as! MovieDetailsViewController
        destination.movie = self.recommendationsMovies[indexPath.row]
        navigationController?.pushViewController(destination, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = recommendationsMoviesCollection.frame.height
        return CGSize.init(width: height / 1.5, height: height)
    }
}

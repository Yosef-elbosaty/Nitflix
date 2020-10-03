//
//  MoviesCollectionViewCell.swift
//  Nitflix
//
//  Created by yosef elbosaty on 10/2/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import Kingfisher
class MoviesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieIV: UIImageView!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    func configureCell(movie: Movie){
        let imageURL = URL(string: movie.poster)
        self.movieIV.kf.setImage(with: imageURL)
        self.movieYear.text = movie.relaseYear()
        self.movieRate.text = "⭐️\(movie.rate)"
        let movieRateAttributedText = [NSAttributedString.Key.backgroundColor : UIColor.red]
        self.movieRate.attributedText = NSAttributedString(string: movieRate.text!, attributes: movieRateAttributedText)
    }
}

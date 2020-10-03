//
//  MoviesTableViewCell.swift
//  Nitflix
//
//  Created by yosef elbosaty on 10/2/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import Kingfisher

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var movieIV: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(movie: Movie){
        let imageURl = URL(string: movie.poster)
        self.movieIV.kf.setImage(with: imageURl)
        self.movieTitle.text = movie.title
        let underLineAttribute = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.red] as [NSAttributedString.Key : Any]
        self.movieTitle.attributedText = NSAttributedString(string: movieTitle.text!, attributes: underLineAttribute)
        self.movieYear.text = movie.relaseYear()
        self.movieRate.text = "⭐️\(movie.rate)"
        self.summaryLabel.text = movie.overview   
    }
    

}

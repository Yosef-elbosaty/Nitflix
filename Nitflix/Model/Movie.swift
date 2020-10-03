//
//  Movie.swift
//  Netflix
//
//  Created by yosef elbosaty on 10/2/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import SwiftyJSON

class Movie: NSObject {
    var id : Int
    var title : String
    var overview : String
    var poster : String
    var releaseDate : String?
    var rate : Float
    var geners : [String] = []
    init?(dict : [String:JSON]){
        guard let id = dict["id"]?.int else{return nil}
        guard let title = dict["title"]?.string else{return nil}
        guard let overview = dict["overview"]?.string else{return nil}
        guard let poster = dict["poster_path"]?.toImagePath else{return nil}
        guard let releaseDate = dict["release_date"]?.toString else{return nil}
        guard let rate = dict["vote_average"]?.float else{return nil}
        self.id = id
        self.title = title
        self.overview = overview
        self.poster = poster
        self.releaseDate = releaseDate
        self.rate = rate
        if let genresJSON = dict["genres"]?.arrayValue{
            var genres = [String]()
            for gener in genresJSON{
                genres.append(gener.stringValue)
                self.geners = genres
            }
        }
        
    }
    func relaseYear() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        if let releaseDate = releaseDate , let dateFromString = dateFormatter.date(from: releaseDate) {
            //get only the year component
            dateFormatter.dateFormat = "yyy"
            return dateFormatter.string(from: dateFromString)
        }
        return nil
    }
}

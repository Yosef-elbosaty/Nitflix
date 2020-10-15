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
    var backdrop : String
    var releaseDate : String?
    var rate : Float
    var geners : [String] = []
    var runTime : Int?
    var tagLine : String?
    var revenue : Int?
    var trailerKey : String?
    init?(dict : [String:JSON]){
        guard let id = dict["id"]?.int else{return nil}
        guard let title = dict["title"]?.string else{return nil}
        guard let overview = dict["overview"]?.string else{return nil}
        guard let poster = dict["poster_path"]?.toImagePath else{return nil}
        guard let releaseDate = dict["release_date"]?.toString else{return nil}
        guard let rate = dict["vote_average"]?.float else{return nil}
        guard let backdrop = dict["backdrop_path"]?.toImagePath else{return nil}
        if let runTime = dict["runtime"]?.int{
            self.runTime = runTime
        }
        if let tagLine = dict["tagline"]?.string{
            self.tagLine = tagLine
        }
           if let revenue = dict["revenue"]?.int{
            self.revenue = revenue
        }
        self.id = id
        self.title = title
        self.overview = overview
        self.poster = poster
        self.backdrop = backdrop
        self.releaseDate = releaseDate
        self.rate = rate
        
        if let videoJSON = dict["videos"]?.dictionary{
            if let results = videoJSON["results"]?.arrayValue{
                let trailerKey = results[0]["key"].string
                self.trailerKey = trailerKey
        }
        }
        
        if let genresJSON = dict["genres"]?.arrayValue{
            var genres = [String]()
            for genre in genresJSON{
                genres.append( genre["name"].stringValue)
                self.geners = genres
            }
        }
        
    }
    
    
    //Changing releaseYear Format
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

//
//  API.swift
//  Netflix
//
//  Created by yosef elbosaty on 10/2/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class API: NSObject {
    
    class func movies(moviesType:String,page: Int = 1,completion: @escaping(_ error:Error?,_ movies:[Movie]?,_ last_page: Int)->Void){
        let moviesURL = Constants.baseURL+"\(moviesType)?api_key=\(Constants.api_key)"+"&page=\(page)"
        let params = ["page":page]
        AF.request(moviesURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: Helper.headers).responseJSON { (response) in
            switch response.result{
            case .failure(let error): completion(error,nil,page);print(error)
            case .success(let value):
                let json = JSON(value)
            //    print(json)
                guard let movieJSON = json["results"].array else{completion(nil,nil,page);return}
                var movieList = [Movie]()
                for movie in movieJSON{
                    if let data = movie.dictionary, let film = Movie.init(dict: data){
                        movieList.append(film)
                    }
                }
                let last_page = json["total_pages"].int ?? page
                completion(nil,movieList,last_page)
            }
        }
    }
    
    class func getMovieDetails(movieId: Int, completion: @escaping(_ error:Error?,_ movie:Movie?)->Void){
        let detailsURL = Constants.baseURL+"\(movieId)"+"?api_key=\(Constants.api_key)&append_to_response=videos"
        AF.request(detailsURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Helper.headers).responseJSON { (response) in
            switch response.result{
            case .failure(let error): print(error); completion(error,nil)
            case .success(let value):
                let json = JSON(value)
                let movie = Movie(dict: json.dictionary!)
                completion(nil,movie)
            }
        }
    }
    
    class func getRecommendationsMovies(movieId: Int, completion: @escaping(_ error:Error?,_ movie:[Movie]?)->Void){
        let recommendationsURL = Constants.baseURL+"\(movieId)"+"/recommendations?api_key=\(Constants.api_key)"
        AF.request(recommendationsURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Helper.headers).responseJSON { (response) in
            switch response.result{
            case .failure(let error): completion(error,nil); print(error)
            case .success(let value):
                let json = JSON(value)
                guard let recommendationsJSON = json["results"].array else{completion(nil,nil);return}
                var recommendationsList = [Movie]()
                for movie in recommendationsJSON{
                    if let data = movie.dictionary, let movie = Movie(dict: data){
                        recommendationsList.append(movie)
                    }
                }
                 completion(nil,recommendationsList)
            }
        }
    }
}



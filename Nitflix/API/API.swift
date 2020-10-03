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
    
    class func movies(page: Int = 1,completion: @escaping(_ error:Error?,_ movies:[Movie]?,_ last_page: Int)->Void){
        let moviesURL = URLs.popularURL+"&page=\(page)"
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
}

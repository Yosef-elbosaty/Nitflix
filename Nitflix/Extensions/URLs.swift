//
//  URLs.swift
//  Netflix
//
//  Created by yosef elbosaty on 10/2/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import Foundation

struct URLs{
    static let api_key = "a1239da1147b583e07615dd0cbe8d7e2"
    static let imagePath = "https://image.tmdb.org/t/p/original"
    static let baseURL = "https://api.themoviedb.org/3/"
    static let moviesURL = baseURL+"movie"
    static let popularURL = moviesURL+"/popular?api_key=\(api_key)"
}


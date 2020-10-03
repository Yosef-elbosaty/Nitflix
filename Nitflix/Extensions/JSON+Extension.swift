//
//  String+Extension.swift
//  Netflix
//
//  Created by yosef elbosaty on 10/2/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON{
    var toString : String?{
        if let string = self.string {return string}
        if let int = self.int{
            let string = String(int)
            return string
        }
        return string
    }
    
    var toImagePath : String?{
        guard let string = self.string, !string.isEmpty else{return nil}
        return URLs.imagePath + string
    }
}

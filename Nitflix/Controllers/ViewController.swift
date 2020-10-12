//
//  ViewController.swift
//  Nitflix
//
//  Created by yosef elbosaty on 10/9/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit

class ViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "a", sender: self)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

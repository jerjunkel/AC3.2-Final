//
//  Utilites.swift
//  AC3.2-Final
//
//  Created by Jermaine Kelly on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation
import UIKit

class Utilities{
    
    static func showAlert(title: String, message: String = ""){
        let alert :UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
    }
    
}

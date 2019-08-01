//
//  AlertMessageExstension.swift
//  TVShows
//
//  Created by Sandro Domitran on 30/07/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    // alert user with message and title
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

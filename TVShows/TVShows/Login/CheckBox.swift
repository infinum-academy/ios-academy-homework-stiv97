//
//  CheckBox.swift
//  TVShows
//
//  Created by Sandro Domitran on 16/07/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import Foundation
import UIKit

final class CheckBox {
    private let checkedImage : UIImage
    private let uncheckedImage : UIImage
    private let button : UIButton
    
    var isChecked : Bool {
        return (self.button.currentImage == self.checkedImage)
    }
    
    func pressed(){
        if !self.isChecked {
            button.setImage(checkedImage, for: .normal)
        } else {
            button.setImage(uncheckedImage, for: .normal)
        }
    }
    
    init(checkedImage: String, uncheckedImage: String, button: UIButton) {
        var image = UIImage(named: checkedImage)
        if image != nil {
            self.checkedImage = image!
        } else{
            self.checkedImage = UIImage()
            print("No image with specified name!")
        }
        
        image = UIImage(named: uncheckedImage)
        if image != nil {
            self.uncheckedImage = image!
        } else{
            self.uncheckedImage = UIImage()
            print("No image with specified name!")
        }
        
        self.button = button
    }
}

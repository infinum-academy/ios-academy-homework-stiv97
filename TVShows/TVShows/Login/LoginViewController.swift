//
//  LoginViewController.swift
//  TVShows
//
//  Created by Sandro Domitran on 05/07/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import UIKit
//import MBProgressHUD

class LoginViewController: UIViewController {

    
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myCenterY: NSLayoutConstraint!
    
    var clickCounter : Int = 0
    var activityIndicator : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // button design
        myButton.backgroundColor = .black
        myButton.layer.cornerRadius = 50
        // activity indicator 3sec animation
        myActivityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.myActivityIndicator.stopAnimating()
        }
        
    }

    @IBAction func touchEvent(_ sender: UIButton) {
        // change label
        clickCounter += 1
        myLabel.text = String(clickCounter)
        
        // randomly change background
        view.backgroundColor = UIColor.init(
            red: CGFloat(Float.random(in: 0 ..< 1)),
            green: CGFloat(Float.random(in: 0 ..< 1)),
            blue: CGFloat(Float.random(in: 0 ..< 1)),
            alpha: 1);
        
        // change activity
        if(activityIndicator){
            myActivityIndicator.stopAnimating()
        } else {
            myActivityIndicator.startAnimating()
        }
        activityIndicator = !activityIndicator
        
      
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

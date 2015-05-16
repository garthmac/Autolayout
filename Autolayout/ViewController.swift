//
//  ViewController.swift
//  Autolayout
//
//  Created by iMac21.5 on 4/21/15.
//  Copyright (c) 2015 Garth MacKenzie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    var loggedInUser: User! { didSet { updateUI() } }
    var secure = false { didSet { updateUI() }
    }
    private func updateUI() {
        passwordField.secureTextEntry = secure
        passwordLabel.text = secure ? "Secured Password" : "Password"
        nameLabel.text = loggedInUser?.name
        companyLabel.text = loggedInUser?.company
        image = loggedInUser?.image
        passwordField.resignFirstResponder()
        loginField.resignFirstResponder()
    }
    
    @IBAction func login() {
        loggedInUser = User.login(loginField.text ?? "", password: passwordField.text ?? "")
    }
    @IBAction func toggleSecurity() {
        secure = !secure
    }
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            if let constrainedView = imageView {
                if let newImage = newValue { //w=h*aspectRatio
                    aspectRatioConstraint = NSLayoutConstraint(item: constrainedView,
                        attribute: .Width,
                        relatedBy: .Equal,
                        toItem: constrainedView,
                        attribute: .Height,
                        multiplier: newImage.aspectRatio,
                        constant: 0)
                } else {
                    aspectRatioConstraint = nil
                }
            }
        }
        
    }
    var aspectRatioConstraint: NSLayoutConstraint? {
        willSet {
            if let existingConstraint = aspectRatioConstraint {
                view.removeConstraint(existingConstraint)
            }
        }
        didSet { // if not nil
            if let newConstraint = aspectRatioConstraint {
                view.addConstraint(newConstraint)
            }
        }
    }
    
}

extension User {
    var image: UIImage? {
        if let image = UIImage(named: login) {
            return image
        } else {
            return UIImage(named: "userUnknown")
        }
    }
}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}
// when change size class (regular H, Any W) set Image,Name,Company
//remove contraints first before moving



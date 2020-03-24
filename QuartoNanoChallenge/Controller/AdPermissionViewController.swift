//
//  AdPermissionViewController.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 24/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import UIKit

class AdPermissionViewController: UIViewController {

    var gameScene: GameScene!
    
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var presentationView: UIView!
    
    @IBOutlet weak var btnDoubleCoins: UIButton!
    @IBOutlet weak var btnNoThanks: UIButton!
    @IBOutlet weak var btnGoHome: UIButton!
    
    var adWasShowed: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adWasShowed = false
        
        btnGoHome.isHidden = true
        btnGoHome.isEnabled = false
        
        btnGoHome.layer.shadowColor = UIColor.black.cgColor
        btnGoHome.layer.shadowOpacity = 1
        btnGoHome.layer.shadowOffset = CGSize(width: 3, height: 3)
        btnGoHome.layer.shadowRadius = 10
        
        btnDoubleCoins.layer.shadowColor = UIColor.black.cgColor
        btnDoubleCoins.layer.shadowOpacity = 1
        btnDoubleCoins.layer.shadowOffset = CGSize(width: 3, height:3)
        btnDoubleCoins.layer.shadowRadius = 10
        
        presentationView.layer.cornerRadius = 50
        presentationView.layer.shadowColor = UIColor.black.cgColor
        presentationView.layer.shadowOpacity = 1
        presentationView.layer.shadowOffset = CGSize(width: 10, height: 10)
        presentationView.layer.shadowRadius = 10
        updateCoins()
    }
    
    @IBAction func doubleCoinsPressed(_ sender: Any) {
        adWasShowed = true
        Model.shared.currentCoins += Model.shared.currentCoins
        updateCoins()
        
        btnGoHome.isHidden = false
        btnGoHome.isEnabled = true
        
        btnDoubleCoins.isHidden = true
        btnDoubleCoins.isEnabled = false
    }
    
    @IBAction func noThanksPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goHomePressed(_ sender: Any) {
        
        gameScene.removeAllChildren()
        
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = self
        
        let gameViewController: InitialScreenViewController!
        let gameView: UIStoryboard = UIStoryboard(name: "InitialScreen", bundle: nil)
        gameViewController = gameView.instantiateViewController(withIdentifier: "InitialScreen") as? InitialScreenViewController
        self.present(gameViewController, animated: false, completion: nil)
    }
    
    func updateCoins() {
        lblScore.text = String(Model.shared.currentCoins)
    }
}

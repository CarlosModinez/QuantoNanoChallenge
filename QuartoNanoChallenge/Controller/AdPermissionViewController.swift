//
//  AdPermissionViewController.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 24/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdPermissionViewController: UIViewController, GADRewardedAdDelegate {

    var gameScene: GameScene!
    
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var presentationView: UIView!
    
    @IBOutlet weak var btnDoubleCoins: UIButton!
    @IBOutlet weak var btnNoThanks: UIButton!
    @IBOutlet weak var btnGoHome: UIButton!
    
    var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnGoHome.isHidden = true
        btnGoHome.isEnabled = false
        
        btnDoubleCoins.isEnabled = false
        
        // Go home  button layout adjust
        btnGoHome.layer.shadowColor = UIColor.black.cgColor
        btnGoHome.layer.shadowOpacity = 1
        btnGoHome.layer.shadowOffset = CGSize(width: 3, height: 3)
        btnGoHome.layer.shadowRadius = 10
        
        // Double coins button layout adjust
        btnDoubleCoins.layer.shadowColor = UIColor.black.cgColor
        btnDoubleCoins.layer.shadowOpacity = 1
        btnDoubleCoins.layer.shadowOffset = CGSize(width: 3, height:3)
        btnDoubleCoins.layer.shadowRadius = 10
        
        // View layout adjust
        presentationView.layer.cornerRadius = 50
        presentationView.layer.shadowColor = UIColor.black.cgColor
        presentationView.layer.shadowOpacity = 1
        presentationView.layer.shadowOffset = CGSize(width: 10, height: 10)
        presentationView.layer.shadowRadius = 10
        
        
        updateCoins()
        
        //Search for ad and when find, allow click in double coins button
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        rewardedAd?.load(GADRequest()) { error in
            if let error = error {
                // Handle ad failed to load case.
                print("NAO")
                print(error)
            } else {
                // Ad successfully loaded.
                print("BOA")
                self.btnDoubleCoins.isEnabled = true
            }
        }
    }
    
    @IBAction func doubleCoinsPressed(_ sender: Any) {
        if rewardedAd?.isReady == true {
           rewardedAd?.present(fromRootViewController: self, delegate:self)
        }
    }

    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("reward received")
    }

    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        Model.shared.currentCoins += Model.shared.currentCoins
        updateCoins()
        
        btnGoHome.isHidden = false
        btnGoHome.isEnabled = true
        
        btnDoubleCoins.isHidden = true
        btnDoubleCoins.isEnabled = false
    }
    
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("View was dismissed")
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("Rewarded ad failed to present.")
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

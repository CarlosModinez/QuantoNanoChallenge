//
//  AdViewController.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 25/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import UIKit
import GoogleMobileAds


class AdViewController: UIViewController, GADRewardedAdDelegate {
    
    var rewardedAd: GADRewardedAd?
    override func viewDidLoad() {
        super.viewDidLoad()
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        rewardedAd?.load(GADRequest()) { error in
            if let error = error {
                // Handle ad failed to load case.
                print("NAO")
                print(error)
            } else {
                // Ad successfully loaded.
                print("BOA")
            }
        }
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("__")
    }

    @IBAction func btnShowAd(_ sender: Any) {
        if rewardedAd?.isReady == true {
           rewardedAd?.present(fromRootViewController: self, delegate:self)
        }
    }
}

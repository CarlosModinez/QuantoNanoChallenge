//
//  InitialScreenViewController.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 12/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import UIKit
import GameKit

class InitialScreenViewController: UIViewController {
    
    @IBOutlet weak var tapToPlayOutlet: UIButton!
    @IBOutlet weak var firstScreenView: UIView!
    
    var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        firstScreenView.layer.cornerRadius = 30.0
        GameCenter.shared.authenticateLocalPlayer(presentingVC: InitialScreenViewController())
//        animationLabel()
    }
    
    func animationLabel() {
        UIView.animate(withDuration: 1, delay: 0, options: [UIButton.AnimationOptions.autoreverse, UIButton.AnimationOptions.repeat],
                                   animations: {

                                    self.tapToPlayOutlet.setTitleColor(UIColor.clear, for: .normal)
                                    print("1")
//        self.tapToPlayOutlet.titleLabel?.textColor.withAlphaComponent(0)
        }, completion: nil)
    }
    
    @IBAction func playBtnPressed(_ sender: Any) {
        let gameViewController: GameViewController!
        let gameView: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        gameViewController = gameView.instantiateViewController(withIdentifier: "gameView") as? GameViewController
        self.present(gameViewController, animated: true, completion: nil)
    }
    
}

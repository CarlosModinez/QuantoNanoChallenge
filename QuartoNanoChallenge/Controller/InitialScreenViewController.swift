//
//  InitialScreenViewController.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 12/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import UIKit
import GameKit

class InitialScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var tapToPlayOutlet: UIButton!
    @IBOutlet weak var firstScreenView: UIView!
    var imageCharacters: [UIImage?] = [UIImage(named: "inicialBird"), UIImage(named: "inicialElephant"), UIImage(named: "inicialGiraf"), UIImage(named: "inicialhabbit"), UIImage(named: "inicialHippo"), UIImage(named: "inicialMonkey"), UIImage(named: "inicialPenguin"), UIImage(named: "inicialSnake"), UIImage(named: "iniciaPig"), UIImage(named: "inicialPanda")]
    
    @IBOutlet weak var characterCollection: UICollectionView!
    var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        firstScreenView.layer.cornerRadius = 30.0
        GameCenter.shared.authenticateLocalPlayer(presentingVC: self)
    }
    
    
    @IBAction func playBtnPressed(_ sender: Any) {
        let gameViewController: GameViewController!
        let gameView: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        gameViewController = gameView.instantiateViewController(withIdentifier: "gameView") as? GameViewController
        self.present(gameViewController, animated: true, completion: nil)
    }
    
    // COLLECTION
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "character", for: indexPath) as! CharacterCollectionViewCell
        cell.imageCharacter.image = imageCharacters[indexPath.row]
        cell.imageCharacter.frame.size = cell.frame.size
        //        cell.imageCharacter.contentMode = UIView.ContentMode.scaleAspectFit
        return cell
    }
    
    @IBAction func btnLeftArrowAction(_ sender: Any) {
        let collectionBounds = self.characterCollection.bounds
        let contentOffset = CGFloat(floor(self.characterCollection.contentOffset.x - collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
        
    }
    
    @IBAction func btnRightArrowAction(_ sender: Any) {
        
        let collectionBounds = self.characterCollection.bounds
        let contentOffset = CGFloat(floor(self.characterCollection.contentOffset.x + collectionBounds.size.width))
        //        print("CONTENT OFFSET: ", contentOffset)
        self.moveCollectionToFrame(contentOffset: contentOffset)
        
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let widthCollection = self.characterCollection.frame.width
        let isInteger = Int(contentOffset/widthCollection)
        
        if contentOffset == widthCollection*(CGFloat(imageCharacters.count)){

            let frame: CGRect = CGRect(x : (contentOffset/CGFloat(imageCharacters.count)) - widthCollection ,y : self.characterCollection.contentOffset.y ,width : self.characterCollection.frame.width,height : self.characterCollection.frame.height)
            self.characterCollection.scrollRectToVisible(frame, animated: true)
        }
        else if contentOffset == -widthCollection {
            let frame: CGRect = CGRect(x : (-contentOffset*CGFloat(imageCharacters.count)) - widthCollection ,y : self.characterCollection.contentOffset.y ,width : self.characterCollection.frame.width,height : self.characterCollection.frame.height)
            self.characterCollection.scrollRectToVisible(frame, animated: true)
        }
        
        else {
            if  CGFloat(isInteger) == contentOffset/widthCollection {
                let frame: CGRect = CGRect(x : contentOffset ,y : self.characterCollection.contentOffset.y ,width : self.characterCollection.frame.width,height : self.characterCollection.frame.height)
                self.characterCollection.scrollRectToVisible(frame, animated: true)
            }
        }
    }
    
}

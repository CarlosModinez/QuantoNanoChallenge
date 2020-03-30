//
//  InitialScreenViewController.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 12/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import UIKit
import GameKit
import GoogleMobileAds

class InitialScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var tapToPlayOutlet: UIButton!
    @IBOutlet weak var tapToBuyOutlet: UIButton!
    @IBOutlet weak var lblCoinsAmount: UILabel!
    @IBOutlet weak var lblCharacterPrice: UILabel!
    @IBOutlet weak var firstScreenView: UIView!
    
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    
    var characterID: Int = 0
    
    var imageCharacters: [UIImage?] = [UIImage(named: "iniciaPig"), UIImage(named: "inicialBird"), UIImage(named: "inicialElephant"), UIImage(named: "inicialGiraf"), UIImage(named: "inicialHippo"), UIImage(named: "inicialMonkey"), UIImage(named: "inicialPanda"), UIImage(named: "inicialPenguin"), UIImage(named: "inicialhabbit"), UIImage(named: "inicialSnake")]
    
    @IBOutlet weak var characterCollection: UICollectionView!
    var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Model.shared.totalCoins)
        GameCenter.shared.authenticateLocalPlayer(presentingVC: self)
        lblCoinsAmount.text = String(Model.shared.totalCoins)
        updateButtons()
        characterCollection.isUserInteractionEnabled = false
        
        //Adiciona o banner ad na view
        Model.shared.initialBannerAd.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            // ID LOJA
            //"ca-app-pub-3143840922595951/1780408112"
            // ID TESTE
            //"ca-app-pub-3940256099942544/2934735716"
        
        Model.shared.initialBannerAd.rootViewController = self
        addBannerViewToView(Model.shared.initialBannerAd)
        Model.shared.initialBannerAd.load(GADRequest())
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
     view.addSubview(bannerView)
     view.addConstraints(
       [NSLayoutConstraint(item: bannerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: bottomLayoutGuide,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: bannerView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0)
       ])
    }
    
    
    
    
    @IBAction func playBtnPressed(_ sender: Any) {
        let gameViewController: GameViewController!
        let gameView: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        Model.shared.character = characterID
        Model.shared.updateCharacter()
        gameViewController = gameView.instantiateViewController(withIdentifier: "gameView") as? GameViewController
        self.present(gameViewController, animated: true, completion: nil)
    }
    
    @IBAction func buyBtNPressed(_ sender: Any) {
        lblCoinsAmount.text = String(Model.shared.totalCoins - Model.shared.characters[characterID].price)
        Model.shared.characters[characterID].able = true
        Model.shared.ableCharacters[characterID] = true
        Model.shared.totalCoins -= Model.shared.characters[characterID].price
        
        updateButtons()
    }
    
    func updateButtons() {
        // 1) Se o personagem ja foi adquirido
        // 2) Se nao foi adquirido e voce tem dinheiro
        // 3) Se nao foi adquirido e voce nao tem dinheiro
        if Model.shared.characters[characterID].able {
            tapToBuyOutlet.isHidden = true
            tapToBuyOutlet.isEnabled = false
            
            tapToPlayOutlet.isHidden = false
            tapToPlayOutlet.isEnabled = true
        } else if Model.shared.characters[characterID].price <= Model.shared.totalCoins {
            tapToBuyOutlet.isHidden = false
            tapToBuyOutlet.isEnabled = true
            
            tapToPlayOutlet.isHidden = true
            tapToPlayOutlet.isEnabled = false
            
        } else {
            tapToBuyOutlet.isHidden = false
            tapToBuyOutlet.isEnabled = false
            
            tapToPlayOutlet.isHidden = true
            tapToPlayOutlet.isEnabled = false
        }
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
        return cell
    }
    
    
    @IBAction func btnLeftArrowAction(_ sender: Any) {
        let collectionBounds = self.characterCollection.bounds
        let contentOffset = CGFloat(floor(self.characterCollection.contentOffset.x - collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
        updateButtons()
        lblCharacterPrice.text = String(Model.shared.characters[characterID].price)
    }
    
    @IBAction func btnRightArrowAction(_ sender: Any) {
        let collectionBounds = self.characterCollection.bounds
        let contentOffset = CGFloat(floor(self.characterCollection.contentOffset.x + collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
        updateButtons()
        lblCharacterPrice.text = String(Model.shared.characters[characterID].price)
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let widthCollection = self.characterCollection.frame.width
        let isInteger = Int(contentOffset/widthCollection)
        characterID = isInteger
        print(isInteger)
        if contentOffset == widthCollection*(CGFloat(imageCharacters.count)){
            characterID = 0
            let frame: CGRect = CGRect(x : (contentOffset/CGFloat(imageCharacters.count)) - widthCollection ,y : self.characterCollection.contentOffset.y ,width : self.characterCollection.frame.width,height : self.characterCollection.frame.height)
            self.characterCollection.scrollRectToVisible(frame, animated: true)
        }
        else if contentOffset == -widthCollection {
            characterID = 9
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

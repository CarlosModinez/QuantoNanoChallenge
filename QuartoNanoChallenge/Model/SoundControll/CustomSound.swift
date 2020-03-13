//
//  CustomSound.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 13/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import Foundation
import AVFoundation

class CustomSound {
    private var players = [AVAudioPlayer]()
    private var url: URL
    
    init(fileName: String) {
        let path = Bundle.main.path(forResource: fileName, ofType: nil)!
        url = URL(fileURLWithPath: path)

        loadAudio()
    }
    
    private func loadAudio() {
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay() //Segundo a definicao, ajuda a nao dar lag quando for tocar a musica
            players.append(player)
        } catch {
            fatalError("Nao foi possivel carregar o audio")
        }
    }
    
    //O novo som nao corta o que já estava tocando
    func play() {
        for player in players {
            if !player.isPlaying {
                player.play()
                return
            }
        }
        
        //Se nao houver, cria e toca
        loadAudio()
        players.last?.play()
    }
    
    
    
}

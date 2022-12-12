//
//  AudioManager.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 12/12/22.
//

import SpriteKit

class AudioManager {
    
    
    func playEnemySound() -> SKAction {
        SKAction.playSoundFileNamed("mixkit-little-cat-attention-meow-86", waitForCompletion: false)
    }
    
    func playGetHeartSound() -> SKAction {
        SKAction.playSoundFileNamed("mixkit-game-flute-bonus-2313", waitForCompletion: false)
    }
    
    func playPowerUpSound() -> SKAction {
        SKAction.playSoundFileNamed("mixkit-casino-bling-achievement-2067", waitForCompletion: false)
    }
}



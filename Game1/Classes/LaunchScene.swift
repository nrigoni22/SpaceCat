//
//  LaunchScene.swift
//  Game1
//
//  Created by Nicola Rigoni on 08/12/22.
//

import SpriteKit
import AVFoundation

class LaunchScene: SKScene {
    
    var playBtn = SKSpriteNode()
    var scoreBtn = SKSpriteNode()
    var titleLabel = SKLabelNode()
    
    var scoreTitleLabel = SKLabelNode()
    var highscoreLabel = SKLabelNode()
    var otherScoreLabel: [SKLabelNode] = []
    var backBtn = SKSpriteNode()
    
    var backgroundMusic: AVAudioPlayer = {
        let path = Bundle.main.path(forResource: "music_zapsplat_game_music_zen_calm_soft_arpeggios_013", ofType: "mp3")
        let url = URL(filePath: path!)
        let backgroundMusic = try! AVAudioPlayer(contentsOf: url)
        backgroundMusic.numberOfLoops = -1
        return backgroundMusic
    }()
    
    var buttonAudio: AVAudioPlayer = {
        let path = Bundle.main.path(forResource: "button", ofType: "mp3")
        let url = URL(filePath: path!)
        let buttonAudio = try! AVAudioPlayer(contentsOf: url)
//        backgroundMusic.numberOfLoops = -1
        return buttonAudio
    }()
    
    override func didMove(to view: SKView) {
        inizialize()
    }
    
    func inizialize() {
        creatBG()
        getButtons()
        getTitle()
        backgroundMusic.play()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if nodes(at: location).first == playBtn {
                buttonAudio.play()
                HapticManager.instance.impact(style: .light)
                backgroundMusic.stop()
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene!.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!, transition: SKTransition.doorway(withDuration: 1.5))
            }
            
            if nodes(at: location).first == scoreBtn {
                buttonAudio.play()
                HapticManager.instance.impact(style: .light)
                scoreView()
            }
            
            if nodes(at: location).first == backBtn {
                buttonAudio.play()
                HapticManager.instance.impact(style: .light)
                backBtn.removeFromParent()
                scoreTitleLabel.removeFromParent()
                highscoreLabel.removeFromParent()
                for label in otherScoreLabel {
                    label.removeFromParent()
                }
                
                self.addChild(playBtn)
                self.addChild(scoreBtn)
                self.addChild(titleLabel)
                inizialize()
            }
        }
    }
    
    func creatBG() {
        let bg = SKSpriteNode(imageNamed: "sfondo2bis")
        bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bg.position = CGPoint(x: 0, y: 0)
        bg.zPosition = 0
        bg.setScale(4.8)
        self.addChild(bg)
    }
    
    func getButtons() {
        playBtn = self.childNode(withName: "Play") as! SKSpriteNode
        scoreBtn = self.childNode(withName: "Score") as! SKSpriteNode
    }
    
    func getTitle() {
        titleLabel = self.childNode(withName: "TitleLabel") as! SKLabelNode
        titleLabel.fontName = "8-bit Arcade In"
        titleLabel.fontSize = 130
        titleLabel.text = "Space Cat"
        titleLabel.zPosition = 5
        
        let moveUp = SKAction.moveTo(y: titleLabel.position.y + 30 , duration: 2)
        let moveDown = SKAction.moveTo(y: titleLabel.position.y - 30, duration: 2)
        
        let sequence = SKAction.sequence([moveUp, moveDown])
        
        titleLabel.run(SKAction.repeatForever(sequence))
    }
    
    
    func scoreView() {
        playBtn.removeFromParent()
        scoreBtn.removeFromParent()
        titleLabel.removeFromParent()
        
        scoreTitleLabel = SKLabelNode(text: "Your Score")
        scoreTitleLabel.fontName = "8-bit Arcade In"
        scoreTitleLabel.zPosition = 10
        scoreTitleLabel.fontSize = 90
        scoreTitleLabel.position = CGPoint(x: 0, y: 180);
        self.addChild(scoreTitleLabel)
        
        backBtn = SKSpriteNode(imageNamed: "Quit")
        backBtn.name = "Quit"
        backBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backBtn.position = CGPoint(x: -500, y: -180)
        backBtn.zPosition = 10
        backBtn.setScale(0.5)
        self.addChild(backBtn)
        
        highscoreLabel = SKLabelNode(text: "Higherscore:    \(UserDefaults.standard.integer(forKey: "Highscore"))")
        highscoreLabel.fontName = "8-bit Arcade In"
        highscoreLabel.zPosition = 10
        highscoreLabel.fontSize = 65
        highscoreLabel.position = CGPoint(x: 0, y: 80);
        self.addChild(highscoreLabel)
        
        for index in 0..<5 {
            let scoreLabel = SKLabelNode(text: "Match \(index + 1):    \(UserDefaults.standard.integer(forKey: "Score\(index)"))")
            scoreLabel.fontName = "8-bit Arcade In"
            scoreLabel.zPosition = 10
            scoreLabel.fontSize = 55
            scoreLabel.position = CGPoint(x: 0, y: 20 - (60 * index));
            otherScoreLabel.append(scoreLabel)
            self.addChild(otherScoreLabel[index]/*.copy() as! SKLabelNode*/)
        }
    }
}

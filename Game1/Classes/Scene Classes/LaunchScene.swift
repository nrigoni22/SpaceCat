//
//  LaunchScene.swift
//  Game1
//
//  Created by Nicola Rigoni on 08/12/22.
//

import SpriteKit

class LaunchScene: SKScene {
    
    var playBtn = SKSpriteNode()
    var scoreBtn = SKSpriteNode()
    var titleLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        inizialize()
    }
    
    func inizialize() {
        creatBG()
        getButtons()
        getTitle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if nodes(at: location).first == playBtn {
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene!.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!, transition: SKTransition.doorway(withDuration: 1.5))
            }
            
            if nodes(at: location).first == scoreBtn {
                
            }
        }
    }
    
    func creatBG() {
        let bg = SKSpriteNode(imageNamed: "backgroundSpace")
        bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bg.position = CGPoint(x: 0, y: 0)
        bg.zPosition = 0
        bg.setScale(2.0)
        self.addChild(bg)
    }
    
    func getButtons() {
        playBtn = self.childNode(withName: "Play") as! SKSpriteNode
        scoreBtn = self.childNode(withName: "Score") as! SKSpriteNode
    }
    
    func getTitle() {
        titleLabel = self.childNode(withName: "TitleLabel") as! SKLabelNode
        titleLabel.fontSize = 120
        titleLabel.text = "Game Name Here"
        titleLabel.zPosition = 5
        
        let moveUp = SKAction.moveTo(y: titleLabel.position.y + 30 , duration: 2)
        let moveDown = SKAction.moveTo(y: titleLabel.position.y - 30, duration: 2)
        
        let sequence = SKAction.sequence([moveUp, moveDown])
        
        titleLabel.run(SKAction.repeatForever(sequence))
    }
    
}

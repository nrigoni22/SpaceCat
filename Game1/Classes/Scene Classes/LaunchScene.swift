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
    
    var scoreTitleLabel = SKLabelNode()
    var highscoreLabel = SKLabelNode()
    var otherScoreLabel: [SKLabelNode] = []
    var backBtn = SKSpriteNode()
    
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
                scoreView()
            }
            
            if nodes(at: location).first == backBtn {
                backBtn.removeFromParent()
                scoreTitleLabel.removeFromParent()
                highscoreLabel.removeFromParent()
                
                
                self.addChild(playBtn)
                self.addChild(scoreBtn)
                self.addChild(titleLabel)
                inizialize()
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
    
    func scoreView() {
        playBtn.removeFromParent()
        scoreBtn.removeFromParent()
        titleLabel.removeFromParent()
        
        scoreTitleLabel = SKLabelNode(text: "Score Title Here")
        scoreTitleLabel.zPosition = 10
        scoreTitleLabel.fontSize = 80
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
        highscoreLabel.zPosition = 10
        highscoreLabel.fontSize = 50
        highscoreLabel.position = CGPoint(x: -200, y: 80);
        self.addChild(highscoreLabel)
        
        for index in 0..<5 {
            otherScoreLabel[index] = SKLabelNode(text: "Match \(index + 1):    \(UserDefaults.standard.integer(forKey: "Score\(index)"))")
            otherScoreLabel[index].zPosition = 10
            otherScoreLabel[index].fontSize = 50
            otherScoreLabel[index].position = CGPoint(x: -250, y: 20 - (60 * index));
            self.addChild(otherScoreLabel[index]/*.copy() as! SKLabelNode*/)
        }
    }
}

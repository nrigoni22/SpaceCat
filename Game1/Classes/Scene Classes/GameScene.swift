//
//  GameScene.swift
//  Game1
//
//  Created by Nicola Rigoni on 07/12/22.
//
// Buongiorno Nicola, ho fatto un po' di casino, non odiarmi ❤️
// (E vedi che crasha ancora sullo score. Comunque io non c'entro non l'ho toccato uu)
// Love you

import SpriteKit

enum GameStatus {
    case ready, pause, finisched, ongoing
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    let cam = SKCameraNode()
    let player = Player()
    let ground = Ground()
    let enemy = Enemy()
    let encounterManager = EncounterManager()
    
    var background: [Background] = []
    
    var canJump = false
    
    var screenCenterY = CGFloat()
    
    var scoreCounter = Timer()
    
    var spawnEnemy = Timer()
    
    var score: Int = -1
    
    var scoreLabel = SKLabelNode()
    
    let initialPlayerPosition = CGPoint(x: 500, y: 400)
    var playerProgress = CGFloat()
    
   let hud = HUD()
    
    var gameStatus: GameStatus = .ongoing {
        willSet {
            print("game Status: \(gameStatus)")
            switch gameStatus {
            case .ongoing:
                print("ongoing")
            default:
                break
            }
            
        }
    }
    
    override func didMove(to view: SKView) {
        inizialize()
    }
    
    func inizialize() {
        physicsWorld.contactDelegate = self
        getLabel()
        
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        screenCenterY = self.size.height / 2
        self.camera = cam
        
        //hud.createHearts(screenSize: self.size)
       // self.camera!.addChild(hud)
        
        for _ in 0..<3 {
            background.append(Background())
        }
        
        background[0].spawn(parentNode: self, imageName: "backgroundSpace", zPosition: -3, movementMultiplier: 0.1)
        background[1].spawn(parentNode: self, imageName: "schifo", zPosition: -2, movementMultiplier: 0.5)
//      background[2].spawn(parentNode: self, imageName: "Sprite", zPosition: -15, movementMultiplier: 0.2)

        ground.position = CGPoint(x: -self.size.width * 2, y: 100)
        ground.size = CGSize(width: self.size.width * 6, height: 0)
        ground.createChildren()
        self.addChild(ground)
        
        player.position = initialPlayerPosition
        player.zPosition = 3
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        //spawnEnemies()
        
        scoreCounter = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            self.incrementScore()
        })
        
//        spawnEnemy = Timer.scheduledTimer(withTimeInterval: 4, repeats: true, block: { _ in
//            self.spawnEnemies()
//        })
        
        encounterManager.addEncountersToScene(gameScene: self)
        encounterManager.encounters[0].position =
                           CGPoint(x: 400, y: 330)
    }
    
    //    override func didSimulatePhysics() {
    //       var cameraYPos = screenCenterY
    //        cam.yScale = 1
    //        cam.xScale = 1
    //
    ////        if player.position.y > screenCenterY {
    ////            cameraYPos = player.position.y
    ////            //let percentOfMaxHeight = (player.position.y - screenCenterY) / (player.maxHeight)
    ////        }
    //
    //        self.camera!.position = CGPoint(x: player.position.x + 500, y: cameraYPos)
    //        playerProgress = player.position.x + 500 - initialPlayerPosition.x
    //
    //        ground.checkForReposition(playerProgress: playerProgress)
    //
    //        for bg in self.background {
    //            bg.updatePosition(playerProgress: playerProgress)
    //        }
    //    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameStatus {
        case .ready:
            gameStatus = .ongoing
        case .ongoing:
            if canJump {
                canJump = false
                player.jumpAction()
                print("jump")
            }
            
        default:
            break
        }
    }
    
    
    func spawnEnemies() {
        
        let enemy = Enemy()//.copy() as! SKSpriteNode
        let bat = Bat()
        
        enemy.position = CGPoint(x: player.position.x + 1500, y: 120) //self.frame.width + 450
        bat.position = CGPoint(x: player.position.x + 1000, y: 250)
        
        self.addChild(enemy)
        self.addChild(bat)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        let cameraYPos = screenCenterY
        cam.yScale = 1
        cam.xScale = 1
        
        //        if player.position.y > screenCenterY {
        //            cameraYPos = player.position.y
        //            //let percentOfMaxHeight = (player.position.y - screenCenterY) / (player.maxHeight)
        //        }
        
        self.camera!.position = CGPoint(x: player.position.x + 500, y: cameraYPos)
        playerProgress = player.position.x + 500 - initialPlayerPosition.x
        
        ground.checkForReposition(playerProgress: playerProgress)
        
        for bg in self.background {
            bg.updatePosition(playerProgress: playerProgress)
        }
        
        scoreLabel.position.x = player.position.x
        
        switch gameStatus {
        case .ongoing:
            //print("rimettere update")
            player.update()
        default:
            break
        }
    }
    
    func getLabel() {
        scoreLabel = self.childNode(withName: "ScoreLabel") as! SKLabelNode
        self.scoreLabel.position = CGPoint(x: 100, y: 550)
        scoreLabel.text = "0M"
        scoreLabel.fontSize = 80
        scoreLabel.zPosition = 10
    }
    
    func incrementScore() {
        score += 1
        if score > 0 {
            scoreLabel.text = "\(score)M"
        }
    }
    
    func saveLastFive(score: Int) {
        let index: Int = UserDefaults.standard.integer(forKey: "Index")
        if index < 5 {
            UserDefaults.standard.set(score, forKey: "Score\(index)")
        } else {
            UserDefaults.standard.set(score, forKey: "Score\(0)")
        }
        let newIndex = index + 1
        UserDefaults.standard.set(newIndex, forKey: "Index")
    }
    
    func setHighscore(_ highscore: Int) {
        UserDefaults.standard.set(highscore, forKey: "Highscore")
    }
    
    func getHighscore() -> Int {
        UserDefaults.standard.integer(forKey: "Highscore")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "Player" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Ground" {
            print("Contact with ground and player")
            canJump = true
        }
        
        if firstBody.node?.name == "Player" && (secondBody.node?.name == "Enemy" || secondBody.node?.name == "Enemy2") {
            print("Contact with enemy and player")
            saveLastFive(score: score)
            
            if getHighscore() < score {
                setHighscore(score)
            }
            
            secondBody.node?.removeFromParent()
            
            let launchScene = LaunchScene(fileNamed: "LaunchScene")
            launchScene!.scaleMode = .aspectFill
            self.view?.presentScene(launchScene!, transition: SKTransition.doorway(withDuration: 1.5))
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}

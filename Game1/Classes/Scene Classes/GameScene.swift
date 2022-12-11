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
    
    //var canJump = false
    
    var screenCenterY = CGFloat()
    
    var scoreCounter = Timer()
    
    var spawnEnemy = Timer()
    
    var score: Int = -1
    
    var scoreLabel = SKLabelNode()
    
    let initialPlayerPosition = CGPoint(x: 500, y: 400)
    var playerProgress = CGFloat()
    
    var heartNode: [SKSpriteNode] = []
    
    var nextEncounterSpawnPosition = CGFloat(150)
    
    var isTouched: Bool = false
    
    var startPowerUpDistance: Int = 0
    
    //let hud = HUD()
    
    var gameStatus: GameStatus = .ongoing {
        willSet {
           // print("game Status: \(gameStatus)")
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
        getHeart()
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        screenCenterY = self.size.height / 2
        self.camera = cam
        
        for _ in 0..<3 {
            background.append(Background())
        }
        
        background[0].spawn(parentNode: self, imageName: "sfondo", zPosition: -3, movementMultiplier: 0.1)
        background[1].spawn(parentNode: self, imageName: "mont2-50", zPosition: -2, movementMultiplier: 0.5)
        background[2].spawn(parentNode: self, imageName: "mont01-50", zPosition: -1, movementMultiplier: 0.2)
        
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
        encounterManager.encounters[0].position = CGPoint(x: 400, y: 330)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameStatus {
        case .ready:
            gameStatus = .ongoing
        case .ongoing:
            if player.jump && !player.isFlying {
                player.jump = false
                player.jumpAction()
                print("PLAYER TOUCH JUMP")
            } else if player.isFlying {
                print("PLAYER TOUCH FLY")
                isTouched = true
            }
            
        default:
            break
        }
        
    }
    
    
   //
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouched = false
        if player.isFlying {
            player.stopFlying()
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
        var cameraYPos = screenCenterY
        cam.yScale = 1
        cam.xScale = 1
        
        if player.position.y > screenCenterY {
            cameraYPos = player.position.y
        }
        
        self.camera!.position = CGPoint(x: player.position.x + 500, y: cameraYPos)
        playerProgress = player.position.x + 500 - initialPlayerPosition.x
        
        ground.checkForReposition(playerProgress: playerProgress)
        
        for bg in self.background {
            bg.updatePosition(playerProgress: playerProgress)
        }
        
        scoreLabel.position.x = player.position.x
        scoreLabel.position.y = cameraYPos + 200
        
        for index in 0..<3 {
            //print("heart pos: \(heart.position.x)")
            heartNode[index].position.x = player.position.x + (heartNode[index].size.width + CGFloat(55 * index) - 100)
            heartNode[index].position.y = scoreLabel.position.y - 50
            
        }
        
        if player.isFlying && isTouched {
            if score - startPowerUpDistance < 10 {
                print("FLYING")
                player.flyAction()
                
            } else {
                print("END FLYING")
                player.isFlying = false
                isTouched = false
                player.removeAllActions()
                player.catRunAnimation()
            }
            
        }
        
        // Check to see if we should set a new encounter:
        if player.position.x > nextEncounterSpawnPosition {
            encounterManager.placeNextEncounter(
                currentXPos: nextEncounterSpawnPosition)
            nextEncounterSpawnPosition += 1200
        }
        
        switch gameStatus {
        case .ongoing:
            player.update()
        default:
            break
        }
    }
    func removeHeart(lifeRemaining: Int) {
        
        let fadeAction = SKAction.fadeAlpha(to: 0.2, duration: 0.3)
        if lifeRemaining < 3 {
            heartNode[lifeRemaining].run(fadeAction)
        }
        
    }
    
    func addHeart(life: Int) {
        //print("life index add: \(life)")
        let fadeAction = SKAction.fadeAlpha(to: 1, duration: 0.3)
        
        heartNode[life - 1].run(fadeAction)
    }
    func getLabel() {
        scoreLabel = self.childNode(withName: "ScoreLabel") as! SKLabelNode
        self.scoreLabel.position = CGPoint(x: 100, y: 550)
        scoreLabel.text = "0M"
        scoreLabel.fontSize = 80
        scoreLabel.zPosition = 10
    }
    
    func getHeart() {
        for index in 0..<3 {
            let heartNode = SKSpriteNode(imageNamed: "heart-full")
            heartNode.position = CGPoint(x: 500 + (Int(heartNode.size.width) + 30 * index), y: 300)
            heartNode.zPosition = 10
            heartNode.alpha = 1
            self.heartNode.append(heartNode)
            self.addChild(self.heartNode[index])
        }
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
        
        //print("Contact body: \(secondBody.node?.name)")
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Ground" {
            print("Contact with ground and player")
            player.jump = true
        }
        
        if firstBody.node?.name == "Player" && (secondBody.node?.name == "Enemy" || secondBody.node?.name == "Enemy2") {
            print("Contact with enemy and player")
            
            if player.health != 0 {
                print("take damage")
                player.takeDamage()
                
                removeHeart(lifeRemaining: player.health)
            }
            if player.health == 0 {
                //print("back home")
                saveLastFive(score: score)
                
                if getHighscore() < score {
                    setHighscore(score)
                }
                player.isFlying = false
                secondBody.node?.removeFromParent()
                
                let launchScene = LaunchScene(fileNamed: "LaunchScene")
                launchScene!.scaleMode = .aspectFill
                self.view?.presentScene(launchScene!, transition: SKTransition.doorway(withDuration: 1.5))
            }
        }
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Heart" {
            print("contact between player and heart")
            player.addLife()
            addHeart(life: player.health)
            //secondBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "PowerUp" {
            print("contact between player and powerUp")
            startPowerUpDistance = score
            player.isFlying = true
            secondBody.node?.removeFromParent()
        }
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}

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
    
    var background2: [BackgroundY] = []
    
    //var canJump = false
    
    var screenCenterY = CGFloat()
    var screenCenterX = CGFloat()
    
    var scoreCounter = Timer()
    
    var spawnEnemy = Timer()
    
    var score: Int = -1
    
    var scoreLabel = SKLabelNode()
    var pauseBtn = SKSpriteNode()
    var tree = SKSpriteNode()
    var tree2 = SKSpriteNode()
    var tree3 = SKSpriteNode()
    
    var tree4 = SKSpriteNode()
    var tree5 = SKSpriteNode()
    
    let initialPlayerPosition = CGPoint(x: 500, y: 400)
    var playerProgress = CGFloat()
    
    var heartNode: [SKSpriteNode] = []
    
    var nextEncounterSpawnPosition = CGFloat(150)
    
    var isTouched: Bool = false
    
    var startPowerUpDistance: Int = 0
    var daCencellare: Int = 0
    var gamePaused: Bool = false
    var playerDead: Bool = false
    //let hud = HUD()
    let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    
    
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
        getButtons()
        getHeart()
        getTree()
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        screenCenterY = self.size.height / 2
        screenCenterX = self.size.height / 2
        self.camera = cam
        
        for _ in 0..<3 {
            background.append(Background())
        }
        
        background[0].spawn(parentNode: self, imageName: "sfondo", zPosition: -4, movementMultiplier: 0.1)
        background[1].spawn(parentNode: self, imageName: "mont2-50", zPosition: -2, movementMultiplier: 0.5)
        background[2].spawn(parentNode: self, imageName: "mont01-50", zPosition: -1, movementMultiplier: 0.2)
        //background[3].spawn(parentNode: self, imageName: "star", zPosition: -3, movementMultiplier: 0.1)
        //background[0].spawn(parentNode: self, imageName: "t", zPosition: -3, movementMultiplier: 0.1)
        
        background2.append(BackgroundY())
        background2[0].spawn(parentNode: self, imageName: "sfondo2", zPosition: -5, movementMultiplier: 0.1)
        
        ground.position = CGPoint(x: -self.size.width * 2, y: 105)
        ground.size = CGSize(width: self.size.width * 6, height: 0)
        ground.createChildren()
        self.addChild(ground)
        
        player.position = initialPlayerPosition
        player.zPosition = 3
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5.8)
        //spawnEnemies()
        
        scoreCounter = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            self.incrementScore()
        })
        
        spawnEnemy = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
            //self.spawnEnemies()
            self.getTree()
        })
        
        encounterManager.addEncountersToScene(gameScene: self)
        encounterManager.encounters[0].position = CGPoint(x: 400, y: 330)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if nodes(at: location).first == pauseBtn {
                print("PAUSE")
                gamePaused = true
                scoreCounter.invalidate()
                //scene?.isPaused = true
                //addPauseView(text: "Title", isEnded: false)
                
            } else if nodes(at: location).first!.name == "Quit" {
                print("Quit")
                //scene?.isPaused = true
                //addPauseView(text: "Title", isEnded: false)
                let launchScene = LaunchScene(fileNamed: "LaunchScene")
                launchScene!.scaleMode = .aspectFill
                self.view?.presentScene(launchScene!, transition: SKTransition.doorway(withDuration: 1.5))
                
            } else if nodes(at: location).first!.name == "Play" {
                print("Play")
                gamePaused = false
                scene?.isPaused = false
                self.childNode(withName: "Label")?.removeFromParent()
                self.childNode(withName: "Play")?.removeFromParent()
                self.childNode(withName: "Quit")?.removeFromParent()
                scoreCounter = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
                    self.incrementScore()
                })
                //scene?.isPaused = true
                //addPauseView(text: "Title", isEnded: false)
                
            } else if nodes(at: location).first!.name == "Restart" {
                print("Restart")
                gamePaused = false
                scene?.isPaused = false
                playerDead = false
                //addPauseView(text: "Title", isEnded: false)
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene!.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 1.5))
                
            } else {
                if player.jump && !player.isFlying {
                    player.jump = false
                    player.jumpAction()
                    print("PLAYER TOUCH JUMP")
                } else if player.isFlying {
                    print("PLAYER TOUCH FLY")
                    isTouched = true
                }
            }
        }
    }

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
        
        for bg in self.background2 {
            bg.updatePosition(playerProgress: playerProgress)
        }
        
        scoreLabel.position.x = player.position.x
        scoreLabel.position.y = cameraYPos + 200
        
        for index in 0..<3 {
            //print("heart pos: \(heart.position.x)")
            
            heartNode[index].position.x = player.position.x + (heartNode[index].size.width + CGFloat(50 * index) - 100)
            heartNode[index].position.y = scoreLabel.position.y - 50
            
        }
        
        pauseBtn.position.x = player.position.x + 1050
        pauseBtn.position.y = cameraYPos + 200
        
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
        
        if gamePaused {
            addPauseView(text: "Title", isEnded: false, positionX: player.position.x, positionY: cameraYPos)
        }
        
        if playerDead {
            let fadeAction = SKAction.fadeAlpha(to: 0.2, duration: 0.3)
            heartNode[0].run(fadeAction) {
                self.run(SKAction.wait(forDuration: 0.5)) {
                    self.addPauseView(text: "Title", isEnded: true, positionX: self.player.position.x, positionY: cameraYPos)
                }
                
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
            player.update(distance: score)
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
    
    func getButtons() {
        pauseBtn = self.childNode(withName: "Pause") as! SKSpriteNode
        pauseBtn.position.y = 550
        pauseBtn.zPosition = 10
    }
    
    func getTree() {
        tree = self.childNode(withName: "Tree") as! SKSpriteNode
        tree.position.y = 200
        tree.position.x = player.position.x + 1500
        tree.zPosition = 0
        tree4 = self.childNode(withName: "Tree4") as! SKSpriteNode
        tree4.position.y = 180
        tree4.position.x = player.position.x + 1750
        tree4.zPosition = 0
        tree5 = self.childNode(withName: "Tree5") as! SKSpriteNode
        tree5.position.y = 240
        tree5.position.x = player.position.x + 2900
        tree5.zPosition = 0
        
        tree2 = self.childNode(withName: "Tree2") as! SKSpriteNode
        tree2.position.y = 240
        tree2.position.x = player.position.x + 2000
        tree2.zPosition = 0
        tree3 = self.childNode(withName: "Tree3") as! SKSpriteNode
        tree3.position.y = 180
        tree3.position.x = player.position.x + 2500
        tree3.zPosition = 0
    }
    
    func getHeart() {
        for index in 0..<3 {
            let heartNode = SKSpriteNode(imageNamed: "heart")
            heartNode.position = CGPoint(x: 500 + (Int(heartNode.size.width) + 30 * index), y: 300)
            heartNode.zPosition = 10
            heartNode.alpha = 1
            heartNode.size = CGSize(width: 40, height: 30)
            self.heartNode.append(heartNode)
            self.addChild(self.heartNode[index])
        }
    }
    
    func addPauseView(text: String, isEnded: Bool, positionX: CGFloat, positionY: CGFloat) {
        
        scoreCounter.invalidate()
        
        let label = SKLabelNode(text: text)
        label.fontSize = 120
        label.name = "Label"
        label.zPosition = 10
        label.position = CGPoint(x: positionX + 500, y: positionY + 150)
        let moveUp = SKAction.moveTo(y: positionY + 30 , duration: 2)
        let moveDown = SKAction.moveTo(y: positionY - 30, duration: 2)
        
        let sequence = SKAction.sequence([moveUp, moveDown])
        
        label.run(SKAction.repeatForever(sequence))
        self.addChild(label)
        
        let restartBtn = SKSpriteNode(imageNamed: "Quit")
        restartBtn.name = "Quit"
        restartBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        restartBtn.position = CGPoint(x: positionX + 380, y: positionY - 100)
        restartBtn.zPosition = 10
        //restartBtn.setScale(0.5)
        self.addChild(restartBtn)
        
        if isEnded {
            let quitBtn = SKSpriteNode(imageNamed: "Restart")
            quitBtn.name = "Restart"
            quitBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            quitBtn.position = CGPoint(x: restartBtn.position.x + 250, y: positionY - 100)
            quitBtn.zPosition = 10
            //restartBtn.setScale(0.5)
            self.addChild(quitBtn)
        } else {
            let playBtn = SKSpriteNode(imageNamed: "Play")
            playBtn.name = "Play"
            playBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            playBtn.position = CGPoint(x: restartBtn.position.x + 250, y: positionY - 100)
            playBtn.zPosition = 10
            //restartBtn.setScale(0.5)
            self.addChild(playBtn)
        }
        
        
        scene?.isPaused = true
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
        
        if firstBody.node?.name == "Player" && (secondBody.node?.name == "Ground" || secondBody.node?.name == "PlatformType")  {
            daCencellare += 1
            print("Contact with ground and player \(daCencellare)")
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
                print("back home")
                saveLastFive(score: score)
                
                if getHighscore() < score {
                    setHighscore(score)
                }
                player.isFlying = false
                secondBody.node?.removeFromParent()
                
                playerDead = true
//                let launchScene = LaunchScene(fileNamed: "LaunchScene")
//                launchScene!.scaleMode = .aspectFill
//                self.view?.presentScene(launchScene!, transition: SKTransition.doorway(withDuration: 1.5))
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

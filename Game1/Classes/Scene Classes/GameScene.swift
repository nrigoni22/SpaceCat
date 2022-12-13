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
import AVFoundation

enum GameStatus {
    case ready, pause, finisched, ongoing
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    let audioManager = AudioManager()
    
    let cam = SKCameraNode()
    let player = Player()
    let ground = Ground()
    let enemyMonster = EnemyMonster()
    let encounterManager = EncounterManager()
    
    
    var backgroundMusic: AVAudioPlayer!
    
    var background: [Background] = []
    var background2: [BackgroundY] = []
    
    var screenCenterY = CGFloat()
    var screenCenterX = CGFloat()
    
    var scoreCounter = Timer()
    
    var spawnTree = Timer()
    
    var score: Int = -1
    
    var scoreLabel = SKLabelNode()
    var pauseBtn = SKSpriteNode()
    var tree = SKSpriteNode()
    var tree2 = SKSpriteNode()
    var tree3 = SKSpriteNode()
    var planet1 = SKSpriteNode()
    var planet2 = SKSpriteNode()
    
    var tree4 = SKSpriteNode()
    var tree5 = SKSpriteNode()
    var tree6 = SKSpriteNode()
    var tree7 = SKSpriteNode()
    var tree8 = SKSpriteNode()
    var tree9 = SKSpriteNode()
    var tree10 = SKSpriteNode()
    
    var initialPlayerPosition = CGPoint(x: 50, y: 400)
    var playerProgress = CGFloat()
    
    var heartNode: [SKSpriteNode] = []
    
    var nextEncounterSpawnPosition = CGFloat(150)
    
    var isTouched: Bool = false
    
    var startPowerUpDistance: Int = 0
    var daCencellare: Int = 0
    var gamePaused: Bool = false
    var playerDead: Bool = false
    let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var sceneIndex: Int = 0
    
    let path = Bundle.main.path(forResource: "music_zapsplat_space_trivia", ofType: "mp3")
    
    
    var gameStatus: GameStatus = .ongoing {
        willSet {
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
        startMusic()
        self.anchorPoint = .zero
        physicsWorld.contactDelegate = self
        getLabel()
        getButtons()
        getHeart()
        getPlanet()
        getTree()
        getTree2()
        
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        screenCenterY = self.size.height / 2
        screenCenterX = self.size.height / 2
        self.camera = cam
        
        for _ in 0..<3 {
            background.append(Background())
        }
        
        background[0].spawn(parentNode: self, imageName: "sfondo2bis", zPosition: -4, movementMultiplier: 0.1)
        background[1].spawn(parentNode: self, imageName: "mont2-50", zPosition: -2, movementMultiplier: 0.5)
        background[2].spawn(parentNode: self, imageName: "mont01-50", zPosition: -1, movementMultiplier: 0.2)
        //background[3].spawn(parentNode: self, imageName: "star", zPosition: -3, movementMultiplier: 0.1)
        //background[0].spawn(parentNode: self, imageName: "t", zPosition: -3, movementMultiplier: 0.1)
        
        background2.append(BackgroundY())
        background2[0].spawn(parentNode: self, imageName: "planetscreen", zPosition: -5, movementMultiplier: 0.1)
        
        ground.position = CGPoint(x: -self.size.width * 2, y: 105)
        ground.size = CGSize(width: self.size.width * 6, height: 0)
        ground.createChildren()
        self.addChild(ground)
        
        player.position = initialPlayerPosition
        player.zPosition = 3
        
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -8.5)
        
        scoreCounter = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            self.incrementScore()
        })
        
        spawnTree = Timer.scheduledTimer(withTimeInterval: 14, repeats: true, block: { _ in
            //print("TIMER1")
            self.getTree()
        })
        
        Timer.scheduledTimer(withTimeInterval: 14, repeats: true, block: { _ in
            self.getTree2()
            //print("TIMER2")
        })
        
        encounterManager.addEncountersToScene(gameScene: self)
        encounterManager.encounters[0].position = CGPoint(x: 400, y: 330)
    }
    
    
    
    func startMusic() {
        let url = URL(filePath: path!)
        backgroundMusic = try! AVAudioPlayer(contentsOf: url)
        backgroundMusic.numberOfLoops = -1
        backgroundMusic.play()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if nodes(at: location).first == pauseBtn {
                print("PAUSE")
                pauseBtn.alpha = 0
                gamePaused = true
                scoreCounter.invalidate()
                
            } else if nodes(at: location).first!.name == "Quit" {
                print("Quit")
                backgroundMusic.stop()
                let launchScene = LaunchScene(fileNamed: "LaunchScene")
                launchScene!.scaleMode = .aspectFill
                self.view?.presentScene(launchScene!, transition: SKTransition.doorway(withDuration: 1.5))
                
            } else if nodes(at: location).first!.name == "Play" {
                print("Play")
                gamePaused = false
                pauseBtn.alpha = 1
                scene?.isPaused = false
                self.childNode(withName: "Label")?.removeFromParent()
                self.childNode(withName: "Play")?.removeFromParent()
                self.childNode(withName: "Quit")?.removeFromParent()
                scoreCounter = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
                    self.incrementScore()
                })
                
            } else if nodes(at: location).first!.name == "Restart" {
                print("Restart")
                backgroundMusic.stop()
                gamePaused = false
                scene?.isPaused = false
                playerDead = false
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
    
    
    override func update(_ currentTime: TimeInterval) {
        
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
            
            heartNode[index].position.x = player.position.x + (heartNode[index].size.width + CGFloat(50 * index) - 100)
            heartNode[index].position.y = scoreLabel.position.y - 50
        }
        
        planet1.position.x = player.position.x + 800
        planet2.position.x = player.position.x + 110
        
        pauseBtn.position.x = player.position.x + 1050
        pauseBtn.position.y = cameraYPos + 200
        
        if player.isFlying && isTouched {
            if score - startPowerUpDistance < 20 {
                print("FLYING")
                player.flyAction()
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
            } else {
                print("END FLYING")
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -8.5)
                player.isFlying = false
                isTouched = false
                player.removeAllActions()
                player.catRunAnimation()
            }
            
        }
        
        if gamePaused {
            addPauseView(text: "", isEnded: false, positionX: player.position.x, positionY: cameraYPos)
        }
        
        if playerDead {
            let fadeAction = SKAction.fadeAlpha(to: 0.2, duration: 0.3)
            pauseBtn.alpha = 0
            heartNode[0].run(fadeAction) {
                self.run(SKAction.wait(forDuration: 0.5)) {
                    self.player.run(self.player.catDeadAnimation) {
                        self.addPauseView(text: "Game Over", isEnded: true, positionX: self.player.position.x, positionY: cameraYPos)
                    }
                }
            }
        }
        
        if player.position.x > nextEncounterSpawnPosition {
            encounterManager.placeNextEncounter(
                currentXPos: nextEncounterSpawnPosition)
            nextEncounterSpawnPosition += 2000
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
        let fadeAction = SKAction.fadeAlpha(to: 1, duration: 0.3)
        heartNode[life - 1].run(fadeAction)
    }
    func getLabel() {
        scoreLabel = self.childNode(withName: "ScoreLabel") as! SKLabelNode
        self.scoreLabel.position = CGPoint(x: 100, y: 550)
        scoreLabel.fontName = "8-bit Arcade In"
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
        
        tree2 = self.childNode(withName: "Tree2") as! SKSpriteNode
        tree2.position.y = 240
        tree2.position.x = player.position.x + 2000
        tree2.zPosition = 0
        tree3 = self.childNode(withName: "Tree3") as! SKSpriteNode
        tree3.position.y = 180
        tree3.position.x = player.position.x + 2500
        tree3.zPosition = 0
        
        
        tree4 = self.childNode(withName: "Tree4") as! SKSpriteNode
        tree4.position.y = 180
        tree4.position.x = player.position.x + 1750
        tree4.zPosition = 0
        tree5 = self.childNode(withName: "Tree5") as! SKSpriteNode
        tree5.position.y = 240
        tree5.position.x = player.position.x + 2900
        tree5.zPosition = 0
    }
    
    func getTree2() {
        tree6 = self.childNode(withName: "Tree6") as! SKSpriteNode
        tree6.position.y = 200
        tree6.position.x = player.position.x + 3500
        tree6.zPosition = 0
        
        tree7 = self.childNode(withName: "Tree7") as! SKSpriteNode
        tree7.position.y = 240
        tree7.position.x = player.position.x + 4000
        tree7.zPosition = 0
        
        tree8 = self.childNode(withName: "Tree8") as! SKSpriteNode
        tree8.position.y = 180
        tree8.position.x = player.position.x + 4500
        tree8.zPosition = 0
        
        tree9 = self.childNode(withName: "Tree9") as! SKSpriteNode
        tree9.position.y = 180
        tree9.position.x = player.position.x + 5000
        tree9.zPosition = 0
        
        tree10 = self.childNode(withName: "Tree10") as! SKSpriteNode
        tree10.position.y = 240
        tree10.position.x = player.position.x + 5500
        tree10.zPosition = 0
    }
    
    func getPlanet() {
        planet1 = self.childNode(withName: "Planet1") as! SKSpriteNode
        planet1.position.y = 950
        planet1.position.x = player.position.x + 1000
        planet1.zPosition = 0
        
        
        planet2 = self.childNode(withName: "Planet2") as! SKSpriteNode
        planet2.position.y = 1000
        planet2.position.x = player.position.x + 2000
        planet2.zPosition = 0
        
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
        label.fontName = "8-bit Arcade In"
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
            self.addChild(quitBtn)
        } else {
            let playBtn = SKSpriteNode(imageNamed: "Play")
            playBtn.name = "Play"
            playBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            playBtn.position = CGPoint(x: restartBtn.position.x + 250, y: positionY - 100)
            playBtn.zPosition = 10
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
        var newIndex: Int = index
        if index < 5 {
            newIndex = index + 1
            UserDefaults.standard.set(score, forKey: "Score\(index)")
        } else {
            newIndex = 0
            UserDefaults.standard.set(score, forKey: "Score\(0)")
        }
        print("newIndex: \(newIndex)")
        print("index \(index)")
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
            player.jumpCount = 0
            //player.groundFly = true
            if player.isFlying {
                player.catRunRocketAnimation()
            }
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "FakeBody" {
            print("Contact fake body")
        }
        
        
        if firstBody.node?.name == "Player" && (secondBody.node?.name == "Enemy" || secondBody.node?.name == "Enemy2") {
            print("Contact with enemy and player")
            
            if player.health != 0 {
                print("take damage")
                player.takeDamage()
                self.run(audioManager.playEnemySound())
                
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
            }
        }
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Heart" {
            print("contact between player and heart")
            player.addLife()
            addHeart(life: player.health)
            self.run(audioManager.playGetHeartSound())
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "PowerUp" {
            print("contact between player and powerUp")
            startPowerUpDistance = score
            if !player.isFlying {
                player.catRunRocketAnimation()
            }
            player.isFlying = true
            //player.groundFly = true
            secondBody.node?.removeFromParent()
            self.run(audioManager.playPowerUpSound())
        }
        
    }
    
//    func didEnd(_ contact: SKPhysicsContact) {
//        var firstBody = SKPhysicsBody()
//        var secondBody = SKPhysicsBody()
//
//        if contact.bodyA.node?.name == "Player" {
//            firstBody = contact.bodyA
//            secondBody = contact.bodyB
//        } else {
//            firstBody = contact.bodyB
//            secondBody = contact.bodyA
//        }
//
//        if firstBody.node?.name == "Player" && (secondBody.node?.name == "Ground" || secondBody.node?.name == "PlatformType")  {
//            player.groundFly = false
//        }
//    }
}

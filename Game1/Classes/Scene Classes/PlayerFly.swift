////
////  PlayerFly.swift
////  Game1
////
////  Created by Marta Michelle Caliendo on 10/12/22.
////
//
//import SpriteKit
//
//class PlayerFly: SKSpriteNode, GameSprite {
//    
//    var initialSize: CGSize = CGSize(width: 190, height: 140)
//    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Player")
//    var catFlyAnimation: SKAction = SKAction()
//    var flyAnimation: SKAction = SKAction()
//    var soarAnimation: SKAction = SKAction()
//    
//    var flapping: Bool = false
//    
//    let maxFlappingForce: CGFloat = 57000
//    
//    let maxHeight: CGFloat = 1000
//    
//    init() {
//        super.init(texture: nil, color: .clear, size: initialSize)
//        createAnimation()
//        
//        // self.run(soarAnimation, withKey: "soarAnimation")
//        //    let bodyTexture = textureAtlas.textureNamed("Spacecat4")
//        
//        
//        self.name = "Player"
//        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
//        self.physicsBody?.linearDamping = 0.9
//        self.physicsBody?.mass = 10
//        self.physicsBody?.affectedByGravity = true
//        self.physicsBody?.allowsRotation = false
//        self.physicsBody?.categoryBitMask = ColliderType.player
//        self.physicsBody?.collisionBitMask = ColliderType.ground | ColliderType.enemy | ColliderType.powerUp
//        self.physicsBody?.contactTestBitMask = ColliderType.ground | ColliderType.enemy | ColliderType.powerUp
//        self.physicsBody?.restitution = 0.0
//        
//        self.run(catFlyAnimation)
//        
//        
//    }
//    
//    func createAnimation() {
//        let rotateUpAction = SKAction.rotate(toAngle: 0, duration: 0.475)
//        rotateUpAction.timingMode = .easeOut
//        let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 0.2)
//        rotateDownAction.timingMode = .easeIn
//        
//        let catFrames: [SKTexture] = [textureAtlas.textureNamed("Spacecat1"),
//                                      textureAtlas.textureNamed("Spacecat2"),
//                                      textureAtlas.textureNamed("Spacecat3")]
//        
//        let catAction = SKAction.animate(with: catFrames, timePerFrame: 0.2)
//        catFlyAnimation = SKAction.group([SKAction.repeatForever(catAction), rotateUpAction])
//        
//        let soarFrames: [SKTexture] =
//        [textureAtlas.textureNamed("Spaacecat3")]
//        let soarAction = SKAction.animate(with:
//                                            soarFrames,
//                                          timePerFrame: 1)
//        
//        soarAnimation = SKAction.group([SKAction.repeatForever(soarAction),
//                                        rotateDownAction
//                                       ]) }
//    
//    func onTap() { }
//    
//    func update() {
//        
//        if self.flapping {
//            var forceToApply = maxFlappingForce
//            if position.y > 600 {
//                let percentageOfMaxHeight = position.y / maxHeight
//                let flappingForceSubtraction =
//                percentageOfMaxHeight * maxFlappingForce
//                forceToApply -= flappingForceSubtraction
//            }
//            
//            self.physicsBody?.applyForce(CGVector(dx: 0, dy: forceToApply))
//        }
//        
//        if self.physicsBody!.velocity.dy > 300 {
//            self.physicsBody!.velocity.dy = 300
//        }
//        
//        self.physicsBody?.velocity.dx = 200
//    }
//    
////    func startFlapping() {
////        self.removeAction(forKey: "soarAnimation")
////        self.run(flyAnimation, withKey: "flapAnimation")
////        self.flapping = true
////    }
//    
////    func stopFlapping() {
////        self.removeAction(forKey: "flapAnimation")
////        self.run(soarAnimation, withKey: "soarAnimation")
////        self.flapping = false
////    }
//    
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//}

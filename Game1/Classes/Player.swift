//
//  Player.swift
//  Game1
//
//  Created by Nicola Rigoni on 07/12/22.
//


import SpriteKit


struct ColliderType {
    static let player: UInt32 = 1
    static let ground: UInt32 = 2
    static let enemy: UInt32 = 4
    static let powerUp: UInt32 = 8
}

class Player: SKSpriteNode, GameSprite {
    
    
    
    var initialSize: CGSize = CGSize(width: 190, height: 140)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Player")
    var catAnimation: SKAction = SKAction()
    
    
    var jump: Bool = false
    let maxHeight:CGFloat = 1000
    var isFlying: Bool = false
    let maxFlappingForce:CGFloat = 137000
    
    init() {
        
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        
    
        self.name = "Player"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)  //(texture: bodyTexture, size: self.size)
        self.physicsBody?.linearDamping = 0.9
        self.physicsBody?.mass = 10
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = ColliderType.player
        self.physicsBody?.collisionBitMask = ColliderType.ground | ColliderType.enemy | ColliderType.powerUp
        self.physicsBody?.contactTestBitMask = ColliderType.ground | ColliderType.enemy | ColliderType.powerUp
        self.physicsBody?.restitution = 0.0
        
        self.run(catAnimation)
    }
    
    func update() {
        self.position.x += 6
        
//        if isFlying {
//            flyAction()
//        }
        
    }
    
    func jumpAction() {
        self.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 6400.0))
        textureJumping()
    }
    
    func flyAction() {
        //if isFlying {
            var forceToApply = maxFlappingForce
            
            // Apply less force if Pierre is above position 600
            if position.y > 600 {
                // The higher Pierre goes, the more force we
                // remove. These next three lines determine the
                // force to subtract:
                let percentageOfMaxHeight = position.y / maxHeight
                let flappingForceSubtraction =
                    percentageOfMaxHeight * maxFlappingForce
                forceToApply -= flappingForceSubtraction
            }
            // Apply the final force:
            self.physicsBody?.applyForce(CGVector(dx: 0, dy:
                forceToApply))
        //}
        
        if self.physicsBody!.velocity.dy > 300 {
            self.physicsBody!.velocity.dy = 300
        }
    }
    
    func createAnimation() {
        let rotateUpAction = SKAction.rotate(toAngle: 0, duration: 0.475)
        rotateUpAction.timingMode = .easeOut
        let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 0.2)
        rotateDownAction.timingMode = .easeIn
        
        let catFrames: [SKTexture] = [textureAtlas.textureNamed("Spacecat1"),
                                      textureAtlas.textureNamed("Spacecat2"),
                                      textureAtlas.textureNamed("Spacecat3")]
        
        let catAction = SKAction.animate(with: catFrames, timePerFrame: 0.2)
        catAnimation = SKAction.group([SKAction.repeatForever(catAction), rotateUpAction])
        
    }
    
    func textureJumping() {
        let rotateUpAction = SKAction.rotate(toAngle: 0, duration: 0.475)
        rotateUpAction.timingMode = .easeOut
        let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 0.2)
        rotateDownAction.timingMode = .easeIn
        
        let frame: [SKTexture] = [textureAtlas.textureNamed("Spacecat2")]
        let actionFrame = SKAction.animate(with: frame, timePerFrame: 0.9)
        let frame2: [SKTexture] = [textureAtlas.textureNamed("Spacecat4")]
        let actionFrame2 = SKAction.animate(with: frame2, timePerFrame: 0.5)
        //let frame3: [SKTexture] = [textureAtlas.textureNamed("Spacecat7")]
        //let actionFrame3 = SKAction.animate(with: frame3, timePerFrame: 0.25)
        let sequence = SKAction.sequence([actionFrame, actionFrame2])
        self.run(sequence)
        
    }
    
    
    func onTap() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//
//  Player.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 07/12/22.
//


import SpriteKit


struct ColliderType {
//    static let nulla: UInt32 = 0
    static let player: UInt32 = 1
    static let ground: UInt32 = 2
    static let enemy: UInt32 = 4
    static let damageCat: UInt32 = 5
    static let powerUp: UInt32 = 8
    static let fake: UInt32 = 16
    static let lifeUp: UInt32 = 3
    
}

class Player: SKSpriteNode, GameSprite {
    
    var initialSize: CGSize = CGSize(width: 135, height: 82)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Player")
    var catAnimation: SKAction = SKAction()
    var catFlyAnimation: SKAction = SKAction()
    var soarAnimation: SKAction = SKAction()
    var catRocketAnimation: SKAction = SKAction()
    var catDeadAnimation: SKAction = SKAction()
    
    var isDead: Bool = false
    var jump: Bool = false
    let maxHeight:CGFloat = 1100
    var isFlying: Bool = false
    let maxFlappingForce:CGFloat = 137000
    
    var health: Int = 3
    var invulnerable = false
    var damage = false
    var damageAnimation = SKAction()
    //var dieAnimation = SKAction()
    var jumpTimer = Timer()
    var jumpCount = 0
    //var groundFly = false
    
    
    
    init() {
        
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        
        
        self.name = "Player"
        let bodyTexture = textureAtlas.textureNamed("Catspace1")
        self.physicsBody = SKPhysicsBody(texture: bodyTexture, size: CGSize(width: self.size.width - 5, height: self.size.height - 10))  //(texture: bodyTexture, size: self.size)
        self.physicsBody?.linearDamping = 0.9
        self.physicsBody?.mass = 10
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = ColliderType.player
        self.physicsBody?.collisionBitMask = ColliderType.ground | ColliderType.enemy | ColliderType.powerUp | ColliderType.fake
        self.physicsBody?.contactTestBitMask = ColliderType.ground | ColliderType.enemy | ColliderType.powerUp | ColliderType.fake
        self.physicsBody?.restitution = 0.0
        
        catRunAnimation()
    }
    
    func update(distance: Int) {
        if !isDead {
            
            if distance >= 50 && distance < 100 {
                self.position.x += 8
                //print("1")
            }
            if distance >= 100 && distance < 150 {
                self.position.x += 8.5
               // print("2")
            }
            if distance >= 150 && distance < 200 {
                self.position.x += 9.5
                //print("3")
            }
            
            if distance >= 200 && distance < 250 {
                self.position.x += 12
                //print("4")
            }
            if distance >= 250 && distance < 300 {
                self.position.x += 13
                //print("4")
            }
            if distance > 300 {
                self.position.x += 14
                //print("4")
            }

            if distance < 50 {
                self.position.x += 8               //print("5")
            }
            
        }
        
    }
    
    func catRunAnimation() {
        print("catAnimation")
        removeAction(forKey: "catFlyAnimation")
        self.run(catAnimation, withKey: "catAnimation")
        self.size = CGSize(width: 135, height: 82)
    }
    
    func catRunRocketAnimation() {
        removeAction(forKey: "catFlyAnimation")
        removeAction(forKey: "catAnimation")
        print("catRocketAnimation")
        self.run(catRocketAnimation, withKey: "catRocketAnimation")
        self.size = CGSize(width: 135, height: 82)
    }
    
    func jumpAction() {
        self.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 6700.0))
        textureJumping()
        
        if jumpCount < 1 {
            print("jump count prima")
            self.jumpTimer.invalidate()
            jumpTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: { _ in
                self.jump = true

                self.jumpTimer.invalidate()

                print("jump count \(self.jumpCount)")
                self.jumpCount += 1
            })
            print("jump count dopo")
            
        } else {
            self.jump = false
        }
        print("jump count fine")
    }
    
    func flyAction() {
        print("IN FLY ACTION")
        removeAction(forKey: "catAnimation")
        //            removeAction(forKey: "catRocketAnimation")
        self.run(catFlyAnimation, withKey: "catFlyAnimation")
        self.size = CGSize(width: 82, height: 130)
        
        print("fly texture")
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
        self.physicsBody?.applyForce(CGVector(dx: 0, dy: forceToApply))
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
        
        let catFrames: [SKTexture] = [
            textureAtlas.textureNamed("ombra1"),
            textureAtlas.textureNamed("ombra2"),
            textureAtlas.textureNamed("ombra3")
        ]
        
        let catAction = SKAction.animate(with: catFrames, timePerFrame: 0.2)
        catAnimation = SKAction.group([SKAction.repeatForever(catAction), rotateUpAction])
        
        let damageStart = SKAction.run {
            self.physicsBody?.categoryBitMask = ColliderType.damageCat
        }
        
        let slowFade = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.35),
            SKAction.fadeAlpha(to: 0.7, duration: 0.35)
        ])
        let lastFade = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.2),
            SKAction.fadeAlpha(to: 0.7, duration: 0.2)])
        let fadeOutAndIn = SKAction.sequence([
            SKAction.repeat(slowFade, count: 2),
            SKAction.repeat(lastFade, count: 5),
            SKAction.fadeAlpha(to: 1, duration: 0.15)
        ])
        
        let damageEnd = SKAction.run {
            self.physicsBody?.categoryBitMask = ColliderType.player
            self.damage = false
            self.invulnerable = false
        }
        
        self.damageAnimation = SKAction.sequence([
            damageStart,
            fadeOutAndIn,
            //damageEnd
        ])
        
        //self.size = CGSize(width: 140, height: 180)
//        let rotateUpAction = SKAction.rotate(toAngle: 0, duration: 0.475)
//        rotateUpAction.timingMode = .easeOut
//        let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 0.2)
//        rotateDownAction.timingMode = .easeIn
        
        let catFlyFrames: [SKTexture] = [
            textureAtlas.textureNamed("PlayerFly"),
            textureAtlas.textureNamed("PlayerFly2"),
            textureAtlas.textureNamed("PlayerFly3")
        ]
        
        let catFlyAction = SKAction.animate(with: catFlyFrames, timePerFrame: 0.2)
        catFlyAnimation = SKAction.repeatForever(catFlyAction)
        
        let soarFrames:[SKTexture] =
        [textureAtlas.textureNamed("PlayerFly4")]
        let soarAction = SKAction.animate(with: soarFrames, timePerFrame: 1)
        // Group the soaring animation with the rotation down:
        soarAnimation = SKAction.group([
            SKAction.repeatForever(soarAction),
            rotateUpAction
        ])
        
        let catRocketFrames: [SKTexture] = [
            textureAtlas.textureNamed("Spacecatjetombra1"),
            textureAtlas.textureNamed("Spacecatjetombra2"),
            textureAtlas.textureNamed("Spacecatjetombra3"),
            //textureAtlas.textureNamed("Spacecatjet4")
        ]
        
       // let catRocketFrames: [SKTexture] = [textureAtlas.textureNamed("Spacecatjet4")]
        let catRocketAction = SKAction.animate(with: catRocketFrames, timePerFrame: 0.2)
        
        catRocketAnimation = SKAction.repeatForever(catRocketAction)
        
        
        let catDeadFrames: [SKTexture] = [
            textureAtlas.textureNamed("deadcat2"),
//            textureAtlas.textureNamed("")
        ]
        
        catDeadAnimation = SKAction.animate(with: catDeadFrames, timePerFrame: 1)
        
        
    }
    
    
    func startFlying() {
        
        self.removeAction(forKey: "soarAnimation")
        self.run(catFlyAnimation, withKey: "upAnimation")
        self.size = CGSize(width: 82, height: 130)
    }
    
    func stopFlying() {
        
        self.removeAction(forKey: "upAnimation")
        self.run(soarAnimation, withKey: "soarAnimation")
        self.size = CGSize(width: 82, height: 130)
    }
    
    
    
    func textureJumping() {
        let rotateUpAction = SKAction.rotate(toAngle: 0, duration: 0.475)
        rotateUpAction.timingMode = .easeOut
        let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 0.2)
        rotateDownAction.timingMode = .easeIn
        
        let frame: [SKTexture] = [textureAtlas.textureNamed("Spacecat2")]
        let actionFrame = SKAction.animate(with: frame, timePerFrame: 0.6)
        let frame2: [SKTexture] = [textureAtlas.textureNamed("Spacecat4")]
        let actionFrame2 = SKAction.animate(with: frame2, timePerFrame: 0.35)
        //let frame3: [SKTexture] = [textureAtlas.textureNamed("Spacecat7")]
        //let actionFrame3 = SKAction.animate(with: frame3, timePerFrame: 0.25)
        let sequence = SKAction.sequence([actionFrame, actionFrame2])
        self.run(sequence)
        
    }
    
    func die() {
        self.alpha = 1
        //self.removeAllActions()
//        self.run(self.dieAnimation)
        self.jump = false
        self.isFlying = false
        self.isDead = true
    }
    
    func takeDamage() {
        if invulnerable { return }
        invulnerable = true
        health -= 1
        if health == 0 {
            die()
        } else {
//
            self.run(damageAnimation) {
                //self.physicsBody?.categoryBitMask = ColliderType.player
                self.damage = false
                self.invulnerable = false
                //print("")
            }
            print("Run damange animation")
        }
    }
    
    func addLife() {
        if health < 3 {
            health += 1
        }
    }
    
    
    func onTap() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//
//  Ground.swift
//  Pierre The Penguin
//
//  Created by Marta Michelle Caliendo on 10/11/17.
//


import SpriteKit

class Ground: SKSpriteNode, GameSprite {

    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var initialSize = CGSize.zero
    
    var jumpWidth = CGFloat()
    var jumpCount = CGFloat(1)


    func createChildren() {
        self.anchorPoint = CGPoint(x: 0, y: 1)
        let texture = textureAtlas.textureNamed("terreno3")
        
        var tileCount:CGFloat = 0
 
        let tileSize = CGSize(width: 1180, height: 50)
        
        while tileCount * tileSize.width < self.size.width {
            let tileNode = SKSpriteNode(texture: texture)
            tileNode.size = tileSize
            tileNode.position.x = tileCount * tileSize.width
            tileNode.anchorPoint = CGPoint(x: 0, y: 1)
            self.addChild(tileNode)
            
            tileCount += 1
        }

        let pointTopLeft = CGPoint(x: 0, y: 0)
        let pointTopRight = CGPoint(x: size.width, y: 0)
        self.name = "Ground"
        self.physicsBody = SKPhysicsBody(edgeFrom: pointTopLeft, to: pointTopRight)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.ground
        self.physicsBody?.restitution = 0.0

        jumpWidth = tileSize.width * floor(tileCount / 3)


    }
    
    func checkForReposition(playerProgress:CGFloat) {
        let groundJumpPosition = jumpWidth * jumpCount
        
        if playerProgress >= groundJumpPosition {
            self.position.x += jumpWidth
            jumpCount += 1
        }
    }

    func onTap() {}
}


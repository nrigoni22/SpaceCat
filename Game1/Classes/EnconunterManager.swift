//
//  EnconunterManager.swift
//  Game1
//
//  Created by Nicola Rigoni on 10/12/22.
//

import SpriteKit
class EncounterManager {
    // Store your encounter file names:
    let encounterNames:[String] = [
        "Encounter1",
        "Encounter2",
        "Encounter3",
        "Encounter4",
        "Encounter5",
        "Encounter6",
        "Encounter7",
        "Encounter8",
        "Encounter9",
        "Encounter10",
        "Encounter11",
        "Encounter12",
        "Encounter13",
        "Encounter14",
        "Encounter15",
        "Encounter16",
        "Encounter17",
        "Encounter18",
        "Encounter19",
        "Encounter20",
    ]
    // Each encounter is an SKNode, store an array:
    var encounters: [SKNode] = []
    
    var currentEncounterIndex: Int = 0
    var previousEncounterIndex: Int?
    
    init() {
        // Loop through each encounter scene:
        
        
        for encounterFileName in encounterNames {
            // Create a new node for the encounter:
            let encounterNode = SKNode()
            // Load this scene file into a SKScene instance:
            if let encounterScene = SKScene(fileNamed:
                                                encounterFileName) {
                // Loop through each child node in the SKScene
                for child in encounterScene.children {
                    // Create a copy of the scene's child node
                    // to add to our encounter node:
                    let copyOfNode = type(of: child).init()
                    // Save the scene node's position to the copy:
                    copyOfNode.position = child.position
                    // Save the scene node's name to the copy:
                    copyOfNode.name = child.name
                    // Add the copy to our encounter node:
                    encounterNode.addChild(copyOfNode)
                } }
            // Add the populated encounter node to the array:
            encounters.append(encounterNode)
            // Add the populated encounter node to the array:
            saveSpritePositions(node: encounterNode)
        }
        
        
    }
    
    func placeNextEncounter(currentXPos: CGFloat) {
        // Count the encounters in a random ready type (Uint32):
        //let encounterCount = UInt32(encounters.count)
        // The game requires at least 3 encounters to function
//        // so exit this function if there are less than 3
//        if encounterCount < 1 { return }
//
//        print("aaaaaaaa")
//        // We need to pick an encounter that is not
//        // currently displayed on the screen.
//        var nextEncounterIndex: Int?
//        var trulyNew: Bool?
//        // The current encounter and the directly previous encounter
//        // can potentially be on the screen at this time.
//        // Pick until we get a new encounter
//        while trulyNew == false || trulyNew == nil {
//            // Pick a random encounter to set next:
//            nextEncounterIndex = Int(arc4random_uniform(encounterCount))
//            // First, assert that this is a new encounter:
//            trulyNew = true
//            // Test if it is instead the current encounter:
//            if let currentIndex = currentEncounterIndex {
//                if (nextEncounterIndex == currentIndex) {
//                    trulyNew = false
//                }
//
//            }
//            // Test if it is the directly previous encounter:
//            if let previousIndex = previousEncounterIndex {
//                if (nextEncounterIndex == previousIndex) {
//                    trulyNew = false
//                }
//            }
//        }
//        // Keep track of the current encounter:
//        previousEncounterIndex = currentEncounterIndex
//        currentEncounterIndex = nextEncounterIndex
//        // Reset the new encounter and position it ahead of the player
        
        if currentEncounterIndex < encounters.count - 1 {
            currentEncounterIndex += 1
        } else {
            currentEncounterIndex = 0
        }
        
        print("index encounter \(currentEncounterIndex)")
        
        let encounter = encounters[currentEncounterIndex]
        encounter.position = CGPoint(x: currentXPos + 2000, y: 300)
//        for child in encounter.children {
//            if child.name == "Enemy" {
//                let newchild = child as! SKSpriteNode
//                newchild.physicsBody = SKPhysicsBody(circleOfRadius: newchild.size.width/2)
//                newchild.physicsBody?.affectedByGravity = false
//                newchild.physicsBody?.isDynamic = false
//                newchild.physicsBody?.categoryBitMask = ColliderType.enemy
////                newchild.position.y = 150
//            }
//
//        }
        resetSpritePositions(node: encounter)
    }
    
    // Store the initial positions of the children of a node:
    func saveSpritePositions(node: SKNode) {
        for sprite in node.children {
            if let spriteNode = sprite as? SKSpriteNode {
                let initialPositionValue = NSValue.init(cgPoint:
                                                            sprite.position)
                spriteNode.userData = ["initialPosition":
                                        initialPositionValue]
                // Save the positions for children of this node:
                saveSpritePositions(node: spriteNode)
            }
        }
    }
    
    // Reset all children nodes to their original position:
    func resetSpritePositions(node: SKNode) {
        for sprite in node.children {
            if let spriteNode = sprite as? SKSpriteNode {
                // Remove any linear or angular velocity:
                spriteNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                spriteNode.physicsBody?.angularVelocity = 0
                // Reset the rotation of the sprite:
                spriteNode.zRotation = 0
                
 
                
                if spriteNode.name == "Enemy" {
//                    let newchild = child as! SKSpriteNode
                    spriteNode.physicsBody = SKPhysicsBody(circleOfRadius: spriteNode.size.width/2)
                    spriteNode.physicsBody?.affectedByGravity = false
                    spriteNode.physicsBody?.isDynamic = false
                    spriteNode.physicsBody?.categoryBitMask = ColliderType.enemy
                    spriteNode.position.y = 150
                }
                
                if spriteNode.name == "PowerUp" {
                    spriteNode.alpha = 1
                }
                     
                if let initialPositionVal =
                    spriteNode.userData?.value(forKey:
                                                "initialPosition") as? NSValue {
                    // Reset the position of the sprite:
                    spriteNode.position =
                    initialPositionVal.cgPointValue
                }
                // Reset positions on this node's children
                resetSpritePositions(node: spriteNode)
            }
        }
    }
    
    // We will call this addEncountersToScene function from
    // the GameScene to append all of the encounter nodes to the
    // world node from our GameScene:
    func addEncountersToScene(gameScene:SKNode) {
    var encounterPosY = 1000
        
        for encounterNode in encounters {
            // Spawn the encounters behind the action, with
            // increasing height so they do not collide:
           
            encounterNode.position = CGPoint(x: -2000,
                                             y: encounterPosY)
            gameScene.addChild(encounterNode)
            // Double the Y pos for the next encounter:
            encounterPosY *= 2
        } }
}

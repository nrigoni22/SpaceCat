//
//  GameSprite.swift
//  Game1
//
//  Created by Nicola Rigoni on 07/12/22.
//

import Foundation
import SpriteKit

protocol GameSprite {
    var textureAtlas: SKTextureAtlas {get set}
    var initialSize: CGSize {get set}
    func onTap()
}

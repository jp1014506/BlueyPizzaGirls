//
//  Untitled.swift
//  Lab5
//
//  Created by James Park on 4/18/25.
//

import Foundation
import SpriteKit

enum CollectibleType: String {
    case none
    case pizza
    case mudPile
}

class Collectible: SKSpriteNode {
    private var collectibleType: CollectibleType = .none

    init(collectibleType: CollectibleType) {
        var texture: SKTexture!
        self.collectibleType = collectibleType

        //set the texture based on the Type
        switch self.collectibleType {
        case .pizza:
            texture = SKTexture(imageNamed: "fruit-Picsart-BackgroundRemover")
        case .mudPile:
            texture = SKTexture(imageNamed: "mudPile")
        case .none:
            break
        }
        
        super.init(texture: texture, color: SKColor.clear, size: texture.size())

        //set up the collectible
        self.name = "co_\(collectibleType)"
        self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        self.setScale(0.3)
        self.zPosition = Layer.collectible.rawValue
        
        // add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size, center: CGPoint(x:0.0, y: self.size.height/2))
        self.physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask      = (collectibleType == .mudPile)
                                                        ? PhysicsCategory.mudPile
                                                        : PhysicsCategory.collectible
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.foreground
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
    }

    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func drop(dropSpeed: TimeInterval, floorLevel: CGFloat) {
        let pos = CGPoint(x: position.x, y: floorLevel)
        let scaleX = SKAction.scaleX(to: 0.5, duration: 1)
        let scaleY = SKAction.scaleY(to: 0.5, duration: 1)
        let scale = SKAction.group([scaleX, scaleY])

        let appear = SKAction.fadeAlpha(to: 1, duration: 0.25)
        let moveAction = SKAction.move(to: pos, duration: dropSpeed)
        let actionSequence = SKAction.sequence([appear, scale, moveAction])

        self.scale(to: CGSize(width: 0.25, height: 1.0))
        self.run(actionSequence, withKey: "drop")
    }
    
    func collected() {
        self.run(SKAction.removeFromParent())
    }

    func missed() {
        self.run(SKAction.removeFromParent())
    }
}

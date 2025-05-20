//
//  Untitled.swift
//  Lab5
//
//  Created by James Park on 4/18/25.
//
import Foundation
import SpriteKit

class Player:SKSpriteNode {
    // MARK: - PROPERTIES

    // MARK: - INT
    init() {
        // set default textture
        let texture = SKTexture(imageNamed: "Screenshot 2025-04-18 at 3,59,38 PM-Picsart-BackgroundRemover_resized-Picsart-ImageFlipper")

        // call to super.init
        super.init(texture: texture, color: .clear, size: texture.size())

        self.name = "player"
        self.setScale(1.0)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        self.zPosition = Layer.player.rawValue
        
        // add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size, center: CGPoint(x:0.0, y: self.size.height/2))
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.player // set category
        self.physicsBody?.contactTestBitMask = PhysicsCategory.collectible //test collision with collectible
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveToPosition(pos: CGPoint, direction: String, speed: TimeInterval) {
        switch direction {
            case "L":
                xScale = -abs(xScale)
            default:
                xScale = abs(xScale)
        }
        let moveAction = SKAction.move(to: pos, duration: speed)
        run(moveAction)
    }
    
    func setupConstraints(floor: CGFloat) {
        let range = SKRange(lowerLimit: floor, upperLimit: floor)
        let lockToPlatform = SKConstraint.positionY(range)
        constraints = [lockToPlatform]
    }
}

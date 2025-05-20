//
//  GameScene.swift
//  Lab5
//
//  Created by James Park on 4/18/25.
//

import AVFoundation
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // MARK: - Game State
    private var missedCount = 0
    private let maxAllowedMisses = 5

    // MARK: - Score UI
    private var scoreLevel = SKLabelNode()
    private var score: Int = 0 {
        didSet {
            scoreLevel.text = "Score: \(score)"
        }
    }

    // MARK: - End‑of‑Game UI
    private var gameOverLabel: SKLabelNode?
    private var finalScoreLabel: SKLabelNode?
    private var restartButton: SKLabelNode?

    // MARK: - Player
    private let player = Player()

    // MARK: - Touch Handling
    private func touchDown(atPoint pos: CGPoint) {
        let direction = (pos.x < player.position.x) ? "L" : "R"
        player.moveToPosition(pos: pos, direction: direction, speed: 1.0)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let nodesAtPoint = nodes(at: location)
            if nodesAtPoint.contains(where: { $0.name == "restartButton" }) {
                restartGame()
            } else {
                touchDown(atPoint: location)
            }
        }
    }

    // MARK: - Scene Setup
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self

        // Background
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = .zero
        background.position    = CGPoint(x: -self.size.width/3, y: 0)
        background.zPosition   = Layer.background.rawValue
        addChild(background)

        // Foreground (with physics body)
        let foreground = SKSpriteNode(imageNamed: "foreground")
        foreground.anchorPoint = .zero
        foreground.position    = CGPoint(x: 0, y: 0)
        foreground.zPosition   = Layer.foreground.rawValue
        foreground.physicsBody = SKPhysicsBody(edgeLoopFrom: foreground.frame)
        foreground.physicsBody?.affectedByGravity     = false
        foreground.physicsBody?.categoryBitMask       = PhysicsCategory.foreground
        foreground.physicsBody?.contactTestBitMask    = PhysicsCategory.collectible
        foreground.physicsBody?.collisionBitMask      = PhysicsCategory.none
        addChild(foreground)

        // Player (locked to foreground Y)
        let floorY = foreground.frame.maxY
        player.position = CGPoint(x: size.width/2, y: floorY)
        player.setupConstraints(floor: floorY)
        player.zPosition = Layer.player.rawValue
        addChild(player)
        
        // Add this to start your theme music on loop:
        do {
          try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
          try AVAudioSession.sharedInstance().setActive(true)
        } catch { print(error) }
        let music = SKAudioNode(fileNamed:  "Bluey Extended Theme Song   Bluey.mp3")
        music.autoplayLooped = true
        addChild(music)

        // Score label
        setupLabels()

        // Start dropping pizzas
        spawnMultiplePizzas()
    }

    // MARK: - Spawning
    func spawnPizza() {
        let collectible = Collectible(collectibleType: .pizza)
        let margin      = collectible.size.width * 2
        let dropRange   = SKRange(
            lowerLimit: frame.minX + margin,
            upperLimit: frame.maxX - margin
        )
        let randomX     = CGFloat.random(in: dropRange.lowerLimit...dropRange.upperLimit)
        let spawnY      = size.height * 0.9

        collectible.position = CGPoint(x: randomX, y: spawnY)
        addChild(collectible)
        collectible.drop(
            dropSpeed: 1.0,
            floorLevel: player.frame.minY
        )
    }

    func spawnMultiplePizzas() {
        let wait           = SKAction.wait(forDuration: 1.0)
        let spawn          = SKAction.run { self.spawnPizza() }
        let sequence       = SKAction.sequence([wait, spawn])
        let repeatAction   = SKAction.repeat(sequence, count: 25)
        let gameOverAction = SKAction.run { self.gameOver() }
        let fullSequence   = SKAction.sequence([repeatAction, gameOverAction])

        run(fullSequence, withKey: "pizza")
    }

    // MARK: - Labels
    func setupLabels() {
        scoreLevel.name                     = "score"
        scoreLevel.fontName                 = "AvenirNext-Bold"
        scoreLevel.text                     = "Score: 0"
        scoreLevel.fontSize                 = 36
        scoreLevel.fontColor                = .black
        scoreLevel.horizontalAlignmentMode  = .right
        scoreLevel.verticalAlignmentMode    = .top
        scoreLevel.position                 = CGPoint(x: frame.maxX - 20, y: frame.maxY - 20)
        scoreLevel.zPosition                = Layer.ui.rawValue
        addChild(scoreLevel)
    }

    // MARK: - Game Over / Restart
    func gameOver() {
        // Stop spawning
        removeAction(forKey: "pizza")

        // Freeze all pizzas
        enumerateChildNodes(withName: "//co_*") { node, _ in
            node.removeAction(forKey: "drop")
            node.physicsBody = nil
        }

        // 1️⃣ Game Over Title
        gameOverLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        gameOverLabel!.text      = "Great Job, Pizza Girls!!"
        gameOverLabel!.fontSize  = 100
        gameOverLabel!.fontColor = .darkGray
        gameOverLabel!.position  = CGPoint(x: frame.midX, y: frame.midY + 40)
        gameOverLabel!.zPosition = Layer.ui.rawValue
        addChild(gameOverLabel!)

        // 2️⃣ Final Score
        finalScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        finalScoreLabel!.text      = "Score: \(score)"
        finalScoreLabel!.fontSize  = 36
        finalScoreLabel!.fontColor = .darkGray
        finalScoreLabel!.position  = CGPoint(x: frame.midX, y: frame.midY - 10)
        finalScoreLabel!.zPosition = Layer.ui.rawValue
        addChild(finalScoreLabel!)

        // 3️⃣ Restart Button
        restartButton = SKLabelNode(fontNamed: "AvenirNext-Bold")
        restartButton!.text      = "Tap to Restart"
        restartButton!.name      = "restartButton"
        restartButton!.fontSize  = 50
        restartButton!.fontColor = .blue
        restartButton!.position  = CGPoint(x: frame.midX, y: frame.midY - 60)
        restartButton!.zPosition = Layer.ui.rawValue
        addChild(restartButton!)
    }

    func restartGame() {
        // Remove end-of-game UI
        gameOverLabel?.removeFromParent()
        finalScoreLabel?.removeFromParent()
        restartButton?.removeFromParent()

        // Reset state
        score       = 0
        missedCount = 0

        // Clear any remaining pizzas
        enumerateChildNodes(withName: "//co_*") { node, _ in
            node.removeFromParent()
        }

        // Kick off a new round
        spawnMultiplePizzas()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        if collision == PhysicsCategory.player | PhysicsCategory.collectible {
            let body = (contact.bodyA.categoryBitMask == PhysicsCategory.collectible)
                     ? contact.bodyA.node
                     : contact.bodyB.node
            if let sprite = body as? Collectible {
                sprite.collected()
                score += 10
            }

        } else if collision == PhysicsCategory.foreground | PhysicsCategory.collectible {
            let body = (contact.bodyA.categoryBitMask == PhysicsCategory.collectible)
                     ? contact.bodyA.node
                     : contact.bodyB.node
            if let sprite = body as? Collectible {
                sprite.missed()
                missedCount += 1
                if missedCount >= maxAllowedMisses {
                    gameOver()
                }
            }
        }
    }
}

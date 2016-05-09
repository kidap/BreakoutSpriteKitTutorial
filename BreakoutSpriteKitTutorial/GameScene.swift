//
//  GameScene.swift
//  BreakoutSpriteKitTutorial
//
//  Created by Karlo Pagtakhan on 05/05/2016.
//  Copyright (c) 2016 AccessIT. All rights reserved.
//

import SpriteKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"
let BlockNodeCategoryName = "blockNode"

let BallCategory   : UInt32 = 0x1 << 0 // 00000000000000000000000000000001
let BottomCategory : UInt32 = 0x1 << 1 // 00000000000000000000000000000010
let BlockCategory  : UInt32 = 0x1 << 2 // 00000000000000000000000000000100
let PaddleCategory : UInt32 = 0x1 << 3 // 00000000000000000000000000001000

class GameScene: SKScene, SKPhysicsContactDelegate {
  var isFingerOnPaddle:Bool = false
  
  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
    
    physicsWorld.contactDelegate = self
    
    let borderBody = SKPhysicsBody(edgeLoopFromRect: frame)
    borderBody.friction = 0
    physicsBody = borderBody
    physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    
    let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: size.width, height: 1)
    let bottom = SKNode()
    
    bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
    addChild(bottom)
    
    let bg = SKSpriteNode(imageNamed: "bg")
    bg.position = CGPoint(x: 568.0, y: 320.0)
    bg.size = CGSize(width: 1136, height: 640)
    bg.zPosition = 0
    addChild(bg)
    
    //let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
    let ball = SKSpriteNode(imageNamed: BallCategoryName)
    ball.name = "ball"
    ball.position = CGPoint(x: 709.468, y: size.height - 200)
    ball.size = CGSize(width: 30, height: 30)
    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
    ball.physicsBody?.dynamic = true
    ball.physicsBody?.allowsRotation = false
    ball.physicsBody?.affectedByGravity = true
    ball.physicsBody?.friction = 0
    ball.physicsBody?.restitution = 1
    ball.physicsBody?.linearDamping = 0
    ball.physicsBody?.angularDamping = 0
    ball.physicsBody?.collisionBitMask = PaddleCategory
    ball.zPosition = 1
    addChild(ball)

    ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: -10))
    
    
//    let paddle = childNodeWithName(PaddleCategoryName)  as! SKSpriteNode
    let paddle = SKSpriteNode(imageNamed: PaddleCategoryName)
    paddle.name = "paddle"
    paddle.position = CGPoint(x: 709.468, y: 71.86)
    paddle.size = CGSize(width: 120, height: 45)
    paddle.physicsBody = SKPhysicsBody(rectangleOfSize: paddle.size)
    paddle.physicsBody?.dynamic = false
    paddle.physicsBody?.allowsRotation = false
    paddle.physicsBody?.affectedByGravity = false
    paddle.physicsBody?.friction = 0.5
    paddle.physicsBody?.restitution = 0.2
    paddle.physicsBody?.linearDamping = 0.1
    paddle.physicsBody?.angularDamping = 0.1
    paddle.zPosition = 1
    paddle.physicsBody?.applyImpulse(CGVector(dx: 10, dy: -10))
    addChild(paddle)
    
    
    
    
    bottom.physicsBody?.categoryBitMask = BottomCategory
    ball.physicsBody?.categoryBitMask = BallCategory
    ball.physicsBody?.contactTestBitMask = BottomCategory
    paddle.physicsBody?.categoryBitMask = PaddleCategory
    
    // 1. Store some useful constants
    let numberOfBlocks = 5
    
    let blockWidth = SKSpriteNode(imageNamed: "block.png").size.width
    let totalBlocksWidth = blockWidth * CGFloat(numberOfBlocks)
    
    let padding: CGFloat = 10.0
    let totalPadding = padding * CGFloat(numberOfBlocks - 1)
    
    // 2. Calculate the xOffset
    let xOffset = (CGRectGetWidth(frame) - totalBlocksWidth - totalPadding) / 2
    
    // 3. Create the blocks and add them to the scene
    for i in 0..<numberOfBlocks {
      let block = SKSpriteNode(imageNamed: "block.png")
      block.name = BlockCategoryName
      block.position = CGPointMake(xOffset + CGFloat(CGFloat(i) + 0.5)*blockWidth + CGFloat(i-1)*padding, CGRectGetHeight(frame) * 0.8)
      block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
      block.physicsBody!.allowsRotation = false
      block.physicsBody!.friction = 0.0
      block.physicsBody!.affectedByGravity = false
      block.physicsBody!.categoryBitMask = BlockCategory
      block.physicsBody?.contactTestBitMask = BallCategory
      block.physicsBody?.dynamic = false
      block.zPosition = 1
      addChild(block)
    }
    
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    for touch in touches{
      var touchPoint = touch.locationInNode(self)
      
      if let body = physicsWorld.bodyAtPoint(touchPoint){
        if body.node!.name == PaddleCategoryName{
          isFingerOnPaddle = true
        }
      }
      
    }
    
  }
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if isFingerOnPaddle == true{
      for touch in touches{
        var touchPoint = touch.locationInNode(self)
        var paddle = childNodeWithName(PaddleCategoryName) as! SKSpriteNode
        
        paddle.position.x = max(min(touchPoint.x,size.width - paddle.size.width / 2 ), paddle.size.width / 2)
  
      }
    }
  }
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    isFingerOnPaddle = false
  }
  func didBeginContact(contact: SKPhysicsContact) {
    var firstBody: SKPhysicsBody
    var secondBody: SKPhysicsBody
    
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      firstBody = contact.bodyA
      secondBody = contact.bodyB
    } else {
      firstBody = contact.bodyB
      secondBody = contact.bodyA
    }
    
    if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
      print("Hit bottom. First contact has been made.")
      
      if let view = view{
        let gameOverScene = GameOverScene(fileNamed: "GameOverScene")
        gameOverScene!.scaleMode = .AspectFill
        view.presentScene(gameOverScene)
      }
    }
    
    
    if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BlockCategory {
      print("Hit block")
      secondBody.node?.removeFromParent()
    }
  }
}
//
//  GameOverScene.swift
//  BreakoutSpriteKitTutorial
//
//  Created by Karlo Pagtakhan on 05/09/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import SpriteKit

let GameOverLabelCategoryName = "gameOverLabel"

class GameOverScene: SKScene {
  var gameWon : Bool = false {
    // 1.
    didSet {
      let gameOverLabel = childNodeWithName(GameOverLabelCategoryName) as! SKLabelNode
      gameOverLabel.text = gameWon ? "Game Won" : "Game Over"
    }
  }
  
  
  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
    
    let bg = SKSpriteNode(imageNamed: "bg")
    bg.position = CGPoint(x: 568.0, y: 320.0)
    bg.size = CGSize(width: 1136, height: 640)
    bg.zPosition = 0
    addChild(bg)
    
    let label = SKLabelNode(text: "Game Over")
    label.position = CGPoint(x: 568.0, y: 320.0)
    label.horizontalAlignmentMode = .Center
    label.verticalAlignmentMode = .Center
    label.zPosition = 1
    addChild(label)
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let view = view {
      // 2.
      let gameScene = GameScene(fileNamed: "GameScene")
      gameScene!.scaleMode = .AspectFill
      view.presentScene(gameScene)
    }
  }
}
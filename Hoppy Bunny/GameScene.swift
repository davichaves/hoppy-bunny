//
//  GameScene.swift
//  Hoppy Bunny
//
//  Created by Davi Rodrigues Chaves on 6/10/16.
//  Copyright (c) 2016 davichaves. All rights reserved.
//

import SpriteKit
import CoreGraphics

class GameScene: SKScene {
    
    var hero: SKSpriteNode!
    var sinceTouch : CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS */
    let scrollSpeed: CGFloat = 160
    var scrollLayer: SKNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        /* Recursive node search for 'hero' (child of referenced node) */
        hero = self.childNodeWithName("//hero") as! SKSpriteNode
        
        /* Set reference to scroll layer node */
        scrollLayer = self.childNodeWithName("scrollLayer")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        /* Apply vertical impulse */
        hero.physicsBody?.applyImpulse(CGVectorMake(0, 250))
        
        /* Apply subtle rotation */
        hero.physicsBody?.applyAngularImpulse(1)
        
        /* Reset touch timer */
        sinceTouch = 0
        
        /* Play SFX */
        let flapSFX = SKAction.playSoundFileNamed("SFX/sfx_flap", waitForCompletion: false)
        self.runAction(flapSFX)
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        /* Grab current velocity */
        let velocityY = hero.physicsBody?.velocity.dy ?? 0
        
        /* Check and cap vertical velocity */
        if velocityY > 400 {
            hero.physicsBody?.velocity.dy = 400
        }
        
        /* Apply falling rotation */
        if sinceTouch > 0.1 {
            let impulse = -20000 * fixedDelta
            hero.physicsBody?.applyAngularImpulse(CGFloat(impulse))
        }
        
        /* Clamp rotation */
        hero.zRotation.clamp(CGFloat(-20).degreesToRadians(),CGFloat(30).degreesToRadians())
        hero.physicsBody?.angularVelocity.clamp(-2, 2)
        
        /* Update last touch timer */
        sinceTouch+=fixedDelta
        
        /* Process world scrolling */
        scrollWorld()
    }
    
    func scrollWorld() {
        /* Scroll World */
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
    }
}

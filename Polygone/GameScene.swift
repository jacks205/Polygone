//
//  GameScene.swift
//  Polygone
//
//  Created by Mark Jackson on 3/23/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    var contentCreated : Bool = false
    var ship : Ship?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        if(!self.contentCreated){
            self.createSceneContents()
            self.contentCreated = true
        }
    }
    
    func createSceneContents(){
        self.backgroundColor = SKColor.whiteColor()
        createShip()
        
    }
    
    func createShip(){
        let width : Double = 35
        let height : Double = 35
        let percentShipY : CGFloat = 0.1
        self.ship = Ship(width: width, height: height, lineWidth: 5)
        self.ship!.setPosition(CGPointMake(CGRectGetMidX(self.frame) - CGFloat(width/2), self.frame.height * percentShipY))
        self.addChild(self.ship!.body!)
        let bullet : Bullet = Bullet(length: 15, thickness: 3)
        bullet.body?.position = self.ship!.nose!
        self.addChild(bullet.body!)
    }
    
    
    

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

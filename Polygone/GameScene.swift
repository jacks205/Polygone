//
//  GameScene.swift
//  Polygone
//
//  Created by Mark Jackson on 3/23/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import SpriteKit
import CoreMotion


class GameScene: SKScene, SKPhysicsContactDelegate {
    let sceneCategory : UInt32 = 0x01 << 3
    
    var contentCreated : Bool = false
    var ship : Ship?
    
    var motionManager : CMMotionManager?
    
    override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        if(!self.contentCreated){
            self.createSceneContents()
            self.contentCreated = true
        }
    }
    
    func createSceneContents(){
        self.backgroundColor = SKColor.whiteColor()
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = self.sceneCategory
        self.physicsBody?.contactTestBitMask = Bullet.bulletCategory
        self.createShip()
        self.startAccelerometer()
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        println(contact)
    }
    
    func startAccelerometer(){
        self.motionManager = CMMotionManager()
        self.motionManager?.accelerometerUpdateInterval = 0.01;
        if(self.motionManager!.accelerometerAvailable){
            let queue : NSOperationQueue = NSOperationQueue()
            self.motionManager?.startAccelerometerUpdatesToQueue(queue, withHandler: { ( data :CMAccelerometerData!, error : NSError!) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.moveShip(data.acceleration.x, boundRight: self.frame.width)
                })
            })
        }
    }
    
    func moveShip(xMovement : Double, boundRight : CGFloat){
//        println(xMovement)
        self.ship!.moveShip(xMovement, boundRight: boundRight)
    }
    
    func createShip(){
        let width : Double = 35
        let height : Double = 35
        let percentShipY : CGFloat = 0.1
        self.ship = Ship(width: width, height: height, lineWidth: 5)
        self.ship!.setPosition(CGPointMake(CGRectGetMidX(self.frame) - CGFloat(width/2), self.frame.height * percentShipY))
        self.addChild(self.ship!.body!)
    }
    
    
    func fireBullet(){
        let bullet : Bullet = Bullet(length: 15, thickness: 3, position: self.ship!.nose!)
        self.addChild(bullet.body!)
        let destination = CGPointMake(self.ship!.body!.position.x, self.ship!.body!.position.y + 1000)
        let action : SKAction = SKAction.moveTo(destination, duration: Bullet.speed)
        bullet.body?.runAction(action)
//        bullet.body?.removeFromParent()
    }

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        self.fireBullet()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
//        println(currentTime)
    }
    
}

//
//  GameScene.swift
//  Polygone
//
//  Created by Mark Jackson on 3/23/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import SpriteKit
import CoreMotion

struct GameSceneConst{
    static let sceneCategory : UInt32 = 0x01 << 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var contentCreated : Bool = false
    var ship : Ship?
    
    var motionManager : CMMotionManager?
    
    var isFiring : Bool = false
    var fireRate : Int = 20
    var fireRateCooldown : Int!
    
    override init(size: CGSize) {
        self.fireRateCooldown = self.fireRate
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        if(!self.contentCreated){
            self.createSceneContents(view)
            self.contentCreated = true
        }
    }
    
    func createSceneContents(view : SKView){
        self.anchorPoint = CGPointMake(0.5, 0.5)
        println(self.frame)
        println(self.scene?.frame)
        println(self.anchorPoint)
        self.backgroundColor = SKColor.whiteColor()
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        var newFrame : CGRect = CGRect(x: -100, y: -100, width: self.frame.width + 200, height: self.frame.height + 200)
//        var test = SKSpriteNode(color: UIColor.blackColor(), size: newFrame.size)
//        test.position = CGPointMake(0, 0)
//        self.addChild(test)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: newFrame)
//        self.physicsBody?.allowsRotation = false
//        self.physicsBody!.dynamic = true
//        self.physicsBody!.affectedByGravity = false
//        self.physicsBody!.pinned = true
//        self.physicsBody!.mass = 100000
        self.physicsBody!.categoryBitMask = GameSceneConst.sceneCategory
//        self.physicsBody!.contactTestBitMask = Bullet.bulletCategory
        
//        var topBarrier : SKNode = SKShapeNode(rect: CGRectMake(self.frame.origin.x - 50, self.frame.height + 100, self.frame.width + 100, 1))
//        println(self.frame)
//        println(topBarrier.frame)
//        topBarrier.physicsBody = SKPhysicsBody(rectangleOfSize: topBarrier.frame.size)
//        topBarrier.physicsBody!.affectedByGravity = false
//        topBarrier.physicsBody!.dynamic = false
//        topBarrier.physicsBody!.allowsRotation = false
//        topBarrier.physicsBody!.categoryBitMask = GameSceneConst.sceneCategory
//        topBarrier.physicsBody!.contactTestBitMask = Bullet.bulletCategory
//        self.addChild(topBarrier)
        self.createShip()
        self.startAccelerometer()
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody, secondBody: SKPhysicsBody
        println("\(contact.bodyA.categoryBitMask), \(contact.bodyB.categoryBitMask)")
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else { //bodyA is world frame, bodyB is bullet
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & Bullet.bulletCategory) != 0 &&
            (secondBody.categoryBitMask & GameSceneConst.sceneCategory != 0)) {
                firstBody.node!.removeFromParent()
                println("Bullet Removed!")
        }
    }
    
    
    
    func startAccelerometer(){
        self.motionManager = CMMotionManager()
        self.motionManager?.accelerometerUpdateInterval = 0.01;
        if(self.motionManager!.accelerometerAvailable){
            let queue : NSOperationQueue = NSOperationQueue()
            self.motionManager?.startAccelerometerUpdatesToQueue(queue, withHandler: { ( data :CMAccelerometerData!, error : NSError!) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.moveShip(data.acceleration.x, boundLeft: self.frame.origin.x, boundRight: self.frame.width / 2)
                })
            })
        }
    }
    
    func moveShip(xMovement : Double, boundLeft : CGFloat, boundRight : CGFloat){
//        println(xMovement)
        self.ship!.moveShip(xMovement,  boundLeft : boundLeft, boundRight: boundRight)
    }
    
    func createShip(){
        let width : Double = 35
        let height : Double = 35
        let percentShipY : CGFloat = 0.15
        self.ship = Ship(width: width, height: height, lineWidth: 5)
        self.ship!.setPosition(CGPointMake(CGRectGetMidX(self.frame) - CGFloat(width/2), self.frame.origin.y + self.frame.height * percentShipY))
        self.addChild(self.ship!.body!)
    }
    
    
    func fireBullet(){
        let shipNose : CGPoint = self.ship!.getNose()
        let bullet : Bullet = Bullet(length: 15, thickness: 3, position: CGPointMake(shipNose.x, shipNose.y + 20))
//        let destination = CGPointMake(self.ship!.body!.position.x, self.frame.height)
//        let action : SKAction = SKAction.moveTo(destination, duration: Bullet.speed)
        self.addChild(bullet.body!)
        bullet.body!.physicsBody?.applyForce(CGVector(dx: 0, dy: 1000))
//        bullet.body!.runAction(action, completion: { () -> Void in
//            bullet.body!.removeFromParent()
//            println("Bullet Removed")
//        })
    }
    
    func beginFiring(){
        self.isFiring = true
    }
    
    func stopFiring(){
        self.isFiring = false
    }

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        self.fireBullet()
        self.beginFiring()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.stopFiring()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if self.isFiring {
            self.fireRateCooldown!--
            if self.fireRateCooldown <= 0 {
                self.fireBullet()
                self.fireRateCooldown = self.fireRate
            }
        }
        
    }
    
}

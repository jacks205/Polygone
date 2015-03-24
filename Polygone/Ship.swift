//
//  Ship.swift
//  Polygone
//
//  Created by Mark Jackson on 3/23/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import SpriteKit

class Ship {
    let shipCategory : UInt32 = 0x01 << 4
    
    var body : SKShapeNode?
    var nose : CGPoint?
    var width : CGFloat
    var height : CGFloat
    
    let movementSpeed : Double = 20
    
    init(width : Double, height : Double, lineWidth : CGFloat){
        self.width = CGFloat(width)
        self.height = CGFloat(height)
        self.body = self.createBody(width, height: height, lineWidth: lineWidth)
    }
    
    func createBody(width : Double, height : Double, lineWidth : CGFloat) -> SKShapeNode{
        var path : UIBezierPath = UIBezierPath()
        path.lineWidth = lineWidth
        //        UIColor.blackColor().setStroke()
        path.moveToPoint(CGPointMake(0, 0))
        path.addLineToPoint(CGPointMake(CGFloat(width), 0))
        path.addLineToPoint(CGPointMake(CGFloat(width/2), CGFloat(height)))
        path.closePath()
        var hull = SKShapeNode(path: path.CGPath)
        hull.antialiased = true
        hull.strokeColor = UIColor.blackColor()
        hull.physicsBody = SKPhysicsBody(polygonFromPath: path.CGPath)
        hull.physicsBody?.dynamic = false
        hull.physicsBody?.categoryBitMask = self.shipCategory
        hull.physicsBody?.contactTestBitMask = Box.boxCategory
        return hull
    }
    
    func setPosition(point : CGPoint){
        self.body?.position = point
        self.updateNose(point)
    }
    
    func updateNose(point : CGPoint){
        self.nose = CGPointMake(point.x + self.width/2, point.y + self.height)
    }
    
    func moveShip(xMovement : Double, boundRight : CGFloat){
        let offset = xMovement * self.movementSpeed
        let point : CGPoint = CGPointMake(self.body!.position.x + CGFloat(offset), self.body!.position.y)
        let x = point.x
//        print("\(x), \(0 + self.width/2) || \(x), \(boundRight - self.width/2)")
        if(x < 0 || x > boundRight - self.width){
            return;
        }
        self.body?.position = point
        self.updateNose(point)
    }
    
}

struct Bullet {
    static let bulletCategory : UInt32 = 0x01 << 0
    static let speed : NSTimeInterval = 1
    
    var body : SKShapeNode?
    
    init(length : CGFloat, thickness : CGFloat, position : CGPoint){
        self.body = self.createBullet(CGRectMake(position.x, position.y, thickness, length))
    }
    
    func createBullet(rect : CGRect) -> SKShapeNode{
        var bullet = SKShapeNode(rect: rect)
        bullet.antialiased = true
        bullet.strokeColor = UIColor.blackColor()
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: rect.size)
        bullet.physicsBody?.dynamic = false
        return bullet
    }
}

struct Box{
    static let boxCategory : UInt32 = 0x01 << 1
    
    var body : SKShapeNode?
    
    init(rect : CGRect, color : UIColor){
        self.body = SKShapeNode(rect: rect)
        self.body?.fillColor = color
    }
    
    func setPosition(point : CGPoint){
        self.body?.position = point
    }
}
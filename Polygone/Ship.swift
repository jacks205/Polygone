//
//  Ship.swift
//  Polygone
//
//  Created by Mark Jackson on 3/23/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import SpriteKit

class Ship {
    var body : SKShapeNode?
    var nose : CGPoint?
    var width : CGFloat
    var height : CGFloat
    
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
        return hull
    }
    
    func setPosition(point : CGPoint){
        self.body?.position = point
        self.nose = CGPointMake(point.x + self.width/2, point.y + self.height)
    }
    
}

class Bullet {
    var body : SKShapeNode?
    
    init(length : CGFloat, thickness : CGFloat){
        self.body = self.createBullet(length, thickness: thickness)
    }
    
    func createBullet(length : CGFloat, thickness : CGFloat) -> SKShapeNode{
        var path : UIBezierPath = UIBezierPath()
        path.lineWidth = thickness
        path.moveToPoint(CGPointMake(0, 0))
        path.addLineToPoint(CGPointMake(0, length))
        var bullet = SKShapeNode(path: path.CGPath)
        bullet.antialiased = true
        bullet.strokeColor = UIColor.blackColor()
        return bullet
    }
}
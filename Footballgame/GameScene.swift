//
//  GameScene.swift
//  Footballgame
//
//  Created by infuntis on 19/06/17.
//  Copyright © 2017 gala. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCatagory {
    static let Obstacle : UInt32 = 0x1 << 1
    static let Knee : UInt32 = 0x1 << 3
    static let Ball : UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
   
    var startLocation:CGPoint?
    var ball : SKSpriteNode
    var distance: CGFloat = 0.0
    var yVelocity:CGFloat = 0.0
     private var spinnyNode : SKShapeNode?
    
    private var sprites = [SKSpriteNode]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        ball = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 55,height:  55))
        let ballTexture = SKTexture(imageNamed: "ball")
        //let ballTexture = SKTexture(imageNamed: "\(theme)_face1")
        ball.texture = ballTexture
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let background = SKSpriteNode(imageNamed: "back")
        background.size = size
        addChild(background)
        self.physicsWorld.contactDelegate = self
        
        
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    func addBall(){
        let screenSize = UIScreen.main.bounds
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.restitution = 1
        ball.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.categoryBitMask = PhysicsCatagory.Ball
        ball.physicsBody?.collisionBitMask = PhysicsCatagory.Knee
        ball.physicsBody?.contactTestBitMask = PhysicsCatagory.Knee
        ball.physicsBody?.fieldBitMask = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.pinned = false
        ball.physicsBody?.isDynamic = true
        ball.position = CGPoint(x: 0, y: screenSize.height/2)
        ball.position = CGPoint(x: ball.position.x, y: ball.position.y)
        ball.physicsBody?.affectedByGravity=true
        addChild(ball)
    }
    
    
    
    func addGround(){
        
    }

    
    override func didMove(to view: SKView) {
           }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.yellow
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.yellow
            self.addChild(n)
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            startLocation = t.location(in: self)
        }
        //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       //for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        addAndRemoveObs(t: touches.first!)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        addAndRemoveObs(t: touches.first!)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCatagory.Ball && secondBody.categoryBitMask == PhysicsCatagory.Knee  {
            
            //ball.physicsBody?.restitution *= distance/50

            
            
            
        }
        else if firstBody.categoryBitMask == PhysicsCatagory.Knee && secondBody.categoryBitMask == PhysicsCatagory.Ball {
           
             //ball.physicsBody?.restitution *= distance/50
            
        }
    }

    
    
    func addAndRemoveObs(t: UITouch){
        
        let kneeTexture = SKTexture(imageNamed: "knee")
        
        let sprite = SKSpriteNode(texture: kneeTexture)
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width/2)
        
        
        //sprite.physicsBody = SKPhysicsBody(texture: kneeTexture,
                                                     // size: CGSize(width: sprite.size.width,
                                                               //    height: sprite.size.height))
        
        sprite.physicsBody?.isDynamic=false
        sprite.physicsBody?.affectedByGravity=false
        
        sprite.physicsBody?.friction = 0
        sprite.physicsBody?.restitution = 0
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sprite.physicsBody?.categoryBitMask = PhysicsCatagory.Knee
        sprite.physicsBody?.collisionBitMask = PhysicsCatagory.Ball
        sprite.physicsBody?.contactTestBitMask = PhysicsCatagory.Ball
        sprite.position = t.location(in: self)
        sprite.physicsBody?.linearDamping=0.1
        sprite.physicsBody?.angularDamping=0.1
        sprite.physicsBody?.velocity = CGVector(dx:0,dy:0)
       
        sprites.append(sprite)
        self.addChild(sprite)
        let action = SKAction.fadeOut(withDuration: 1)
        
        let dx = -(t.location(in: self).x - startLocation!.x)
        let dy = -(t.location(in: self).y - startLocation!.y)
        distance = sqrt(dx*dx + dy*dy )
        
        
        sprite.run(action, completion:
            {
                for s in self.sprites {
                    s.removeFromParent()
                }
                self.sprites.removeAll()
        })
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

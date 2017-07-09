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
    static let Ground : UInt32 = 0x1 << 4
}

protocol GameOverDelegate: class {
    func gameOver(score: Int)
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameOverDel: GameOverDelegate?
    var startLocation:CGPoint?
    var ball : SKSpriteNode
    var distance: CGFloat = 0.0
    var yVelocity:CGFloat = 0.0
    private var spinnyNode : SKShapeNode?
    var sprite: SKSpriteNode
    let scoreLbl = SKLabelNode()
    var sprites = [SKSpriteNode]()
    var score:Int = 0
    var touchable = true
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        let screenSize = UIScreen.main.bounds
        ball = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 55,height:  55))
        let ballTexture = SKTexture(imageNamed: "ball_usual")
        
        ball.texture = ballTexture
        let kneeTexture = SKTexture(imageNamed: "knee")
        
        sprite = SKSpriteNode(texture: kneeTexture)
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
        
        scoreLbl.position = CGPoint(x: -screenSize.width/2 + 40, y: screenSize.height/2 - 60)
        scoreLbl.text = "\(score)"
        scoreLbl.fontName = "Avenir"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 60
        self.addChild(scoreLbl)
    }
    
    func pausing(param: Bool){
        ball.isPaused = true
    }
    
    func addBall(){
        let screenSize = UIScreen.main.bounds
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        //ball.physicsBody?.applyImpulse(CGVector(dx: dx,dy: dy))
       // ball.zRotation = M_PI/4.0
        ball.physicsBody?.restitution = 1.0
        ball.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.categoryBitMask = PhysicsCatagory.Ball
        ball.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Knee
        ball.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground
        ball.physicsBody?.fieldBitMask = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.pinned = false
        ball.physicsBody?.isDynamic = true
        ball.position = CGPoint(x: 0, y: screenSize.height/2)
        ball.physicsBody?.affectedByGravity=true
        addChild(ball)
    }
    
    func addDanger(){
        let waitDuration = TimeInterval(arc4random_uniform(3))
        let waitAction = SKAction.wait(forDuration: waitDuration)
        let ballAction = SKAction.run(self.addBoutle)
        run(SKAction.repeatForever(SKAction.sequence([waitAction, ballAction])))
    }
    
    func addBoutle(){
        let screenSize = UIScreen.main.bounds
        let obsTexture = SKTexture(imageNamed: "boutle")
        let spriteBoutle = SKSpriteNode(texture: obsTexture)
        spriteBoutle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: spriteBoutle.size.width,
                                                                     height: spriteBoutle.size.height))
        spriteBoutle.physicsBody?.isDynamic=true
        spriteBoutle.physicsBody?.affectedByGravity=true
        
        spriteBoutle.physicsBody?.friction = 0
        spriteBoutle.physicsBody?.restitution = 0
        spriteBoutle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteBoutle.physicsBody?.categoryBitMask = PhysicsCatagory.Obstacle
        spriteBoutle.physicsBody?.collisionBitMask = PhysicsCatagory.Ball
        spriteBoutle.physicsBody?.contactTestBitMask = PhysicsCatagory.Ball
        spriteBoutle.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(screenSize.width))), y: screenSize.height/2 + spriteBoutle.size.height)
        spriteBoutle.physicsBody?.linearDamping=0.1
        spriteBoutle.physicsBody?.angularDamping=0.1
        spriteBoutle.physicsBody?.velocity = CGVector(dx:0,dy:0)
        self.addChild(spriteBoutle)
    }
    
    
    func addGround(){
        let screenSize = UIScreen.main.bounds
        let groundTexture = SKTexture(imageNamed: "ground")
        let spriteGround = SKSpriteNode(texture: groundTexture)
        spriteGround.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: spriteGround.size.width,
                                                                     height: spriteGround.size.height))
        spriteGround.physicsBody?.isDynamic=false
        spriteGround.physicsBody?.affectedByGravity=false
        
        spriteGround.physicsBody?.friction = 0
        spriteGround.physicsBody?.restitution = 0
        spriteGround.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteGround.physicsBody?.categoryBitMask = PhysicsCatagory.Ground
        spriteGround.physicsBody?.collisionBitMask = PhysicsCatagory.Ball
        spriteGround.physicsBody?.contactTestBitMask = PhysicsCatagory.Ball
        spriteGround.position = CGPoint(x: 0, y: -screenSize.height/2 + spriteGround.size.height/2)
        spriteGround.physicsBody?.linearDamping=0.1
        spriteGround.physicsBody?.angularDamping=0.1
        spriteGround.physicsBody?.velocity = CGVector(dx:0,dy:0)
        self.addChild(spriteGround)
        
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
    
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.yellow
//            self.addChild(n)
//        }
//    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchable {
            for t in touches {
                startLocation = t.location(in: self)
            }
        //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
            addObs(t: touches.first!)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
         if touchable {
            //for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
            sprite.position = (touches.first?.location(in: self))!
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchable {
            removeSprite()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchable {
            removeSprite()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if (firstBody.categoryBitMask == PhysicsCatagory.Ball && secondBody.categoryBitMask == PhysicsCatagory.Knee) || (firstBody.categoryBitMask == PhysicsCatagory.Knee && secondBody.categoryBitMask == PhysicsCatagory.Ball)  {
            score += 1
            scoreLbl.text = "\(score)"
            
           
        }
        
        if (firstBody.categoryBitMask == PhysicsCatagory.Ball && secondBody.categoryBitMask == PhysicsCatagory.Ground) || (firstBody.categoryBitMask == PhysicsCatagory.Ground && secondBody.categoryBitMask == PhysicsCatagory.Ball)  {
            gameOverDel?.gameOver(score: score)
            ball.removeFromParent()
            scoreLbl.removeFromParent()
           
        }
        
        if (firstBody.categoryBitMask == PhysicsCatagory.Ball && secondBody.categoryBitMask == PhysicsCatagory.Obstacle) || (firstBody.categoryBitMask == PhysicsCatagory.Obstacle && secondBody.categoryBitMask == PhysicsCatagory.Ball)  {
            gameOverDel?.gameOver(score: score)
            ball.removeFromParent()
            scoreLbl.removeFromParent()
            
        }
        
        
    }
    
    
    
    func addObs(t: UITouch){
        
        let kneeTexture = SKTexture(imageNamed: "knee")
        let obsTexture = SKTexture(imageNamed: "obs_pb")
        
        sprite = SKSpriteNode(texture: kneeTexture)
        //sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width/2)
        //sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width,
        //                                                       height: sprite.size.height))
        
        
        sprite.physicsBody = SKPhysicsBody(texture: obsTexture,
         size: CGSize(width: obsTexture.size().width,
            height: obsTexture.size().height))
        var r:CGFloat = 5.0
        var dx = r * cos (sprite.zRotation)
        var dy = r * sin (sprite.zRotation)
        sprite.physicsBody?.applyImpulse(CGVector(dx: dx,dy: dy))
        
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
        
    }
    
    func removeSprite(){
        let action = SKAction.fadeOut(withDuration: 1)
        
        // let dx = -(t.location(in: self).x - startLocation!.x)
        //let dy = -(t.location(in: self).y - startLocation!.y)
        //distance = sqrt(dx*dx + dy*dy )
        
        
        sprite.run(action, completion:
            {
                for s in self.sprites {
                    s.removeFromParent()
                }
                self.sprites.removeAll()
        })
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        let screenSize = UIScreen.main.bounds
        if ball.position.x > screenSize.width/2 + 65 || ball.position.x < -screenSize.width/2 - 65 || ball.position.y < -screenSize.height/2 - 100{
            gameOverDel?.gameOver(score: score)
            ball.removeFromParent()
            scoreLbl.removeFromParent()
        }
    }
}

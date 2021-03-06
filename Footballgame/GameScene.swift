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
    static let Coin : UInt32 = 0x1 << 5
}

protocol GameOverDelegate: class {
    func gameOver(score: Int)
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameOverDel: GameOverDelegate?
    var startLocation:CGPoint?
    var ball : SKSpriteNode
    var coin : SKSpriteNode
    var distance: CGFloat = 0.0
    var yVelocity:CGFloat = 0.0
    private var spinnyNode : SKShapeNode?
    var sprite: SKSpriteNode
    let scoreLbl = SKLabelNode()
    var sprites = [SKSpriteNode]()
    var score:Int = 0
    var touchable = true
    var timer: Timer?
    var counter = 0
    var coinAnimation: SKAction
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        print("init")
        var textures:[SKTexture] = []
        textures.append(SKTexture(imageNamed: "coin1"))
        textures.append(SKTexture(imageNamed: "coin2"))
        coin = SKSpriteNode(texture: SKTexture(imageNamed: "coin1"))
        coin.position = CGPoint(x: -400, y: -400)
        coinAnimation = SKAction.animate(with: textures,
                                         timePerFrame: 0.1)
        let screenSize = UIScreen.main.bounds
        ball = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 55,height:  55))
        let theme = ThemeManager.currentTheme().string
        let ballTexture = SKTexture(imageNamed: "ball_\(theme)")
        ball.texture = ballTexture
        let kneeTexture = SKTexture(imageNamed: "knee")
        ball = SKSpriteNode(imageNamed:"ball_\(theme)")
        sprite = SKSpriteNode(texture: kneeTexture)
        super.init(size: size)
        
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(GameScene.timerAction), userInfo:nil ,   repeats: true)
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
    
    func timerAction(){
        counter += 1
    }
    
    func startBallAnimation() {
        if coin.action(forKey: "animation") == nil {
            coin.run(
                SKAction.repeatForever(coinAnimation),
                withKey: "animation")
        }
    }
    
    func stopBallAnimation() {
        ball.removeAction(forKey: "animation")
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
        if touchable {
            for t in touches {
                if t.location(in: self).y <= ball.position.y{
                    //startLocation = t.location(in: self)
                     addObs(t: touches.first!)
                }
                //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
            }
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
        
        if ((firstBody.categoryBitMask == PhysicsCatagory.Ball && secondBody.categoryBitMask == PhysicsCatagory.Knee) || (firstBody.categoryBitMask == PhysicsCatagory.Knee && secondBody.categoryBitMask == PhysicsCatagory.Ball)) && counter > 5  {
            score += 1
            scoreLbl.text = "\(score)"
            counter = 0
            
        }
        
        if (firstBody.categoryBitMask == PhysicsCatagory.Ball && secondBody.categoryBitMask == PhysicsCatagory.Ground) || (firstBody.categoryBitMask == PhysicsCatagory.Ground && secondBody.categoryBitMask == PhysicsCatagory.Ball)  {
            gameOverDel?.gameOver(score: score)
            ball.removeFromParent()
            scoreLbl.removeFromParent()
            
        }
//        if (firstBody.categoryBitMask == PhysicsCatagory.Ball && secondBody.categoryBitMask == PhysicsCatagory.Coin) || (firstBody.categoryBitMask == PhysicsCatagory.Coin && secondBody.categoryBitMask == PhysicsCatagory.Ball)  {
//            if secondBody.categoryBitMask == PhysicsCatagory.Coin {
//                secondBody.node?.removeFromParent()
//            } else{
//                firstBody.node?.removeFromParent()
//            }
//            addCoins()
//            score += 3
//            scoreLbl.text = "\(score)"
//            
//        }
        
        if (firstBody.categoryBitMask == PhysicsCatagory.Ball && secondBody.categoryBitMask == PhysicsCatagory.Obstacle) || (firstBody.categoryBitMask == PhysicsCatagory.Obstacle && secondBody.categoryBitMask == PhysicsCatagory.Ball)  {
            gameOverDel?.gameOver(score: score)
            ball.removeFromParent()
            scoreLbl.removeFromParent()
            
        }
        
        
    }
    func addAndRemoveScoreLabelAndCoin(position: CGPoint){
        let doubleScoreLabel = SKLabelNode(text: "+3")
        doubleScoreLabel.fontSize = 54
        doubleScoreLabel.position = position
        addChild(doubleScoreLabel)
        coin.removeFromParent()
        let action = SKAction.scale(by: 1.5, duration: 1)
        doubleScoreLabel.run(action, completion:
        {
            doubleScoreLabel.removeFromParent()
        })
        addCoins()
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
        if ball.position.x > coin.position.x - coin.size.width/2 &&  ball.position.x < coin.position.x + coin.size.width/2 && ball.position.y < coin.position.y + coin.size.height/2 && ball.position.y > coin.position.y - coin.size.height/2  && coin.parent != nil{
            addAndRemoveScoreLabelAndCoin(position: coin.position)
            score += 3
            scoreLbl.text = "\(score)"
        }
        
    }
}
extension GameScene{
    
    func addBall(){
        let screenSize = UIScreen.main.bounds
        let theme = ThemeManager.currentTheme().string
        let ballTexture = SKTexture(imageNamed: "ball_\(theme)")
        //ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody = SKPhysicsBody(texture: ballTexture,
                                                      size: CGSize(width: ballTexture.size().width,
                                                                   height: ballTexture.size().height))
        //ball.physicsBody?.applyImpulse(CGVector(dx: dx,dy: dy))
        //ball.zRotation = M_PI/4.0
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.angularDamping = 0.4
        ball.physicsBody?.linearDamping = 0.4
        ball.physicsBody?.density = 0.2
        ball.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.categoryBitMask = PhysicsCatagory.Ball
        ball.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Knee | PhysicsCatagory.Coin
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
        changePhCaratOfBall()
    }
    
    func addDanger(){
        let waitDuration = TimeInterval(arc4random_uniform(3))
        let waitAction = SKAction.wait(forDuration: waitDuration)
        let ballAction = SKAction.run(self.addBoutle)
        run(SKAction.repeatForever(SKAction.sequence([waitAction, ballAction])))
        //run(SKAction.sequence([waitAction, ballAction]))
    }
    
    func addCoins(){
        let waitDuration = TimeInterval(arc4random_uniform(4))
        let waitAction = SKAction.wait(forDuration: waitDuration)
        let coinAction = SKAction.run(self.addCoin)
        //run(SKAction.repeatForever(SKAction.sequence([waitAction, coinAction])))
        run(SKAction.sequence([waitAction, coinAction]))
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
    
    func addCoin(){
        let screenSize = UIScreen.main.bounds
        
        //coin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: coin.size.width,
         //                                                            height: coin.size.height))
        //coin.physicsBody?.isDynamic=false
        //coin.physicsBody?.affectedByGravity=false
        
        //coin.physicsBody?.friction = 0
        //coin.physicsBody?.restitution = 0
        //coin.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //coin.physicsBody?.categoryBitMask = PhysicsCatagory.Coin
        //coin.physicsBody?.collisionBitMask = PhysicsCatagory.Ball
        //coin.physicsBody?.contactTestBitMask = PhysicsCatagory.Ball
        let rndX = arc4random_uniform(UInt32(screenSize.width/2))
        let rndY = arc4random_uniform(UInt32(screenSize.height/2-20))
        coin.position = CGPoint(x: CGFloat(rndX), y: CGFloat(rndY))
        //coin.position = CGPoint(x: 10, y: 100)
        //coin.physicsBody?.linearDamping=0.1
        //coin.physicsBody?.angularDamping=0.1
        //coin.physicsBody?.velocity = CGVector(dx:0,dy:0)
        self.addChild(coin)
        startBallAnimation()
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
        sprite.physicsBody?.isDynamic=false
        sprite.physicsBody?.affectedByGravity=false
        //sprite.physicsBody?.density = 0.1
        
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
    
    func changePhCaratOfBall(){
        let theme = ThemeManager.currentTheme().string
        switch theme {
        case ThemeBall.usual.string:
            print("usual")
            self.physicsWorld.gravity = CGVector(dx: 0,dy: -6.8)
        case ThemeBall.tennis.string:
            print("tennis")
            self.physicsWorld.gravity = CGVector(dx: 0,dy: -12)
        case ThemeBall.bowling.string:
            print("bowling")
            self.physicsWorld.gravity = CGVector(dx: 0,dy: -2)
        case ThemeBall.golf.string:
            print("golf")
             self.physicsWorld.gravity = CGVector(dx: 0,dy: -6)
        case ThemeBall.big_balloon.string:
            print("big_balloon")
            self.physicsWorld.gravity = CGVector(dx: 0,dy: -2)
        default:
            print("default")
        }
    }
}

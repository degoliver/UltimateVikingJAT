//
//  GameScene.swift
//  CocosSwift
//
//  Created by Thales Toniolo on 10/09/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
import Foundation

// MARK: - Class Definition
class GameScene: CCScene, CCPhysicsCollisionDelegate {
	// MARK: - Public Objects
	
	// MARK: - Private Objects
    let labelPause:CCSprite = CCSprite(imageNamed: "paused.png")
    var pauseButton:CCButton = CCButton(title: "[ Pause ]", fontName: "Verdana-Bold", fontSize: Float(screenSize.height) * 0.04)
    private var score:CGFloat = 0
    var labelScore:CCLabelTTF = CCLabelTTF(string: "Score: 0", fontName: "Verdana", fontSize: screenSize.height * 0.04)
    let player:Player = Player()
    let line:Line = Line()
    var physicsWorld:CCPhysicsNode = CCPhysicsNode()
    
    var speedGenerate:CCTime = 2.0
    
    var canPlay = true
    var canTap = true
	
	// MARK: - Life Cycle
	override init() {
		super.init()
        self.userInteractionEnabled = true
        
        let background: CCSprite = CCSprite(imageNamed: "bgCenario.png")
        background.anchorPoint = CGPointMake(0.0, 0.0)
        background.position = CGPointMake(0.0, 0.0)
        background.scale = 1
        print(background.contentSize.width)
        self.addChild(background, z:ObjectsLayers.Background.rawValue)

		// Back button
		let backButton:CCButton = CCButton(title: "[ Quit ]", fontName: "Verdana-Bold", fontSize: Float(screenSize.height) * 0.04)
		backButton.color = CCColor.blackColor()
        backButton.position = CGPointMake(screenSize.width/1.01, screenSize.height/1.01)
		backButton.anchorPoint = CGPointMake(1.0, 1.0)
		backButton.zoomWhenHighlighted = false
		backButton.block = {_ in
            if(CCDirector.sharedDirector().paused){ StateMachine.sharedInstance.pauseScene() }
            StateMachine.sharedInstance.changeScene(StateMachineScenes.HomeScene, isFade:true)}
		self.addChild(backButton, z:ObjectsLayers.HUD.rawValue)
        
        // Back button
        pauseButton.color = CCColor.blackColor()
        pauseButton.position = CGPointMake(screenSize.width/1.01 - backButton.contentSize.width, screenSize.height/1.01)
        pauseButton.anchorPoint = CGPointMake(1.0, 1.0)
        pauseButton.zoomWhenHighlighted = false
        pauseButton.block = {_ in StateMachine.sharedInstance.pauseScene() }
        self.addChild(pauseButton, z:ObjectsLayers.HUD.rawValue)
        
        //Pause
        labelPause.position = CGPointMake(screenSize.width/2, screenSize.height/2)
        labelPause.anchorPoint = CGPointMake(0.5, 0.5)
        labelPause.visible = false
        self.addChild(labelPause, z:ObjectsLayers.HUD.rawValue)
        
        labelScore.color = CCColor.blackColor()
        labelScore.position = CGPointMake(screenSize.width/2, screenSize.height/1.01)
        labelScore.anchorPoint = CGPointMake(0.5, 1.0)
        self.addChild(labelScore, z:ObjectsLayers.HUD.rawValue)
        
        line.anchorPoint = CGPointMake(0, 0)
        line.position = CGPointMake(0, 0)
        self.addChild(line, z:ObjectsLayers.Background.rawValue)
        
        player.position = CGPointMake(player.contentSize.width/2, screenSize.height/1.8)
        self.addChild(player, z:ObjectsLayers.Player.rawValue)
        
        self.physicsWorld.collisionDelegate = self
        self.physicsWorld.gravity = CGPointZero
        self.addChild(self.physicsWorld, z:ObjectsLayers.Background.rawValue)
	}

	override func onEnter() {
		// Chamado apos o init quando entra no director
		super.onEnter()
        DelayHelper.sharedInstance.callFunc("generateEnemy", onTarget: self, withDelay: 0.1)
	}

	// Tick baseado no FPS
	override func update(delta: CCTime) {
        
	}
    
    func generateEnemy() {
        if (self.canPlay) {
            
            var enemyFrame:Int = 0
            if (arc4random_uniform(100) > 70) {
                enemyFrame = 2
            }else{
                enemyFrame = 1
            }
            
            let positionY:CGFloat = CGFloat(arc4random_uniform(UInt32(screenSize.height/1.5)))
            let enemy:Enemy = Enemy(target: self, enemyFrame: enemyFrame)
            enemy.position = CGPointMake(screenSize.width + (CGFloat(arc4random_uniform(100) + 50)), positionY)
            enemy.name = "enemy"
            self.physicsWorld.addChild(enemy, z: ObjectsLayers.Foes.rawValue)
            enemy.moveMe()
            
            // Apos geracao, registra nova geracao apos um tempo
            DelayHelper.sharedInstance.callFunc("generateEnemy", onTarget: self, withDelay: self.speedGenerate)
        }
    }
    
    func updateScore(point:CGFloat) {
        self.score+=point
        self.labelScore.string = "Score: \(self.score)"
    }
    
    override func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
        if(canTap){
        let locationInView:CGPoint = CCDirector.sharedDirector().convertTouchToGL(touch)
        shipDoFire(locationInView)
        }
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, PlayerAxe axe: PlayerAxe!, Enemy enemy: Enemy!) -> Bool {
        enemy.life--
        
        if (enemy.life <= 0) {
            //Remove o inimigo
            enemy.die()
            SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.SoundFXPuf)
            updateScore(enemy.damage)
            
            //if (arc4random_uniform(100) > 90) {
                criaPowerUp(enemy.position)
            //}
        }
        axe.removeFromParentAndCleanup(true)
        return true
    }

    func criaPowerUp(position:CGPoint){
        let power:PowerUp = PowerUp(event: "contabilizaPower", target: self)
        power.position = position
        self.addChild(power, z: ObjectsLayers.Foes.rawValue)
    }
    
    func contabilizaPower(){
        
    }
    
	// MARK: - Private Methods

	// MARK: - Public Methods
    func shipDoFire(position:CGPoint) {
        let axe:PlayerAxe = PlayerAxe(damage: player.damage)
        axe.anchorPoint = CGPointMake(0.5, 0.5)
        axe.position = CGPointMake(self.player.position.x + self.player.contentSize.width/3, self.player.position.y)
        
        var mult = abs(screenSize.width/ccpSub(position, axe.position).x)
        if(mult > abs(screenSize.height/ccpSub(position, axe.position).y)){ mult = abs(screenSize.height/ccpSub(position, axe.position).y) }
        
        let rotate:CCAction = CCActionRepeatForever.actionWithAction(CCActionRotateBy.actionWithDuration(0.5, angle: 360) as! CCActionInterval) as! CCAction
        axe.runAction(rotate)

        axe.runAction(CCActionSequence.actionOne(CCActionMoveBy.actionWithDuration(1.5, position:
            CGPointMake(ccpSub(position, axe.position).x*mult, ccpSub(position, axe.position).y*mult)) as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ () -> Void in
            axe.removeFromParentAndCleanup(true)
        }) as! CCActionFiniteTime) as! CCAction)
        self.physicsWorld.addChild(axe, z:ObjectsLayers.Shot.rawValue)
        // Solta o som do disparo
        //SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.SoundFXButtonTap)*/
    }
    
	// MARK: - Delegates/Datasources
	
	// MARK: - Death Cycle
	override func onExit() {
		// Chamado quando sai do director
		super.onExit()
	}
}

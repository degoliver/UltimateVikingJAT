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
    private var score:Int = 0
    var labelScore:CCLabelTTF = CCLabelTTF(string: "Score: 0", fontName: "Verdana", fontSize: screenSize.height * 0.04)
    let player:Player = Player()
    let line:Line = Line()
    var physicsWorld:CCPhysicsNode = CCPhysicsNode()
    
    var powerUpCriado = false
    var speedGenerate:CCTime = 2.0
    var lastScoreUpdate:Int = 0
    
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
    
    func gameOver() {
        self.canPlay = false
        // Cancela todas as acoes na cena
        self.stopAllActions()
        // Registra o novo best score caso haja
        let oldScore:Int = NSUserDefaults.standardUserDefaults().integerForKey("KeyBestScore")
        if (self.score > oldScore) {
            NSUserDefaults.standardUserDefaults().setInteger(self.score, forKey: "KeyBestScore")
        }
        // Percorre e cancela toda movimentacao dos piratas
        for node:AnyObject in self.physicsWorld.children as [AnyObject] {
            if (node.isKindOfClass(Enemy)) {
                let enemy:Enemy = node as! Enemy
                enemy.stopAllSpriteActions()
            }
        }
        // Exibe o texto para retry
        let gameOverLabel:CCLabelTTF = CCLabelTTF(string: "-== GameOver ==-\nTap To Restart",
            fontName: "Chalkduster", fontSize: screenSize.width * 0.0371)
        gameOverLabel.horizontalAlignment = CCTextAlignment.Center
        gameOverLabel.color = CCColor.redColor()
        gameOverLabel.shadowColor = CCColor.blackColor()
        gameOverLabel.shadowOffset = CGPointMake(2.0, -2.0)
        gameOverLabel.position = CGPointMake(screenSize.width/2, screenSize.height/2)
        gameOverLabel.anchorPoint = CGPointMake(0.5, 0.5)
        self.addChild(gameOverLabel, z: ObjectsLayers.HUD.rawValue)
    }

	override func onEnter() {
		// Chamado apos o init quando entra no director
		super.onEnter()
        DelayHelper.sharedInstance.callFunc("generateEnemy", onTarget: self, withDelay: 0.1)
	}

	// Tick baseado no FPS
	override func update(delta: CCTime) {
        if(line.status>2 && canPlay){
            gameOver()
        }
	}
    
    func generateEnemy() {
        if (self.canPlay) {
            
            var enemyFrame:Int = 0
            if (arc4random_uniform(100) > 70) {
                enemyFrame = 2
            }else{
                enemyFrame = 1
            }
            
            let enemy:Enemy = Enemy(target: self, enemyFrame: enemyFrame)
            let positionY:CGFloat = CGFloat(arc4random_uniform(UInt32(screenSize.height/CGFloat(1.7)))) + enemy.height()
            
            enemy.position = CGPointMake(screenSize.width + (CGFloat(arc4random_uniform(100) + UInt32(enemy.width()))), positionY)
            enemy.name = "enemy"
            self.physicsWorld.addChild(enemy, z: ObjectsLayers.Foes.rawValue)
            enemy.moveMe()
            
            // Apos geracao, registra nova geracao apos um tempo
            DelayHelper.sharedInstance.callFunc("generateEnemy", onTarget: self, withDelay: self.speedGenerate)
        }
    }
    
    func updateScore(point:Int) {
        self.score+=point
        self.labelScore.string = "Score: \(self.score)"
        
        if(score - lastScoreUpdate >= 50 && speedGenerate > 0.1){
            speedGenerate -= 0.2
            lastScoreUpdate = score
        }
    }
    
    override func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
        if(canTap && canPlay){
        let locationInView:CGPoint = CCDirector.sharedDirector().convertTouchToGL(touch)
        shipDoFire(locationInView)
        }else if(!canPlay){
            StateMachine.sharedInstance.changeScene(StateMachineScenes.GameScene, isFade: true)
        }
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, PlayerAxe axe: PlayerAxe!, Enemy enemy: Enemy!) -> Bool {
        if(axe == nil || enemy == nil){ return true }
        enemy.life -= axe.damage
        
        if (enemy.life <= 0) {
            //Remove o inimigo
            enemy.die()
            SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.SoundFXPuf)
            updateScore(enemy.damage)
            
            if (arc4random_uniform(100) > 90 && !powerUpCriado) {
                criaPowerUp(enemy.position)
            }
        }
        axe.removeFromParentAndCleanup(true)
        return true
    }

    func criaPowerUp(position:CGPoint){
        powerUpCriado = true
        let power:PowerUp = PowerUp(event: "contabilizaPower", target: self)
        power.position = position
        self.addChild(power, z: ObjectsLayers.Foes.rawValue)
    }
    
    func contabilizaPower(){
        if(!player.powerUP){
            player.powerUP = true
            player.color = CCColor(red: 255, green: 0, blue: 0, alpha: 0.7)
            player.damage = player.damage * 3
            DelayHelper.sharedInstance.callFunc("contabilizaPower", onTarget: self, withDelay: 10)
        } else{
            player.powerUP = false
            player.color = CCColor.whiteColor()
            player.damage = player.damage / 3
            powerUpCriado = false
        }
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

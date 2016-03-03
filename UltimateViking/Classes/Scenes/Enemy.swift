//
//  EnemyShip.swift
//  SpaceWar
//
//  Created by Thales Toniolo on 11/10/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
// MARK: - Class Definition
class Enemy : CCSprite {
	// MARK: - Public Objects
	var life:CGFloat = 0
    var damage:CGFloat = 0
    var speed:CGFloat = 0
    var enemyFrame:Int = 0
    
    internal var targetID:AnyObject?
    private var spriteEnemy:CCSprite?
    
    convenience init(target:AnyObject, enemyFrame:Int) {
        self.init()
        
        self.targetID = target
        self.enemyFrame = enemyFrame
        
        if(self.enemyFrame==1){
            self.life = 3
            self.damage = 3
            self.speed = 6
        }else{
            self.life = 7
            self.damage = 7
            self.speed = 3
        }
        
        self.spriteEnemy = self.gerarAnimacaoSpriteWithName(self.enemyFrame, aQtdFrames: 18)
        self.spriteEnemy!.anchorPoint = CGPointMake(0.0, 0.0);
        self.spriteEnemy!.position = CGPointMake(0.0, 0.0);
        
        self.contentSize = self.spriteEnemy!.boundingBox().size
        
        // Configuracoes default
        self.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), cornerRadius: 0.0)
        self.physicsBody.type = CCPhysicsBodyType.Kinematic
        self.physicsBody.friction = 1.0
        self.physicsBody.elasticity = 0.1
        self.physicsBody.mass = 100.0
        self.physicsBody.density = 100.0
        self.physicsBody.collisionType = "Enemy"
        self.physicsBody.collisionCategories = ["Enemy"]
        self.physicsBody.collisionMask = ["PlayerAxe"]
        
        
        
        self.addChild(self.spriteEnemy, z:2)
    }
    
	// MARK: - Life Cycle
	override init() {
		super.init()
	}
	
	override init(CGImage image: CGImage!, key: String!) {
		super.init(CGImage: image, key: key)
	}
	
	override init(spriteFrame: CCSpriteFrame!) {
		super.init(spriteFrame: spriteFrame)
	}
	
	override init(texture: CCTexture!) {
		super.init(texture: texture)
	}
	
	override init(texture: CCTexture!, rect: CGRect) {
		super.init(texture: texture, rect: rect)
	}
	
	override init(texture: CCTexture!, rect: CGRect, rotated: Bool) {
		super.init(texture: texture, rect: rect, rotated: rotated)
	}
	
	override init(imageNamed imageName: String!) {
		super.init(imageNamed: imageName)
	}
    
    internal func width() -> CGFloat {
        return self.spriteEnemy!.boundingBox().size.width
    }
    
    internal func height() -> CGFloat {
        return self.spriteEnemy!.boundingBox().size.height
    }
    
    internal func stopAllSpriteActions() {
        self.spriteEnemy!.stopAllActions()
        self.stopAllActions()
    }
    
    internal func moveMe() {
        self.runAction(CCActionSequence.actionOne(CCActionMoveTo.actionWithDuration(CCTime(self.speed), position: CGPointMake(self.width() * -2, position.y)) as! CCActionFiniteTime,
            two: CCActionCallBlock.actionWithBlock({ _ in
                self.stopAllSpriteActions()
                self.removeFromParentAndCleanup(true)
            }) as! CCActionFiniteTime)
            as! CCAction)
    }
    
    func gerarAnimacaoSpriteWithName(enemyFrame:Int, aQtdFrames:Int) -> CCSprite {
        // Carrega os frames da animacao dentro do arquivo passado dada a quantidade de frames
        var animFrames:Array<CCSpriteFrame> = Array()
        for (var i = 1; i <= aQtdFrames; i++) {
            let name:String = "Pirata \(self.enemyFrame)00\(String(format: "%02d", i)).png"
            animFrames.append(CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName(name))
        }
        // Cria a animacao dos frames montados
        let animation:CCAnimation = CCAnimation(spriteFrames: animFrames, delay: 0.04)
        // Cria a acao com a animacao dos frames
        let animationAction:CCActionAnimate = CCActionAnimate(animation: animation)
        // Monta a repeticao eterna da animacao
        let actionForever:CCActionRepeatForever = CCActionRepeatForever(action: animationAction)
        // Monta o sprite com o primeiro quadro
        let spriteRet:CCSprite = CCSprite(imageNamed: "Pirata \(self.enemyFrame)000\(1).png")
        // Executa a acao da animacao
        spriteRet.runAction(actionForever)
        
        // Retorna o sprite para controle na classe
        return spriteRet
    }
    
    func die(){
        createParticle()
        self.removeFromParentAndCleanup(true)
    }
    
    func createParticle() {
        // Config File
        let particleFile:CCParticleSystem = CCParticleSystem(file: "EnemyDie.plist")
        particleFile.position = self.position
        particleFile.autoRemoveOnFinish = true
        self.targetID!.addChild(particleFile, z: ObjectsLayers.Foes.rawValue)
    }
	
	override func onEnter() {
		// Chamado apos o init quando entra no director
		super.onEnter()
    }
	
	// MARK: - Private Methods
	
	// MARK: - Public Methods
	
	// MARK: - Delegates/Datasources
	
	// MARK: - Death Cycle
	deinit {
		// Chamado no momento de desalocacao
	}
}

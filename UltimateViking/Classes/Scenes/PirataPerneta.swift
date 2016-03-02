//
//  Barata.swift
//  CocosSwift
//
//  Created by Usuário Convidado on 19/02/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

/*import UIKit

class Barata: CCNode {

    internal var eventSelector:Selector?
    internal var targetID:AnyObject?
    private var alive:Bool = true
    private var spriteBarata:CCSprite?
    private var bloodSpill:CCSprite = CCSprite(imageNamed: "blood.png")
    
    convenience init(event:Selector, target:AnyObject) {
        self.init()
        self.eventSelector = event
        self.targetID = target
    }
    
    override init() {
        super.init()
        self.userInteractionEnabled = true
        
        spriteBarata = self.gerarAnimacaoSpriteWithName("barata", aQtdFrames: 3)
        spriteBarata!.position = CGPointMake(0.0,0.0)
        spriteBarata!.anchorPoint = CGPointMake(0.0,0.0)
        self.addChild(spriteBarata)
        
        self.contentSize = self.spriteBarata!.boundingBox().size
        
        bloodSpill.position = CGPointMake(0.0,0.0)
        bloodSpill.anchorPoint = CGPointMake(0.0,0.0)
        bloodSpill.opacity = 0
        self.addChild(bloodSpill)
    }
    
    override func onEnter() {
            // Chamado apos o init quando entra no director
            super.onEnter()
    }
    
    // MARK: - Death Cycle
    deinit {
        // Chamado no momento de desalocacao
    }
    
    func gerarAnimacaoSpriteWithName(aSpriteName:String, aQtdFrames:Int) -> CCSprite {
                // Carrega os frames da animacao dentro do arquivo passado dada a quantidade de frames
                var animFrames:Array<CCSpriteFrame> = Array()
                for (var i = 1; i <= aQtdFrames; i++) {
                    let name:String = "\(aSpriteName)\(i).png"
                    animFrames.append(CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName(name))
                }
                // Cria a animacao dos frames montados
                let animation:CCAnimation = CCAnimation(spriteFrames: animFrames, delay: 0.1)
                // Cria a acao com a animacao dos frames
                let animationAction:CCActionAnimate = CCActionAnimate(animation: animation)
                // Monta a repeticao eterna da animacao
                let actionForever:CCActionRepeatForever = CCActionRepeatForever(action: animationAction)
                // Monta o sprite com o primeiro quadro
                let spriteRet:CCSprite = CCSprite(imageNamed: "\(aSpriteName)\(1).png")
                // Executa a acao da animacao
                spriteRet.runAction(actionForever)
                // Retorna o sprite para controle na classe
                return spriteRet
    }
    
    internal func moveMe() {
        let speed:CGFloat = CGFloat(arc4random_uniform(4) + 2)
        self.runAction(CCActionSequence.actionOne(CCActionMoveTo.actionWithDuration(CCTime(speed), position: CGPointMake(self.position.x, self.height() * -2)) as! CCActionFiniteTime,  two: CCActionCallBlock.actionWithBlock({ _ in
        self.stopAllSpriteActions()
        self.removeFromParentAndCleanup(true)
        }) as! CCActionFiniteTime)
        as! CCAction)
    }
    
    internal func stopAllSpriteActions() {
        self.spriteBarata!.stopAllActions()
        self.stopAllActions()
    }
        
    internal func width() -> CGFloat {
        return self.spriteBarata!.boundingBox().size.width
    }
        
    internal func height() -> CGFloat {
        return self.spriteBarata!.boundingBox().size.height
    }
    
    override func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
                    if (!(self.targetID as! GameScene).canPlay) {
                    return
                    }
                    // Caso jah tenha recebido o tap, nao permite outro sobre o mesmo inseto
                    if (!self.alive) {
                    return
                    }
                    criaParticula()
                    self.alive = false
                    // Barulho da barata morrendo
                    OALSimpleAudio.sharedInstance().playEffect("FXSquitch.mp3")
                    self.stopAllSpriteActions()
                    // Apresenta o blood e oculta a barata
                    self.bloodSpill.opacity = 255.0
                    self.spriteBarata?.opacity = 0.0
                    self.bloodSpill.runAction(CCActionSequence.actionOne(CCActionFadeOut.actionWithDuration(1.2) as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ _ in
                    self.removeFromParentAndCleanup(true)
                    }) as! CCActionFiniteTime) as! CCAction)
                    // Mata a barata e executa o evento informado
                    DelayHelper.sharedInstance.callFunc(self.eventSelector!,
                    onTarget: self.targetID!, withDelay: 0.0)
    }
    
    func criaParticula() {
                    let custom:CCParticleFlower = CCParticleFlower(totalParticles: 300)
                    custom.position = CGPointMake(width()/2, height()/2)
                    custom.duration = 1.5
                    custom.radialAccel = -30
                    //custom.tangentialAccel = 70
                    custom.angle = 360
                    custom.angleVar = 30
                    custom.startColor = CCColor.redColor()
                    custom.life = 0.5
                    custom.startSize = 20.0
                    custom.endSize = 1.0
                    custom.autoRemoveOnFinish = true
                    self.addChild(custom)
    }

}*/

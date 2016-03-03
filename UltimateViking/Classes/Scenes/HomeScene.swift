//
//  HomeScene.swift
//  CocosSwift
//
//  Created by Thales Toniolo on 10/09/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
import Foundation

// MARK: - Class Definition
class HomeScene : CCScene {
	// MARK: - Public Objects

	// MARK: - Private Objects

	// MARK: - Life Cycle
	override init() {
		super.init()

        let background: CCSprite = CCSprite(imageNamed: "bgCenario.png")
        background.anchorPoint = CGPointMake(0.0, 0.0)
        background.position = CGPointMake(0.0, 0.0)
        background.scale = 1
        self.addChild(background)

		let label:CCLabelTTF = CCLabelTTF(string: "The Ultimate \nViking", fontName: "Verdana", fontSize: screenSize.height*0.117)
        label.horizontalAlignment = CCTextAlignment.Center
        label.color = CCColor.blackColor()
		label.position = CGPointMake(screenSize.width/2, screenSize.height/1.2)
		label.anchorPoint = CGPointMake(0.5, 0.5)
		self.addChild(label)
        
        let score:Int = NSUserDefaults.standardUserDefaults().integerForKey("KeyBestScore")
        let labelBestScore:CCLabelTTF = CCLabelTTF(string: "Best Score: \(score)", fontName: "Verdana", fontSize:  screenSize.width*0.0488)
        labelBestScore.color = CCColor.blackColor()
        labelBestScore.position = CGPointMake(screenSize.width/2, screenSize.height/9)
        labelBestScore.anchorPoint = CGPointMake(0.5, 0.5)
        self.addChild(labelBestScore)
        
        let img1: CCSprite = CCSprite(imageNamed: "player.png")
        img1.position = CGPointMake(screenSize.width/5,screenSize.height/2)
        img1.scale = 3
        self.addChild(img1)
       
        let img2:CCSprite = CCSprite(imageNamed: "Pirata 20018.png")
        img2.position = CGPointMake(screenSize.width/4*3.1,screenSize.height/4)
        img2.scale = 3
        self.addChild(img2)
        
        let img3:CCSprite = CCSprite(imageNamed: "Pirata 10001.png")
        img3.position = CGPointMake(screenSize.width/4*3.5,screenSize.height/4*3)
        img3.scale = 3
        self.addChild(img3)
        

		// ToGame Button
		let toGameButton:CCButton = CCButton(title: "[ Start ]", fontName: "Verdana-Bold", fontSize: Float(screenSize.width) * 0.0371)
        toGameButton.color = CCColor.blackColor()
		toGameButton.position = CGPointMake(screenSize.width/2.0, screenSize.height/2.0)
		toGameButton.anchorPoint = CGPointMake(0.5, 0.5)
//		toGameButton.setTarget(self, selector:"startTap:")
		toGameButton.block = {_ in
            SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.SoundFXButtonTap)
            StateMachine.sharedInstance.changeScene(StateMachineScenes.GameScene, isFade:true)
        }
		self.addChild(toGameButton)
	}

	override func onEnter() {
		// Chamado apos o init quando entra no director
		super.onEnter()
	}

	// MARK: - Private Methods
//	func startTap(sender:AnyObject) {
//		StateMachine.sharedInstance.changeScene(StateMachine.StateMachineScenes.GameScene, isFade:true)
//	}

	// MARK: - Public Methods

	// MARK: - Delegates/Datasources

	// MARK: - Death Cycle
	override func onExit() {
		// Chamado quando sai do director
		super.onExit()
	}
}

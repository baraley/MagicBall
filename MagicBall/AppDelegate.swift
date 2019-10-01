//
//  AppDelegate.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/6/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {

		let answerSetsModel = AnswerSetsModel(answerSetsService: AnswerSetsService())
		let answerSourcesModel = AnswerSourcesModel(
			answerSetsModel: answerSetsModel,
			networkAnswerModel: NetworkAnswerModel()
		)

		let answerSettingsModel = AnswerSettingsModel(settingsService: SettingsService())

		let magicBallModel = MagicBallModel(answerSourceModel: answerSourcesModel, answerPronouncer: TextPronouncer())

		let appRootViewController = StoryboardScene.Main.appRootViewController.instantiate()

		appRootViewController.magicBallModel = magicBallModel
		appRootViewController.answerSourcesModel = answerSourcesModel
		appRootViewController.answerSetsModel = answerSetsModel
		appRootViewController.answerSettingsModel = answerSettingsModel

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = appRootViewController
		window?.makeKeyAndVisible()

		return true
	}

}

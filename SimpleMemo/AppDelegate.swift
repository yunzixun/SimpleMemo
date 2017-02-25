//
//  AppDelegate.swift
//  SimpleMemo
//
//  Created by  李俊 on 2017/2/25.
//  Copyright © 2017年 Lijun. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    let mainController = MemoListViewController()
    let navController = UINavigationController(rootViewController: mainController)
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = UIColor.white
    window?.rootViewController = navController
    window?.makeKeyAndVisible()

    loadDefaultMemos()

    return true
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    CoreDataStack.default.saveContext()
  }

  func applicationWillTerminate(_ application: UIApplication) {
    CoreDataStack.default.saveContext()
  }

}

private extension AppDelegate {

  func loadDefaultMemos(){
    let oldVersion = UserDefaults.standard.object(forKey: "MemoVersion") as? String
    if oldVersion != nil {
      return
    }

    let dict = Bundle.main.infoDictionary!
    let version = dict["CFBundleShortVersionString"] as! String
    UserDefaults.standard.set(version, forKey: "MemoVersion")

    guard let path = Bundle.main.path(forResource: "DefaultMemos", ofType: "plist") else {
      return
    }
    let memos = NSArray(contentsOfFile: path) as! [String]
    for memoText in memos {
      let memo = CoreDataStack.default.createMemo()
      memo.text = memoText
      CoreDataStack.default.saveContext()
    }
  }

}


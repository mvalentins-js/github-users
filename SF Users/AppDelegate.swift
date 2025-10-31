//
//  AppDelegate.swift
//  SF Users
//
//  Created by Monika Stoyanova on 30.10.25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewModel = SFUserViewModel(repository: SFRepository()) // TODO: Create a coordinator
        let viewController = SFUserListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
}


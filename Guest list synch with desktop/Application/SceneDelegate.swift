//
//  SceneDelegate.swift
//  Guest list synch with desktop
//
//  Created by Алексей Коваленко on 24.10.2022.
//

import UIKit
import FirebaseAuth


import GoogleSignIn
import GTMSessionFetcher
import GoogleAPIClientForREST

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let navigationController = UINavigationController()
        let firebaseService = FirebaseService()
        let firebeseDatabase = FirebaseDatabase()
        let networkService = NetworkService()
        let assemblyBuilder = AssemblyModuleBuilder(networkService: networkService, firebaseService: firebaseService, firebaseDatabase: firebeseDatabase)

//        FirebaseService().logOutWithFirebase()

        print("Auth check: is user loginned?")
        
        let user = Auth.auth().currentUser
        if user == nil {
            FirebaseService().logOutWithFirebase()
            print("user == nil, auth module initialization")
            let router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
            router.showAuthModule()
        } else {
            print("user != nil, eventsList module initialization")
            guard let user = user else {
                fatalError("failed")
            }
            //Google restorePreviousSignIn
            GIDSignIn.sharedInstance.restorePreviousSignIn { googleUser, error in
                if error != nil || googleUser == nil {
                    print("googleUser == nil, need to authenteticate user with google")
                } else {
                    print("googleUser != nil")
                }
            }
            firebaseService.setupUserToTheApp(user: user)
            let router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
            router.showEventsListModule(userUID: user.uid)
        }
        

        self.window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

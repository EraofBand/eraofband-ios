//
//  SceneDelegate.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/01.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import Alamofire

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
            if let url = URLContexts.first?.url {
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
        }
     
     
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as? OnboardingViewController else { return }
        
        if appDelegate.isFirstRun == true{ // 앱 최초실행 시 온보딩 실행
            window?.rootViewController = onboardingVC
        } else{ // 앱 최초실행이 아닐 시 온보딩 자동 스킵
            // 토큰 있는지 확인
                let userIdx = defaults.string(forKey: "userIdx") ?? "null"
                        /*자동 로그인*/
                        if(userIdx != "null"){
                            let header : HTTPHeaders = [
                                "x-access-token": self.defaults.string(forKey: "jwt")!,
                                "Content-Type": "application/json"]
                            
                            AF.request(self.appDelegate.baseUrl + "/users/auto-login/" + String(userIdx),
                                       method: .patch,
                                       encoding: JSONEncoding.default,
                                       headers: header
                            ).responseDecodable(of: DefaultResultModel.self){ response in
                                switch response.result{
                                case .success(let data):
                                    guard let mainTabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBar") as? TabBarController else { return }
                                    self.window?.rootViewController = mainTabBarVC
                                    
                                    break;
                                case .failure(let err):
                                    guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
                                    self.window?.rootViewController = loginVC
                                    
                                    break;
                                }
                            }
                        }else{
                            guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
                            self.window?.rootViewController = loginVC
                        }
                }
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


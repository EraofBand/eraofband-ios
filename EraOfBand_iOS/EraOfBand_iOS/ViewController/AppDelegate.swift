//
//  AppDelegate.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/01.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import KakaoSDKUser
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public let baseUrl = "https://eraofband.shop" //rest api 베이스 url 전역변수
    public var myKakaoData: kakaoData!
    /*
    public var expiration: Int?
    public var jwt: String = ""
    public var refresh: String = ""
    public var userIdx: Int?
     */
    public var userSession: Int?
    
    public var isFirstRun: Bool?
    public var isAutoLogin = false
    
    let kakaoKey = Bundle.main.kakaoKey

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                return AuthController.handleOpenUrl(url: url)
            }

            return false
        }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        KakaoSDK.initSDK(appKey: kakaoKey)
        
        FirebaseApp.configure()
        
        // 앱 전체 네비게이션 바 custom
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]
            navigationBarAppearance.backgroundColor = .clear
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
        
        sleep(1)
        
        checkAppFirstrunOrUpdateStatus{
            isFirstRun = true
        } updated: {
            isFirstRun = false
        } nothingChanged: {
            isFirstRun = false
        }
        
        /*무음모드에서 미디어 소리 활성화*/
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch let error as NSError {
            print("Error : \(error), \(error.userInfo)")
        }
                
        do {
             try AVAudioSession.sharedInstance().setActive(true)
        }
          catch let error as NSError {
            print("Error: Could not setActive to true: \(error), \(error.userInfo)")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


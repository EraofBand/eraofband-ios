//
//  CheckFirstRun.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/08/07.
//

import Foundation

func checkAppFirstrunOrUpdateStatus(firstrun: () -> (), updated: () -> (), nothingChanged: () -> ()) {
    let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    let versionOfLastRun = UserDefaults.standard.object(forKey: "VersionOfLastRun") as? String
    // print(#function, currentVersion ?? "", versionOfLastRun ?? "")
    if versionOfLastRun == nil {
        // First start after installing the app
        firstrun()
    } else if versionOfLastRun != currentVersion {
        // App was updated since last run
        updated()
    } else {
        // nothing changed
        nothingChanged()
    }
    UserDefaults.standard.set(currentVersion, forKey: "VersionOfLastRun")
    UserDefaults.standard.synchronize()
}

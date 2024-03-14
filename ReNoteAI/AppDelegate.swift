//
//  AppDelegate.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 14/02/24.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}

func application(
  _ app: UIApplication,
  open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
) -> Bool {
  
  // Handle other custom URL types.

  // If not handled by this app, return false.
  return false
}

//
//  SettingsManager.swift
//  Dxtr
//
//  Created by Rick on 2/5/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import Foundation

class SettingsManager: NSObject {
  
  class var sharedInstance: SettingsManager {
    struct Singleton {
      static let instance: SettingsManager = SettingsManager()
    }
    return Singleton.instance
  }
  
  func isNightscoutUploadEnabled() -> Bool {
    let defaults = NSUserDefaults.standardUserDefaults()
    return defaults.boolForKey(NIGHTSCOUT_UPLOAD_ENABLED_PREFERENCE)
  }
  
  func getNightscoutURL() -> String? {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let urlString = defaults.stringForKey(NIGHTSCOUT_URL_PREFERENCE) {
      var url = urlString
      if !url.hasPrefix("http://") && !url.hasPrefix("https://") {
        url = "https://" + url;
      }
      if !url.hasSuffix("/") {
        url += "/"
      }
      return url;
    }
    return nil
  }
  
  func getNightscoutAPISecret() -> String? {
    let defaults = NSUserDefaults.standardUserDefaults()
    return defaults.stringForKey(NIGHTSCOUT_API_SECRET_PREFERENCE)
  }
  
}
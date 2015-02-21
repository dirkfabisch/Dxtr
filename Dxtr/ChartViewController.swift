//
//  ChartViewController.swift
//  Dxtr
//
//  Created by Rick on 2/16/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import UIKit
import CoreData

class ChartViewController: UIViewController, UIWebViewDelegate {

  @IBOutlet weak var webView: UIWebView!

  var managedObjectContext : NSManagedObjectContext?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let url = NSBundle.mainBundle().URLForResource("chart", withExtension: "html")!
    self.webView.loadRequest(NSURLRequest(URL: url))
    
  }
  
  //MARK: UIWebViewDelegate
  
  func webViewDidFinishLoad(webView: UIWebView) {
    logger.debug("webViewDidFinishLoad")
    
    if let readings = BGReading.bgReadingsSinceDate(self.managedObjectContext!, date: NSDate().dateByAddingTimeInterval(2 * 24 * 60 * 60 * -1)) {
      var data: [NSDictionary] = []
      for reading in readings {
        var readingDictionary = [String: AnyObject]()
        readingDictionary["date"] = reading.timeStamp!
        readingDictionary["sgv"] = reading.calculatedValue!
        data.append(readingDictionary)
      }
      let jsonData = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.allZeros, error: nil)!
      var jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
      jsonString = jsonString?.stringByReplacingOccurrencesOfString("\'", withString: "\\\'")
      jsonString = jsonString?.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
      jsonString = jsonString?.stringByReplacingOccurrencesOfString("\n", withString: "\\n")
      jsonString = jsonString?.stringByReplacingOccurrencesOfString("\r", withString: "")

      self.webView.stringByEvaluatingJavaScriptFromString("updateData('\(jsonString!)')")
      
    }
  }
}

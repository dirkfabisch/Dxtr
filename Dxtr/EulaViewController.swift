//
//  EulaViewController.swift
//  Dxtr
//
//  Created by Dirk on 10/02/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class EulaViewController : UIViewController {
  
  // custom types for "Cancel" and "Finish" delegates
  typealias DidFinishDelegate = (EulaViewController) -> ()
  var didFinish: DidFinishDelegate?
  
  @IBOutlet weak var acceptSwitch: UISwitch!
  var managedObjectContext : NSManagedObjectContext?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBarHidden = true
    let defaults = NSUserDefaults.standardUserDefaults()
    acceptSwitch.on = defaults.boolForKey(USER_SETTING_EULA_CHECKED)
  }
  
  
  // "Done" action notifies "Finish" delegate
  @IBAction func done(sender: AnyObject) {
    // check EULA accepted!
    if acceptSwitch.on == true {
      let defaults = NSUserDefaults.standardUserDefaults()
      defaults.setBool(true, forKey: USER_SETTING_EULA_CHECKED)
      self.didFinish!(self)
    } else {
      
      let alertController = UIAlertController(title: "Accept EULA", message: "You have to accept the EULA, if you wish to use Dxtr!", preferredStyle: .Alert)
      
      let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
      alertController.addAction(defaultAction)
      
      presentViewController(alertController, animated: true, completion: nil)
    }
  }
}

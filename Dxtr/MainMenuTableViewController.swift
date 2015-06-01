//
//  MainMenuTableViewController.swift
//  Dxtr
//
//  Created by Dirk on 26/04/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import UIKit

enum MenuEntryType {
  case Segue
  case Action
}

struct MenuEntry {
  let displayName : String
  let active : Bool
  let segueName: String
  let image : UIImage
  let type : MenuEntryType
}

let menuEntry : [MenuEntry] = [
  MenuEntry(displayName: "Dxtr", active: true, segueName: "mainMenu", image: UIImage(named: "dxtrMenuLogo.png")!, type: .Segue),
  MenuEntry(displayName: "Start Sensor", active: true, segueName: "startSensorSegue", image: UIImage(named: "dexcomMenuLogo.png")!, type: .Segue),
  MenuEntry(displayName: "Stop Sensor", active: false, segueName: "stopSensorSegue", image: UIImage(named: "dexcomMenuLogo.png")!, type: .Action),
  MenuEntry(displayName: "Calibrate Sensor", active: true, segueName: "", image: UIImage(named: "calibrateMenuLogo.png")!, type: .Segue)
]

class MainMenuTableViewController: UITableViewController {
  var selectedMenuItem : Int = 0
  var smc : ENSideMenuNavigationController?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Customize apperance of table view
    tableView.contentInset = UIEdgeInsetsMake(24.0, 0, 0, 0) //
    tableView.separatorStyle = .None
    tableView.backgroundColor = UIColor.clearColor()
    tableView.scrollsToTop = false
    
    // Preserve selection between presentations
    self.clearsSelectionOnViewWillAppear = false
    
    tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // Return the number of sections.
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of rows in the section.
    return menuEntry.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
    
    if (cell == nil) {
      cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
      cell!.backgroundColor = UIColor.clearColor()
      cell!.textLabel?.textColor = UIColor.whiteColor()
      let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
      selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
      cell!.selectedBackgroundView = selectedBackgroundView
      
    }
    
    cell!.textLabel?.text = menuEntry[indexPath.row].displayName
    cell!.imageView?.image = menuEntry[indexPath.row].image
    if !menuEntry[indexPath.row].active {
      cell!.textLabel?.textColor = UIColor.grayColor()
    }
    return cell!
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 50.0
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    logger.debug("did select row: \(indexPath.row)")
    
    if (indexPath.row == selectedMenuItem) {
      smc?.hideSideMenuView()
      return
    }

    if !menuEntry[indexPath.row].active {
      return
    }
    
    selectedMenuItem = indexPath.row
    
    if menuEntry[indexPath.row].type == .Segue {
      //      smc!.performSegueWithIdentifier(menuEntry[indexPath.row].segueName, sender: self)
      
      let pvc = smc!.presentedViewController
      
      let nv = smc!.navigationController
      
      smc!.navigationController?.presentedViewController?.performSegueWithIdentifier(menuEntry[indexPath.row].segueName, sender: self)
      smc?.hideSideMenuView()
    }
 }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  }
  */
  
}


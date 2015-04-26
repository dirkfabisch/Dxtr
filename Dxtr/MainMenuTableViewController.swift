//
//  MainMenuTableViewController.swift
//  Dxtr
//
//  Created by Dirk on 26/04/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import UIKit
import ENSwiftSideMenu


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
    return 4
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
    
    if (cell == nil) {
      cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
      cell!.backgroundColor = UIColor.clearColor()
      cell!.textLabel?.textColor = UIColor.darkGrayColor()
      let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
      selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
      cell!.selectedBackgroundView = selectedBackgroundView
    }
    
    cell!.textLabel?.text = "ViewController #\(indexPath.row+1)"
    
    return cell!
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 50.0
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    println("did select row: \(indexPath.row)")
    
    if (indexPath.row == selectedMenuItem) {
      smc?.hideSideMenuView()
      return
    }
    selectedMenuItem = indexPath.row

//    // Side bar delegate
//    func sideBarDidSelectButtonAtIndex(index: Int) {
//      
//      if index == 0{
//        writeDisplayLog("start sensor")
//        performSegueWithIdentifier("startSensorSegue", sender: self)
//        sideBar.toggleMenu()
//      } else if index == 1{
//        writeDisplayLog("stop sensor")
//        sideBar.toggleMenu()
//      } else if index == 2{
//        writeDisplayLog("double calibration")
//        sideBar.toggleMenu()
//      }
//    }

    
    
    //Present new view controller
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    var destViewController : UIViewController
    switch (indexPath.row) {
    case 0:
      destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController1") as! UIViewController
      break
    case 1:
      destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController2")as! UIViewController
      break
    case 2:
      destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController3")as! UIViewController
      break
    default:
      destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController4") as! UIViewController
      break
    }
    sideMenuController()?.setContentViewController(destViewController)
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


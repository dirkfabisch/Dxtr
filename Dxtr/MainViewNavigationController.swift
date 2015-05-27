//
//  MainViewNavigationController.swift
//  Dxtr
//
//  Created by Dirk on 26/04/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//


import UIKit
import ENSwiftSideMenu

class MainViewNavigationController: ENSideMenuNavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()

    var mmtvc = MainMenuTableViewController()
    mmtvc.smc = self
    sideMenu = ENSideMenu(sourceView: view, menuTableViewController: mmtvc, menuPosition: .Left)
    
    // sideMenu?.menuWidth = 180.0 // optional, default is 160
    //sideMenu?.bouncingEnabled = false
    navigationController?.navigationBarHidden = true
    
    // make navigation bar showing over side menu
    //        view.bringSubviewToFront(navigationBar)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

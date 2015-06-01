//
//  AddBGReadingViewController.swift
//  Dxtr
//
//  Created by Dirk on 09/02/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import B68UIFloatLabelTextField

class AddBGReadingViewController : UIViewController, UITextFieldDelegate {
  
  // custom types for "Cancel" and "Finish" delegates
  typealias DidCancelDelegate = (AddBGReadingViewController) -> ()
  typealias DidFinishDelegate = (AddBGReadingViewController) -> ()
  var didCancel: DidCancelDelegate?
  var didFinish: DidFinishDelegate?
  
  var managedObjectContext : NSManagedObjectContext?
  
  var bgReadingValue : Double = 0.0
  
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var bgReadingTextField: B68UIFloatLabelTextField!

  
  // view set setup
  override func viewDidLoad() {
    //Looks for single or multiple taps.
    var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
    view.addGestureRecognizer(tap)
    
    // disable save button as long as no valid bgreading is available
    saveButton.enabled = false
    bgReadingTextField.delegate = self
  
  }
  
  
  
  // MARK: TextField delegates
  func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    bgReadingValue = Double(bgReadingTextField.text.toInt()!)
    if bgReadingValue > 10000 {
      saveButton.enabled = true
    } else {
      saveButton.enabled = false
    }
    return true
  }
  
  // dismiss keyboard if touch outside textview
  func dismissKeyboard() {
    bgReadingTextField.resignFirstResponder()
  }
  
  // set the date picker to the
  @IBAction func getSensorStartDate(sender: AnyObject) {
    if let sensor = Sensor.currentSensor(managedObjectContext!) {
      let startDate = sensor.sensorStarted!.doubleValue.getDate()
      datePicker.date = startDate
    }
  }
  
  //MARK: - Exit functions
  // "Cancel" action notifies "Cancel" delegate
  @IBAction func cancel(sender: AnyObject) {
    
    // notify delegate (master list scene view controller)
    self.didCancel!(self)
  }
  
  // "Done" action notifies "Finish" delegate
  @IBAction func done(sender: AnyObject) {
    // Create a new Sensor object and start the sensor
    let date = datePicker.date
    var td = TransmitterData(managedObjectContext: managedObjectContext!, timeStamp: date.getTime())
    td.rawData = (bgReadingTextField.text as NSString).doubleValue
    td.sendTDNewValueNotificcation()
    DxtrModel.sharedInstance.saveContext()
    // notify delegate (master list scene view controller)
    self.didFinish!(self)
  }
}

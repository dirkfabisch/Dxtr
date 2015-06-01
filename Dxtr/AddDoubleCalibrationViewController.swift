//
//  AddDoubleCalibrationViewController.swift
//  Dxtr
//
//  Created by Dirk on 10/02/15.
//  Copyright (c) 2015 Dirk. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import B68UIFloatLabelTextField


class AddDoubleCalibrationViewController : UIViewController, UITextFieldDelegate {
  
  // custom types for "Cancel" and "Finish" delegates
  typealias DidCancelDelegate = (AddDoubleCalibrationViewController) -> ()
  typealias DidFinishDelegate = (AddDoubleCalibrationViewController) -> ()
  var didCancel: DidCancelDelegate?
  var didFinish: DidFinishDelegate?
  
  var managedObjectContext : NSManagedObjectContext?
  
  var bgReadingValue : Double = 0.0
  
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var firstBGReadingTextField: B68UIFloatLabelTextField!
  @IBOutlet weak var secondBGReadingTextField: B68UIFloatLabelTextField!
  
  // view set setup
  override func viewDidLoad() {
    //Looks for single or multiple taps.
    var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
    view.addGestureRecognizer(tap)
    
    // disable save button as long as no valid bgreading is available
    saveButton.enabled = false
    firstBGReadingTextField.delegate = self
    secondBGReadingTextField.delegate = self
  }
  
  
  
  // MARK: TextField delegates
  func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    if !firstBGReadingTextField.text.isEmpty && !secondBGReadingTextField.text.isEmpty {
      saveButton.enabled = true
    } else {
      saveButton.enabled = false
    }
    return true
  }
  
  // dismiss keyboard if touch outside textview
  func dismissKeyboard() {
    if firstBGReadingTextField.isFirstResponder() {
      firstBGReadingTextField.resignFirstResponder()
    }
    if secondBGReadingTextField.isFirstResponder() {
      secondBGReadingTextField.resignFirstResponder()
    }
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
    // Create two calibrations
    var cDate = datePicker.date
    let calibration1 = Calibration(managedObjectContext: DxtrModel.sharedInstance.managedObjectContext!, newBG: (firstBGReadingTextField.text as NSString).doubleValue, timeStamp: cDate.getTime())
    // add 1 second to second calibration
    let calibration2 = Calibration(managedObjectContext: DxtrModel.sharedInstance.managedObjectContext!, newBG: (secondBGReadingTextField.text as NSString).doubleValue, timeStamp: cDate.dateByAddingTimeInterval(1).getTime())
    DxtrModel.sharedInstance.saveContext()
    
    // Upload to Nightscout
    NightscoutUploader.sharedInstance.uploadCalibrationRecord(calibration1)
    NightscoutUploader.sharedInstance.uploadCalibrationRecord(calibration2)
    
    // notify delegate (master list scene view controller)
    self.didFinish!(self)
  }
}

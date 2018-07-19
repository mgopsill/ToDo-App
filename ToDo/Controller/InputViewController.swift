//
//  InputViewController.swift
//  ToDo
//
//  Created by Mike Gopsill on 05/12/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class InputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    var itemManager: ItemManager?
    
    var dateFormatter:  DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }

    
    
    @IBAction func save() {
        guard let titleString = titleTextField.text, titleString.count > 0 else { return }

        let date: Date?
        if let dateText = dateTextField.text, dateText.count > 0 {
            date = dateFormatter.date(from: dateText)
        } else {
            date = nil
        }
        let descriptionString: String?
        if !((descriptionTextField.text?.isEmpty)!) {
            descriptionString = descriptionTextField.text
        } else {
            descriptionString = nil
        }
        
        if let locationName = locationTextField.text, locationName.count > 0 {
            if let address = addressTextField.text, address.count > 0 {
                geocoder.geocodeAddressString(address) { [unowned self] (placeMarks, error) -> Void in
                    let placeMark = placeMarks?.first
                    
                    let item = ToDoItem(title: titleString, itemDescription: descriptionString, timeStamp: date?.timeIntervalSince1970, location: Location(name: locationName, coordinates: placeMark?.location?.coordinate))
                    
                    //note this crashes when you use an address as it attempts to update the itemManager of the view controller
                    //after the view controller is dismissed
                    //see https://stackoverflow.com/questions/24177973/why-self-is-deallocated-when-calling-unowned-self
                    
  
                    self.itemManager?.addItem(item)
                    self.dismiss(animated: true, completion: nil)
                
                }
            } else {
                let item = ToDoItem(title: titleString, itemDescription: descriptionString, timeStamp: date?.timeIntervalSince1970, location: nil)
                itemManager?.addItem(item)
                dismiss(animated: true, completion: nil)
            }
        } else {
            let item = ToDoItem(title: titleString, itemDescription: descriptionString, timeStamp: date?.timeIntervalSince1970, location: nil)
            itemManager?.addItem(item)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(){
        dismiss(animated: true, completion: nil)
    }
}

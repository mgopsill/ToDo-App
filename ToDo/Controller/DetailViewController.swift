//
//  DetailViewController.swift
//  ToDo
//
//  Created by Mike Gopsill on 21/11/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var itemInfo: (ItemManager, Int)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let itemInfo = itemInfo else { fatalError() }
        let item = itemInfo.0.itemAtIndex(itemInfo.1)
        
        titleLabel.text = item.title
        locationLabel.text = item.location?.name
        descriptionLabel.text = item.itemDescription
        
        if let timestamp = item.timeStamp {
            let date = Date(timeIntervalSince1970: timestamp)
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = nil
        }
        
        if let coordinate = item.location?.coordinates {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
            mapView.region = region
        }
    }
    
    
    func checkItem() {
        if let itemInfo = itemInfo {
            itemInfo.0.checkItemAtIndex(itemInfo.1)
        }
    }
    
}

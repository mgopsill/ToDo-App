//
//  ItemCell.swift
//  ToDo
//
//  Created by Mike Gopsill on 15/11/2017.
//  Copyright © 2017 Mike Gopsill. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()
    
    func configCellWithItem(_ item: ToDoItem, checked: Bool = false) {
        if checked {
            titleLabel.attributedText = NSAttributedString(string: item.title, attributes: [NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue])
            locationLabel.text = nil
            dateLabel.text = nil
        } else {
            titleLabel.text = item.title
            locationLabel.text = item.location?.name
            
            if let timestamp = item.timeStamp {
                let date = Date(timeIntervalSince1970: timestamp)
                dateLabel.text = dateFormatter.string(from: date)
            } else {
                dateLabel.text = nil
            }
        }
        
    }
}

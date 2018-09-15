//
//  SearchResultCell.swift
//  Cedar Maps
//
//  Created by Saeed Taheri on 7/14/17.
//  Copyright © 2017 Cedar Studios. All rights reserved.
//

import UIKit
import CedarMaps

final class CSSearchResultCell: UITableViewCell {
    
    var placemark: CSForwardGeocodePlacemark! {
        didSet {
            typeLabel.text = placemark.persianType
            
            nameLabel.text = placemark.name
            addressLabel.text = placemark.fullAddress
            addressLabel.isHidden = addressLabel.text!.isEmpty
        }
    }
    
    @IBOutlet private weak var typeLabel: UILabel! {
        didSet {
            typeLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
            typeLabel.textColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        }
    }
    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        }
    }
    @IBOutlet private weak var addressLabel: UILabel! {
        didSet {
            addressLabel.font = UIFont.preferredFont(forTextStyle: .body)
            addressLabel.textColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        }
    }
}

extension CSForwardGeocodePlacemark {
    var fullAddress: String {
        var result = ""
        if let city = components.city, !city.isEmpty {
            result += city
        }
        
        if let address = address, !address.isEmpty {
            if result.isEmpty {
                result = address
            } else {
                result = result + "، " + address
            }
        } else if let localities = components.localities, localities.count > 0 {
            var locality = ""
            for i in 0..<min(2, localities.count) {
                let l = localities[i]
                if (locality.isEmpty) {
                    locality = l;
                } else {
                    locality = locality + "، " + l;
                }
            }
            if !locality.isEmpty {
                if result.isEmpty {
                    result = locality
                } else {
                    result = result + "، " + locality
                }
            }
        }
        
        return result.replacingOccurrences(of: ",", with: "، ")
    }
    
    var persianType: String {
        let streetType = [
            "freeway": "آزادراه",
            "expressway": "بزرگراه",
            "road": "جاده",
            "boulevard": "بلوار",
            "roundabout": "میدان",
            "street": "خیابان",
            "locality": "محله",
            "poi": "مکان",
            "region": "منطقه"
        ]
        return streetType[type] ?? "نامشخص"
    }
}

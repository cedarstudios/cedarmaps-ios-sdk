//
//  CSReverseGeocodeViewController.swift
//  CedarMaps_Example
//
//  Created by Saeed Taheri on 10/29/17.
//  Copyright © 2017 Saeed Taheri. All rights reserved.
//

import UIKit
import CedarMaps

final class CSReverseGeocodeViewController: UIViewController {

    @IBOutlet private weak var mapView: CSMapView! {
        didSet {
            mapView.delegate = self
			mapView.styleURL = URL(string: CSMapViewStyle.vectorDark.rawValue)
        }
    }
    @IBOutlet private weak var labelBackgroundView: UIView! {
        didSet {
            let layer = labelBackgroundView.layer
            layer.cornerRadius = 12.0
            layer.masksToBounds = false
            layer.shadowOffset = CGSize.zero
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowRadius = 12.0
            layer.shadowOpacity = 0.1
            layer.rasterizationScale = UIScreen.main.scale
            layer.shouldRasterize = true
            layer.backgroundColor = UIColor.white.cgColor;
        }
    }
    @IBOutlet private weak var label: UILabel! {
        didSet {
            label.isHidden = true
            label.adjustsFontForContentSizeCategory = true
        }
    }
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reverseGeocode(coordinate: mapView.centerCoordinate)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        spinner.isHidden = false
        spinner.startAnimating()
        label.isHidden = true
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
		
        CSMapKit.shared.reverseGeocodeLocation(location,
											   addressFormat: nil,
											   formattedAddressPrefixLength: .short,
											   formattedAddressSeparator: nil,
											   formattedAddressVerbosity: false) { [weak self] (placemark, error) in
            defer {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.label.isHidden = false
            }
            if let placemark = placemark {
                self?.label.text = placemark.formattedAddress ?? "No address available"
            } else if let error = error {
                self?.label.text = error.localizedDescription
            }
        }
    }
}

extension CSReverseGeocodeViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        reverseGeocode(coordinate: mapView.centerCoordinate)
    }
}

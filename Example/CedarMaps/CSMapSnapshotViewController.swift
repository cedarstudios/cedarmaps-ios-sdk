//
//  CSMapSnapshotViewController.swift
//  CedarMaps_Example
//
//  Created by Saeed Taheri on 10/30/17.
//  Copyright © 2017 Saeed Taheri. All rights reserved.
//

import UIKit
import CedarMaps

final class CSMapSnapshotViewController: KeyboardEntryViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var hintLabel: UILabel!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            mainScrollView = scrollView
        }
    }
    @IBOutlet private weak var latitudeTextField: UITextField! {
        didSet {
            latitudeTextField.delegate = self
        }
    }
    @IBOutlet private weak var longitudeTextField: UITextField! {
        didSet {
            longitudeTextField.delegate = self
        }
    }
    @IBOutlet private weak var zoomLevelTextField: UITextField! {
        didSet {
            zoomLevelTextField.delegate = self
        }
    }
    @IBOutlet private weak var submitButton: UIButton! {
        didSet {
            submitButton.setTitleColor(UIColor.white, for: .normal)
            submitButton.backgroundColor = self.tabBarController?.tabBar.tintColor
            submitButton.layer.cornerRadius = 10.0
            submitButton.layer.masksToBounds = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { (context) in
            if let _ = self.view.window, let imageView = self.imageView, let _ = imageView.image {
                self.createSnapshot()
            }
        }
    }
    
    @IBAction private func submit(_ sender: UIButton?) {
        createSnapshot()
    }
    
    private func createSnapshot() {
        view.endEditing(true)
        
        guard let latitudeStr = latitudeTextField?.text, !latitudeStr.isEmpty, let latitude = Double(latitudeStr),
            let longitudeStr = longitudeTextField?.text, !longitudeStr.isEmpty, let longitude = Double(longitudeStr),
            let zoomLevelStr = zoomLevelTextField?.text, !zoomLevelStr.isEmpty, let zoomLevel = Int(zoomLevelStr)
            else {
                let alert = UIAlertController(title: NSLocalizedString("Input Empty", comment: ""), message: NSLocalizedString("Please fill all fields with appropriate values", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                return
        }
        
        let options = CSMapSnapshotOptions()
        options.center = CLLocation(latitude: latitude, longitude: longitude)
        options.zoomLevel = zoomLevel
        options.size = imageView.bounds.size
//        options.markers = [CSMapSnapshotMarker(coordinate: options.center!.coordinate)]
        
        spinner.isHidden = false
        spinner.startAnimating()
        hintLabel.isHidden = true
        submitButton.isEnabled = false

        CSMapKit.shared.createMapSnapshot(with: options) { [weak self] (snapshot, error) in
            self?.spinner.stopAnimating()
            self?.spinner.isHidden = true
            self?.submitButton.isEnabled = true
            
            if let error = error {
                let alert = UIAlertController(title: NSLocalizedString("Response Error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                return
            }
            if let image = snapshot?.image {
                self?.imageView.image = image
            }
            
            if self?.imageView.image == nil {
                self?.hintLabel.isHidden = false
            }
        }
    }
}

extension CSMapSnapshotViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case latitudeTextField:
            longitudeTextField.becomeFirstResponder()
        case longitudeTextField:
            zoomLevelTextField.becomeFirstResponder()
        case zoomLevelTextField:
            textField.resignFirstResponder()
            createSnapshot()
        default:
            return true
        }
        return false
    }
}

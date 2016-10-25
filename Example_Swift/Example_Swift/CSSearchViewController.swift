//
//  CSSearchViewController.swift
//  Example_Swift
//
//  Created by Saeed Taheri on 2016/10/25.
//  Copyright © 2016 Cedar Studios. All rights reserved.
//

import UIKit
import CedarMaps

class CSSearchViewController: UIViewController {

    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    fileprivate var mapKit = CSMapKit(mapID: "cedarmaps.streets")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customizing search view and textfield
        searchView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        searchView.layer.shadowOpacity = 0.3
        searchView.layer.shadowRadius = 1.5
        searchView.layer.cornerRadius = 2
        searchView.alpha = 0.95
        
        mapKit?.styleURL(completion: { (url) in
            DispatchQueue.main.async {
                self.mapView.styleURL = url
            }
        })
        
        mapView.attributionButton.alpha = 0
        mapView.logoView.alpha = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if mapView.annotations?.count == 0 {
            searchTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func attributionDidTouchUpInside(_ sender: UIButton?) {
        UIApplication.shared.openURL(URL(string: "http://cedarmaps.com")!)
    }
    
    fileprivate func search(with query: String?) {
        
        guard let query = query else { return }
        
        let params = CSQueryParameters()
        params.addLocation(with: mapView.centerCoordinate)
        params.addDistance(10.0)
        
        mapKit?.forwardGeocoding(withQueryString: query, parameters: params, completion: { (results, error) in
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                
                if error != nil {
                    let alert = UIAlertController(title: "بروز خطا", message: error?.localizedDescription ?? " ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "باشه", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                if let annotations = self.mapView.annotations, annotations.count > 0 {
                    self.mapView.removeAnnotations(annotations)
                }
                
                for item in results! where item is NSDictionary {
                    let itemDic = item as! NSDictionary
                    if let center = ((itemDic.object(forKey: "location") as? NSDictionary)?.object(forKey: "center") as? String)?.components(separatedBy: ","), center.count == 2 {
                        let coordinate = CLLocationCoordinate2DMake(Double(center[0])!, Double(center[1])!)
                        
                        let annotation = MGLPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = itemDic.object(forKey: "name") as? String
                        
                        self.mapView.addAnnotation(annotation)
                    }
                }
                
                if results!.count > 0 {
                    if let firstAnnotation = self.mapView.annotations?.first {
                        self.mapView.setCenter(firstAnnotation.coordinate, animated: true)
                    }
                } else {
                    let alert = UIAlertController(title: "جستجو بدون نتیجه", message: "مکان مورد نظر پیدا نشد.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "باشه", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            
        })
    }
}

extension CSSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        spinner.startAnimating()
        textField.resignFirstResponder()
        search(with: textField.text)
        return false
    }
}

extension CSSearchViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        let image = MGLAnnotationImage(image: UIImage(named: "star")!, reuseIdentifier: "marker")
        return image
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}

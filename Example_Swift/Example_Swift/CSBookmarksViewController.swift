//
//  ViewController.swift
//  Example_Swift
//
//  Created by Saeed Taheri on 2016/10/25.
//  Copyright © 2016 Cedar Studios. All rights reserved.
//

import UIKit
import CedarMaps

class CSBookmarksViewController: UIViewController {

    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let auth = CSAuthenticationManager.shared()
        auth?.setCredentialsWithClientID("kikojas-7086923255815987087", clientSecret: "fV0vEWtpa29qYXPmgHyid2wIh4_hzJjA0WmOsUlgODl3J45aNp0KZwi3sQ==")
        
        let mapKit = CSMapKit(mapID: "cedarmaps.streets")
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
        
        markBusStation()
        markTrainStation()
        markPointNumberOne()
        markPointNumberTwo()
        markPointNumberThree()
    }

    @IBAction func attributionDidTouchUpInside(_ sender: UIButton?) {
        UIApplication.shared.openURL(URL(string: "http://cedarmaps.com")!)
    }
    
}

extension CSBookmarksViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        let image = MGLAnnotationImage(image: UIImage(named: annotation.subtitle!!)!, reuseIdentifier: annotation.subtitle!!)
        return image
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    fileprivate func markBusStation() {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(35.770889877650724, 51.439468860626214)
        annotation.title = "ایستگاه اتوبوس"
        annotation.subtitle = "bus_station"

        mapView.addAnnotation(annotation)
    }
    
    fileprivate func markTrainStation() {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(35.772857173873305, 51.437859535217285)
        annotation.title = "مترو"
        annotation.subtitle = "train_station"
        
        mapView.addAnnotation(annotation)
    }

    fileprivate func markPointNumberOne() {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(35.77633899479261, 51.4344048500061)
        annotation.title = "نقطه اول"
        annotation.subtitle = "point_one"
        
        mapView.addAnnotation(annotation)
    }

    fileprivate func markPointNumberTwo() {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(35.77943768718256, 51.437666416168206)
        annotation.title = "نقطه دوم"
        annotation.subtitle = "point_two"
        
        mapView.addAnnotation(annotation)
    }

    fileprivate func markPointNumberThree() {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(35.77773168047123, 51.44279479980469)
        annotation.title = "نقطه سوم"
        annotation.subtitle = "point_three"
        
        mapView.addAnnotation(annotation)
    }
}


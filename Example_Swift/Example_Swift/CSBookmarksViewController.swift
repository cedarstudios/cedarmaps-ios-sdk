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
    let mapKit = CSMapKit(mapID: "cedarmaps.streets")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let auth = CSAuthenticationManager.shared()
        auth?.setCredentialsWithClientID(nil, clientSecret: nil)
        
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
        
//        markBusStation()
//        markTrainStation()
//        markPointNumberOne()
//        markPointNumberTwo()
//        markPointNumberThree()
        
        
        mapKit?.reverseGeocoding(with: CLLocationCoordinate2DMake(35.770889877650724, 51.439468860626214), completion: { (result, error) in
            let city = result?["city"] as? String
            let locality = result?["locality"] as? String
            let address = result?["address"] as? String
            
            DispatchQueue.main.async {
                
                let point = MGLPointAnnotation()
                point.coordinate = CLLocationCoordinate2DMake(35.770889877650724, 51.439468860626214)
                point.title = "\(city ?? "شهر یافت نشد")، \(locality ?? "محله یافت نشد")، \(address ?? "آدرس یافت نشد")"
                point.subtitle = nil
                
                self.mapView.addAnnotation(point)
            }
        })
    }

    @IBAction func attributionDidTouchUpInside(_ sender: UIButton?) {
        UIApplication.shared.openURL(URL(string: "http://cedarmaps.com")!)
    }
    
}

extension CSBookmarksViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        guard let s1 = annotation.subtitle, let s2 = s1 else { return nil }
        let image = MGLAnnotationImage(image: UIImage(named: s2)!, reuseIdentifier: annotation.subtitle!!)
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


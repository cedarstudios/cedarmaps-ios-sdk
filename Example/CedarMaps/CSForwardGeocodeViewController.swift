//
//  CSForwardGeocodeViewController.swift
//  CedarMaps_Example
//
//  Created by Saeed Taheri on 10/31/17.
//  Copyright © 2017 Saeed Taheri. All rights reserved.
//

import UIKit
import CedarMaps

final class CSForwardGeocodeViewController: UIViewController {

    private var filteredResults = [CSForwardGeocodePlacemark]() {
        didSet {
            selectedItem = nil
            tableView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = self.filteredResults.count > 0 ? 1.0 : 0.0
            }
        }
    }
    private var selectedItem: CSForwardGeocodePlacemark? {
        didSet {
            if let existingAnnotations = mapView.annotations {
                mapView.removeAnnotations(existingAnnotations)
            }
            if let selectedItem = selectedItem, let coordinate = selectedItem.region?.center.coordinate {
                searchController.searchBar.resignFirstResponder()
                
                let annotation = MGLPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = selectedItem.name
                annotation.subtitle = selectedItem.address
                mapView.addAnnotation(annotation)
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView.alpha = 0
                }) { _ in
                    self.mapView.setCenter(coordinate, zoomLevel: 15, animated: true)
                }
            }
        }
    }
    
    @IBOutlet private weak var mapView: CSMapView! {
        didSet {
            mapView.delegate = self
            mapView.styleURL = URL(string: "https://api.cedarmaps.com/v1/tiles/light.json")
        }
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.alpha = 0
            tableView.keyboardDismissMode = .onDrag
        }
    }
    private var pendingSearchWorkItem: DispatchWorkItem?

    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private lazy var searchController: UISearchController = {
        let result = UISearchController(searchResultsController: nil)
        result.searchResultsUpdater = self
        result.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Search", comment: "")
        if #available(iOS 11, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.titleView = searchController.searchBar
            searchController.searchBar.sizeToFit()
        }
    }

    private func filterContentForSearchText(_ searchText: String) {
        pendingSearchWorkItem?.cancel()
        let searchWorkItem = DispatchWorkItem {
            CSMapKit.shared.geocodeAddressString(searchText) { [weak self] (results, error) in
                if let results = results, results.count > 0 {
                    self?.filteredResults = results
                } else {
                    self?.filteredResults = [CSForwardGeocodePlacemark]()
                }
            }
        }
        pendingSearchWorkItem = searchWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: searchWorkItem)
    }
}

extension CSForwardGeocodeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredResults.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CSSearchResultCell", for: indexPath) as! CSSearchResultCell
        cell.placemark = filteredResults[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedItem = filteredResults[indexPath.row]
    }
}

extension CSForwardGeocodeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension CSForwardGeocodeViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}

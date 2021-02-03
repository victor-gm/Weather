//
//  SearchTableViewController.swift
//  WeatherApp 2.0
//
//  Created by Víctor Garrido Martínez on 02/12/2019.
//  Copyright © 2019 Víctor Garrido Martínez. All rights reserved.
//

import UIKit
import MapKit

class SearchTableViewController: UITableViewController{
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var newCityAdded: () -> Void = {}
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "City, Village ..."
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.delegate = self;
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return matchingItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = ""
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedItem = matchingItems[indexPath.row].placemark
        
        // Update saveCities Data
        let test = Data.shared.savedCities!.contains(selectedItem.locality!)
        if test == false
        {
            Data.shared.updateData(cityName: selectedItem.locality!)
            { response in
                self.newCityAdded()
                self.dismiss(animated: true)
            }
        }else
        {
            self.dismiss(animated: true)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow
        {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
   
}

extension SearchTableViewController: UISearchBarDelegate
{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        dismiss(animated: true, completion: nil)
    }
}
    
extension SearchTableViewController: UISearchResultsUpdating
{
    
   func updateSearchResults(for searchController: UISearchController)
   {
    guard let searchBarText = searchController.searchBar.text else{return}
    

    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = searchBarText
    let regionRadius: CLLocationDistance = 1000000
    request.region = MKCoordinateRegion(center: Data.shared.lastLocation!.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
    MKLocalSearch(request: request).start
        { (response, error) in
            guard let response = response else { return }
            if response.mapItems.count == 0 { return  }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}




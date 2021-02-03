//
//  PageViewController.swift
//  WeatherApp 2.0
//
//  Created by Víctor Garrido Martínez on 01/12/2019.
//  Copyright © 2019 Víctor Garrido Martínez. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController
{
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
           return .lightContent
       }
        
    var orderedViewControllers = [TableViewController]()
    var savedCitiesCustom = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.dataSource = self
        view.backgroundColor = UIColor.clear
        

       savedCitiesCustom.append(Data.shared.lastLocationString!)
       
       for savedCity in Data.shared.savedCities!
       {
           savedCitiesCustom.append(savedCity)
       }
               
        for _ in 0..<(Data.shared.savedCities!.count + 1)
        {
            addViewController()
        }
        initViewController(index: 0)
        setViewControllers([orderedViewControllers[0]], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    { // Check if the table has been updated, not a big fan of callbacks!!!!. If it has been updated, it adds the viewcontroller of the city, loads it, shows it and reloads viewcontrollers
        
       //Miramos si se han añadido ciudades
       
       while (Data.shared.addedCities.count != 0)
       {
           let city = Data.shared.addedCities.first
           Data.shared.addedCities.removeFirst()
           savedCitiesCustom.append(city as! String)
           //print(savedCitiesCustom)
           //let index = Data.shared.savedForecasts.firstIndex(where: { $0.forecast.city == city })!
           let index = savedCitiesCustom.firstIndex(of: city!!)

           addViewController()
           initViewController(index: index!)
           setViewControllers([orderedViewControllers[0]], direction: .forward, animated: false, completion: nil)

       }
        
        //Miramos si se han borrado ciudades
        while (Data.shared.deletedCities.count != 0) 
        {
            let city = Data.shared.deletedCities.first
            Data.shared.deletedCities.removeFirst()

            let index = savedCitiesCustom.firstIndex(of: city!!)
            savedCitiesCustom.remove(at: index!)
           
            Data.shared.savedForecasts.remove(at: index!)
            Data.shared.savedBackgrounds.remove(at: index!)
           
            orderedViewControllers.remove(at: index!)
            setViewControllers([orderedViewControllers[0]], direction: .forward, animated: false, completion: nil)

        }

    }
    
    func addViewController()
    {
        let tableViewController = (UIStoryboard(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "Forecast") as! TableViewController)
        orderedViewControllers.append(tableViewController)
    }
}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    
    func initViewController (index: Int)
    {
        orderedViewControllers[index].index = index
    }
    
   
    func getController(viewController: UIViewController, action: String) -> TableViewController?
    {
        let city = (viewController as! TableViewController).city
       
        //print (savedCitiesCustom)
        
        let index = savedCitiesCustom.firstIndex(of: city!)
        print("index here", index!)
       
        if(action == "Before")
        {
            
            let previousIndex = index! - 1
            if previousIndex >= 0
            {
                initViewController(index: previousIndex)
                return orderedViewControllers[previousIndex]
            }
        }
        else
        {
            let afterIndex = index! + 1
            if afterIndex <= Data.shared.savedCities!.count // we have to take into account that the location city it's not included, so we add one
            {
               initViewController(index: afterIndex)
                
                if(orderedViewControllers[afterIndex].savedForecast == nil)
                {
                    self.orderedViewControllers[afterIndex].tableView.reloadData()
                }
                
                return orderedViewControllers[afterIndex]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        return getController(viewController: viewController,action :"Before")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        return getController(viewController: viewController,action : "After")
    }
}




    
    


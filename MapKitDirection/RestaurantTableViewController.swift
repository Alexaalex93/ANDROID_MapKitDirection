//
//  RestaurantTableViewController.swift
//  MapKitDirection
//
//  Created by Pablo Mateo Fernández on 27/01/2017.
//  Copyright © 2017 355 Berry Street S.L. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {

    var restaurants:[Restaurant] = [Restaurant(name: "Vips", type: "Cafetería", location: "524 Ct St, Brooklyn, NY 11231",phone: "232-923423", image: "resta001", isVisited: false),
                                    Restaurant(name: "Ginos", type: "Bar", location: "75 9th Ave, New York, NY 10011",phone: "232-923423", image: "resta002", isVisited: false),
                                    Restaurant(name: "Zalacaín", type: "Restaurante", location: "110 St Marks Pl New York, NY 10009",phone: "232-923423", image: "resta003", isVisited: false),
                                    Restaurant(name: "Diverxo", type: "Cafetería", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta004", isVisited: false),
                                    Restaurant(name: "La Bola", type: "Restaurante", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta005", isVisited: false),
                                    Restaurant(name: "Tanteo", type: "Bar", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta006", isVisited: false),
                                    Restaurant(name: "Daltea", type: "Restaurante", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta007", isVisited: false),
                                    Restaurant(name: "Plaza", type: "Cafetería", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta008", isVisited: false),
                                    Restaurant(name: "Rotonda", type: "Restaurante", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta009", isVisited: false),
                                    Restaurant(name: "Fridays", type: "Cafetería", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta0010", isVisited: false),
                                    Restaurant(name: "Opera", type: "Bar", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta0011", isVisited: false),
                                    Restaurant(name: "Camión", type: "Cafetería", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta0012", isVisited: false),
                                    Restaurant(name: "Panza", type: "Bar", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta0013", isVisited: false),
                                    Restaurant(name: "Sancho", type: "Restaurante", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta0014", isVisited: false),
                                    Restaurant(name: "La casa de Pi", type: "Cafetería", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta0015", isVisited: false),
                                    Restaurant(name: "Catorce", type: "Restaurante", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta0016", isVisited: false),
                                    Restaurant(name: "El Camino", type: "Cafetería", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta0017", isVisited: false),
                                    Restaurant(name: "Aperitivo", type: "Bar", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta0018", isVisited: false),
                                    Restaurant(name: "Rico rico", type: "Cafetería", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta0019", isVisited: false),
                                    Restaurant(name: "Arguiñano", type: "Bar", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta0020", isVisited: false),
                                    Restaurant(name: "Dani García", type: "Bar", location: "Calle Povedilla 4, Madrid",phone: "232-923423", image: "resta0021", isVisited: false)]

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return restaurants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.name
        cell.detailTextLabel?.text = restaurant.type
        cell.imageView?.image = UIImage(named: restaurant.image)

        return cell
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationController.restaurant = restaurants[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
}

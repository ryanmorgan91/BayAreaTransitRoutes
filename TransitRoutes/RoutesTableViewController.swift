//
//  DirectionsTableViewController.swift
//  TransitRoutes
//
//  Created by Ryan MORGAN on 3/30/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit

class RoutesTableViewController: UITableViewController {
    //TableView shows a row for each route returned by Google Directions API. 
    
    var directions: Directions?
    var routes = [Route]()
    var legs = [Leg]()
    var leg: Leg?
    var steps = [Leg.Step]()
    var step: Leg.Step?
    
    var origin: String?
    var destination: String?
    let directionsController = DirectionsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            updateUI()
    }

   
    func updateUI() {
       
        directionsController.fetchDirections(forOrigin: origin!, forDestination: destination!) { (directions) in
            guard let directions = directions else {return}
            DispatchQueue.main.async {
                
                if let routes = directions.routes {
                    self.routes = routes
                }
                
                self.tableView.reloadData()
            }
        }
    }
    

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return routes.count
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "directionsCell", for: indexPath)
        configure(cell, forRowAt: indexPath)
      
        return cell
    }
    
    func configure(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let route = routes[indexPath.row]
        guard let legs = route.legs else {return}
        self.legs = legs
        self.leg = legs.first!
        
        cell.textLabel?.text = leg!.distance?.text
        cell.detailTextLabel?.text = leg!.duration?.text

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "MapSegue" else {return}
        let destinationViewController = segue.destination as! MapViewController
        let indexPath = tableView.indexPathForSelectedRow!.row
        destinationViewController.route = routes[indexPath]
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

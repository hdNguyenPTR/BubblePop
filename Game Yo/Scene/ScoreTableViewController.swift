//
//  ScoreTableViewController.swift
//  Game Yo
//
//  Created by Huu Nguyen on 9/5/19.
//  Copyright © 2019 Huu Nguyen. All rights reserved.
//

import Foundation
import UIKit

// structure for highscore array
struct Score {
    
    var playerName : String
    var points : Int64
    
}

class ScoreTableViewController: UITableViewController {
    
    // variable declaration
    var highScoreArray: [Score] = [Score]()
    
    // function when view finish loading
    override func viewWillAppear(_ animated: Bool) {
        // variable declaration
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //get points from data
        let retrievedPoints = appDelegate.getPoints()
        // convert data to
        for score in retrievedPoints {
            highScoreArray.append(convertToPointsArray(point: score))
        }
        // map data to array
        highScoreArray = retrievedPoints.map({
            convertToPointsArray(point: $0)
        })

    }
    
    // function to convert data to struct
    func convertToPointsArray(point: HighScore) -> Score {
        let newScore = Score(playerName: point.playerName!, points: point.score)
        return newScore
    }
    
    // function to set table sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // set how many rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScoreArray.count
    }
    
    // put score into cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // sort by highest score
        self.highScoreArray.sort { $0.points > $1.points }
        // populate cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath)
        cell.textLabel?.text = highScoreArray[indexPath.row].playerName
        cell.detailTextLabel?.text = String(highScoreArray[indexPath.row].points)
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

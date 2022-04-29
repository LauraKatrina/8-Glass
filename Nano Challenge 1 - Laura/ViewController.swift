//
//  ViewController.swift
//  Nano Challenge 1 - Laura
//
//  Created by Laura Katrina on 27/04/22.
//

import UIKit
import CoreData

class StaticClass {
    static var waterPercentage: String?
}

class ViewController: UIViewController {
    
    
//    @IBOutlet weak var waveView: WaveView?

    @IBOutlet weak var waveView: WaveView!
    
    //    var models = [Reminder]()
        
    @IBOutlet weak var glassLabel: UILabel!
    
    var glassCount = 0
    
    var flag = 0
    var initialheight:Double = 1200
    
    @IBOutlet weak var percentLabel: UILabel!
    
    var percentCount:Double = 0
    
    var items = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDrink()
        print(items)
       
        
        print(self.waveView.frame.height)
        if (glassCount == 0) {
            glassLabel.text = "0 glass"
        }
                
        if (percentCount == 0) {
            percentLabel.text = "0.00%"
        }
        
        print(self.waveView.frame.height)


        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.waveView?.animationStart(direction: .right, speed: 10)
                        }
//        waveView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50).isActive = true
//        waveView.widthAnchor.constraint(equalToConstant: 250).isActive = true
//        waveView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        
//        table.delegate = self
//        table.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let dest = segue.destination as? reminderViewController {
            }
        }
    
    func save() {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: "Drink",
                                   in: managedContext)!
      
      let newtime = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      // 3
      newtime.setValue(percentCount, forKeyPath: "percentage")
      
      // 4
      do {
          try managedContext.save()
//          items.append(newtime)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    func fetchDrink() {
      //1
       guard let appDelegate =
         UIApplication.shared.delegate as? AppDelegate else {
           return
       }
       
       let managedContext =
         appDelegate.persistentContainer.viewContext
       
       //2
       let fetchRequest =
         NSFetchRequest<NSManagedObject>(entityName: "Drink")
       
       //3
       do {
         items = try managedContext.fetch(fetchRequest)
       } catch let error as NSError {
         print("Could not fetch. \(error), \(error.userInfo)")
       }
  }
    
    @IBAction func drinkButtonPress(_ sender: Any) {
        
        glassCount += 1
        if glassCount == 1 {
            glassLabel.text = "1 glass"
        } else if glassCount > 8 {
            glassCount = 0
            glassLabel.text = "\(glassCount) glass"
        } else {
            glassLabel.text = "\(glassCount) glasses"
        }
        
        percentCount += 12.5
        if percentCount == 0 {
            percentCount = 0.00
            percentLabel.text = "0.00%"
        } else if percentCount > 100.0 {
            percentCount = 0
            percentLabel.text = "0.00%"
        } else if percentCount == 100 {
            percentLabel.text = "100%"
        } else {
            percentLabel.text = "\(percentCount)%"
        }

//        if (glassCount == 1) {
//            glassLabel.text = "1 glass"
//        }
        
        flag += 1
        
        if flag <= 8 {
            self.waveView.frame = CGRect(x: 0, y: self.waveView.frame.origin.y, width: self.waveView.frame.width, height: self.waveView.frame.height - 195.0)
            print(self.waveView.frame.height)
    
        }
        else { self.waveView.frame = CGRect(x: 0, y: self.waveView.frame.origin.y, width: self.waveView.frame.width, height: self.waveView.frame.height + 1560)
            print(self.waveView.frame.height)
            flag = 0
        }
        
        StaticClass.waterPercentage = String(percentCount)
        print(percentCount)
      
        save()
        
    }
    
}

//extension ViewController: UITableViewDelegate {
//
//    func tableView( tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//}


//
//    extension ViewController: UITableViewDataSource {
//
//        func numberOfSections(in tableView: UITableView) -> Int {
//            return 1
//        }
//
//        func tableView( tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return.models.count
//    }
//
//        func tableView( tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for indexPath)
//            cell.textLabel?.text = models[indexPath.row]title
//
//            return cell
//
//        }
//
//}
//
//struct Reminder {
//    let title: String
////    let identifier: String
//
//
//}

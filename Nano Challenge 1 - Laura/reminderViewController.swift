//
//  reminderViewController.swift
//  Nano Challenge 1 - Laura
//
//  Created by Laura Katrina on 28/04/22.
//

import UIKit
import CoreData

//struct time {
//    var hour: Int = 0
//    var min: Int = 0
//}

class reminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var items = [NSManagedObject]()
    var drink = [NSManagedObject]()
    //    var items: [time] = [
    //        time (hour: 19, min: 30),
    //        time (hour: 19, min: 30),
    //        time (hour: 19, min: 30),
    //        time (hour: 19, min: 30),
    //        time (hour: 19, min: 30)
    //    ]
    
    @IBOutlet weak var percentSign: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var percentage: Double?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.loadView()
                        
        let content = UNMutableNotificationContent()
        content.title = "Have you drink?"
        content.body = "Remember to drink a glass of water!"
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = 10
        
        // Create the trigger as a repeating event.`
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
    
            if error != nil {
                // Handle any errors.
            }
        }
    
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if error != nil {
                // Handle the error here.
            }
        }
        
        let nib = UINib(nibName: "reminderTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "reminderTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderTableViewCell", for: indexPath) as! reminderTableViewCell
        
        let selectedBg = UIView()
        selectedBg.backgroundColor = .clear
        cell.selectedBackgroundView = selectedBg
        
        let history = items[indexPath.row]
        let time = history.value(forKey: "time")
        //           cell.myLabel.text = AppHelper.getStringDateTime(startDate: history.createDate!, endDate:  history.endDate ?? Date())
        cell.myLabel.text = time as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //           AppHelper.initTempDetailData(sessionData: items[indexPath.row])
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        fetchCoreData()
        fetchHistory()
        fetchDrink()
        
//        DispatchQueue.main.async {
            self.percentage = self.drink.last?.value(forKey: "percentage") as? Double
            
            self.percentSign.text = "\(String(format: "%.1f", self.percentage!))%"
            print(self.percentage!)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func fetchHistory() {
        do {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Gagal mendapatkan data")
        }
        
    }
    
    func fetchCoreData() {
        //1
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Time")
        
        //3
        do {
            items = try managedContext.fetch(fetchRequest)
            print(items)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
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
            drink = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        let vc = durationModalViewController()
        //        vc.parentButton = "work"
        vc.selectionDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
}
extension reminderViewController: DoneButtonDelegate{
    func didTapDone(){
        fetchCoreData()
        fetchDrink()
        fetchHistory()
        
    }
}

//
//  durationModalViewController.swift
//  Nano Challenge 1 - Laura
//
//  Created by Hansel Matthew on 28/04/22.
//

import UIKit
import CoreData

protocol DoneButtonDelegate {
    func didTapDone()
}

class durationModalViewController: UIViewController {
    
    var parentButton:String?
    var times: [NSManagedObject] = []
    var selectionDelegate: DoneButtonDelegate!
    
    func save(time: String) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: "Time",
                                   in: managedContext)!
      
      let newtime = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      // 3
      newtime.setValue(time, forKeyPath: "time")
      newtime.setValue(UUID(), forKeyPath: "id")
      
      // 4
      do {
        try managedContext.save()
        times.append(newtime)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }

    
    
    //Make the button in a code kinda mode
    lazy var doneButton: UIButton = {
        //create button object
        let done = UIButton()
        
        //set done title
        done.setTitle("Done", for: .normal)
        
        //hubungin fungsi yang akan dijalankan ketika done button ditekan (in this case handleCloseAction)
        done.addTarget(self, action: #selector(handleCloseAction), for: .touchUpInside)
        
        //ganti font
        done.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        
        //ganti warna
        done.setTitleColor(.black, for: .normal)
//        let preferredColor = UIColor(named: "blue")?.
        return done
    }()
    
    
    //Make the cancel button
    lazy var cancelButton: UIButton = {
        //create cancel button object
        let cancel = UIButton()
        
        //set title jadi tulisannya cancel
        cancel.setTitle("Cancel", for: .normal)
        
        //hubungin fungsi handleCancelAction ke button, fungsinya dipanggil ketika  cancel ditekan
        cancel.addTarget(self, action: #selector(handleCancelAction), for: .touchUpInside)
        
        //set warna tulisan
        cancel.setTitleColor(.black, for: .normal)
        return cancel
    }()
    
    //Make the timepicker
    lazy var timePicker: UIDatePicker = {
        
        //bikin object time picker
        let picker = UIDatePicker()
        
        //ganti mode time picker jadi time doang, ada beberapa mode (date, date time, countdown timer)
        picker.datePickerMode = .time
        
        //ganti style dari date pickernya (ada beberapa style juga ga hafal)
        picker.preferredDatePickerStyle =  .wheels
        return picker
    }()
    
    lazy var buttonStackView: UIStackView = {
        //button stack view itu jadi button cancel sama done nya itu horizontal stack dikasih spacer ditengahnya
        let spacer = UIView()
        let stckView = UIStackView(arrangedSubviews: [cancelButton,spacer,doneButton])
        stckView.distribution = .fillEqually
        stckView.axis = .horizontal
        return stckView
    }()
    
    lazy var contentStackView: UIStackView = {
        
        //baru stack horizontal tadi digabung sama timepicker dalam sebuah stack vertical
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [buttonStackView,timePicker, spacer])
        stackView.axis = .vertical
        stackView.spacing = 12.0
        return stackView
    }()
    
    lazy var containerView: UIView = {
        //bikin container view ini atur sifat sifat view modalnya
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    //gatau ini apa template ikutin aja for now
    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    // Constants -> buat atur ketinggian modalnya bisa atur tingginya mau berapa, di dismiss kalau dia udah diturunin ke berapa
    let defaultHeight: CGFloat = 350
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    // keep current new height, initial is default height
    var currentContainerHeight: CGFloat = 300
    
    // Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        // tap gesture on dimmed view to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        print(parentButton ?? "Parent Button Empty")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pickerClosed"), object: nil)
    }
    
    //fungsi buat ketika dipencet tombol done
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    //fungsi ketika dipencet tombol cancel
    @objc func handleCancelAction(){
        cancelDismissView()
    }
    
    //abaiin aja ini anggap template buat modal stengah halaman
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    func setupView() {
        view.backgroundColor = .clear
       
    }
    
    func setupConstraints() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set static constraints
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // set container static constraint (trailing & leading)
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // content stackView
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
        
        // Set dynamic constraints
        // First, set container to default height
        // after panning, the height can expand
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        
        // By setting the height to default height, the container will be hide below the bottom anchor view
        // Later, will bring it up by set it to 0
        // set the constant to default height to bring it down again
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
        
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
    // MARK: Present and dismiss animation
    func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    //fungsi yang bakal dipanggil ketika pencet done
    func animateDismissView() {
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in

            //untuk nge format data dari pickernya jadi format jam:menit
            
            //bikin object dateformatter
            let dateFormatter = DateFormatter()
            
            //atur format yang dipengen
            dateFormatter.dateFormat = "HH:mm"
            
            //data date yang udah diselect disimpan di -> self.timePicker.date terus di format sama si date formatter baru dimasukin ke variabel timePicked
            var timePicked = dateFormatter.string(from: self.timePicker.date)
            self.save(time: timePicked)
              
//            coba print datanya pastiin bener,
            print(timePicked)
            //TODO : Add data to core data here
            
            self.selectionDelegate.didTapDone()
            
            // once done, dismiss without animation
            self.dismiss(animated: false, completion: nil)
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    

    //Basically fungsi diatas tapi tanpa ada penyimpanan data ke core data dll jadi cuman dismiss modalnya doang
    func cancelDismissView() {
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false, completion: nil)
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
}


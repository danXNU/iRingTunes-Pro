//
//  RingotonesManagerVC.swift
//  iRingTunes Lite
//
//  Created by Dani Tox on 06/07/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import AVFoundation

class ManagerCell: UITableViewCell {
    
    var urlRingtone : URL?
    var nameRingtone : String?
    
    var durataRingtone : Int?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class RingotnesManagerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var imageView : UIImageView {
        let imageview = UIImageView(frame: view.frame)
        imageview.image = #imageLiteral(resourceName: "dark")
        return imageview
    }
    
    var titleViewLabel : UILabel {
        let frame = CGRect(x: view.center.x, y: 25, width: 250, height: 60)
        let label = UILabel(frame: frame)
        label.center.x = view.center.x
        label.text = "Ringtones Manager"
        label.backgroundColor = UIColor.red
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = UIColor.white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        return label
    }
    
    func returnTableView() -> UITableView {
        let frame = CGRect(x: 0, y: 105, width: view.frame.width, height: view.frame.height - 175)
        let table = UITableView(frame: frame)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.clear
        table.separatorColor = UIColor.clear
        return table
    }
    
//    var tableView : UITableView {
//        let frame = CGRect(x: 0, y: 105, width: view.frame.width, height: view.frame.height - 175)
//        let table = UITableView(frame: frame)
//        table.delegate = self
//        table.dataSource = self
//        table.backgroundColor = UIColor.clear
//        table.separatorColor = UIColor.clear
//        //table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        //table.allowsSelection = false
//        return table
//    }
    var suonerieNomi : [String]?
    
    func returnSuonerieNomi() /*-> [String]*/ {
        let fileManager = FileManager()
        if let offset = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            
            do {
                let suonerie = try fileManager.contentsOfDirectory(atPath: offset)
                print(suonerie)
                suonerieNomi = suonerie
            }
            catch {
                print("Errore: \(error)")
            }
        }
        else {
            print("Errore nel cercare la document directory")
        }
    }
    
    var backButton : UIButton {
        let frame = CGRect(x: 10, y: view.frame.maxY - 60, width: 90, height: 50)
        let button = UIButton(frame: frame)
        button.setTitle("Back", for: .normal)
        button.backgroundColor = UIColor.darkGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
        button.layer.cornerRadius = 10
        button.titleLabel?.textColor = UIColor.white
        button.addTarget(self, action: #selector(dismissManager), for: .touchUpInside)
        return button
    }
    
    @objc func dismissManager() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func returnCountLable() -> UILabel {
        let frame = CGRect(x: view.frame.maxX - 210, y: view.frame.maxY - 60, width: 200, height: 50)
        let label = UILabel(frame: frame)
        label.text = "Ringtones count: \(String(describing: nSuonerie))"
        label.backgroundColor = UIColor.orange
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        
        return label
        
    }
//    var nRingtonesLabel : UILabel {
//        let frame = CGRect(x: view.frame.maxX - 210, y: view.frame.maxY - 60, width: 200, height: 50)
//        let label = UILabel(frame: frame)
//        label.text = "Ringtones count: \(String(describing: nSuonerie))"
//        label.backgroundColor = UIColor.orange
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.textColor = UIColor.white
//        label.layer.masksToBounds = true
//        label.layer.cornerRadius = 10
//        label.textAlignment = .center
//        return label
//    }
    
    var noRingtonesLabel : UILabel {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        let label = UILabel(frame: frame)
        label.center = view.center
        label.backgroundColor = UIColor.gray
        label.text = "No ringtones found"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        return label
    }
    
    var nSuonerie: Int {
        get {
            return suonerieNomi!.count
        }
    }
    
    var tableView : UITableView!
    var nRingtonesLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = returnTableView()
        returnSuonerieNomi()
        
        view.addSubview(imageView)
        view.addSubview(titleViewLabel)
        view.addSubview(tableView)
        view.addSubview(backButton)
        
        
        nRingtonesLabel = returnCountLable()
        view.addSubview(nRingtonesLabel)
        
        
        if suonerieNomi?.count == 0 {
            view.addSubview(noRingtonesLabel)
        }
        
        audioPlayer = AVAudioPlayer()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectedBackgroundView?.backgroundColor = UIColor.clear
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        cell.accessoryView?.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = suonerieNomi![indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.selectionStyle = .none
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suonerieNomi!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    var escButton : UIButton {
        let button = UIButton(frame: view.frame)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }
    
    @objc func dismissView() {
        for subview in self.view.subviews {
            if subview.tag == 100 {
                UIView.animate(withDuration: 0.3, animations: { 
                    subview.alpha = 0
                }, completion: { (isCompleted) in
                    subview.removeFromSuperview()
                })
                
                //subview.removeFromSuperview()
                if isPlaying == true {
                    audioPlayer?.stop()
                    isPlaying = !isPlaying
                }
                
            }
        }
    }
    
    
    
    var blurView : UIView {
        let uiview = UIView(frame: view.frame)
        uiview.backgroundColor = UIColor.clear
        
        let effect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = view.frame
        
//        let frame = CGRect(x: view.center.x, y: view.center.y, width: view.frame.width - 40, height: 350)
//        let buttonsView = UIView(frame: frame)
//        buttonsView.center = view.center
//        buttonsView.layer.masksToBounds = true
//        buttonsView.layer.cornerRadius = 10
//        buttonsView.backgroundColor = UIColor.darkGray
//        
//        
//        
//        var renameRingButton : UIButton {
//            let frame = CGRect(x: buttonsView.frame.width / 2 - 60, y: 30, width: 120, height: 70)
//            let button = UIButton(frame: frame)
//            button.backgroundColor = UIColor.orange
//            button.layer.cornerRadius = 10
//            button.setTitle("Rename", for: .normal)
//            button.titleLabel?.textAlignment = .center
//            button.titleLabel?.textColor = UIColor.white
//            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
//            button.addTarget(self, action: #selector(renameRing), for: .touchUpInside)
//            
//            return button
//        }
//        
//        var removeRingButton : UIButton {
//            let frame = CGRect(x: buttonsView.frame.width / 2 - 60, y: 130, width: 120, height: 70)
//            let button = UIButton(frame: frame)
//            button.backgroundColor = UIColor.red
//            button.layer.cornerRadius = 10
//            button.setTitle("Remove", for: .normal)
//            button.titleLabel?.textAlignment = .center
//            button.titleLabel?.textColor = UIColor.white
//            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
//            button.addTarget(self, action: #selector(removeRing), for: .touchUpInside)
//            
//            return button
//        }
//        
//        var playRingButton : UIButton {
//            let frame = CGRect(x: buttonsView.frame.width / 2 - 60, y: 230, width: 120, height: 70)
//            let button = UIButton(frame: frame)
//            button.backgroundColor = UIColor.blue
//            button.layer.cornerRadius = 10
//            button.setTitle("Play", for: .normal)
//            button.setTitle("Stop", for: .application)
//            button.titleLabel?.textAlignment = .center
//            button.titleLabel?.textColor = UIColor.white
//            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
//            button.addTarget(self, action: #selector(playRingtone), for: .touchUpInside)
//            
//            return button
//        }
//        
//        var shareRingButton : UIButton {
//            let frame = CGRect(x: 10, y: 130, width: 100, height: 70)
//            let button = UIButton(frame: frame)
//            button.backgroundColor = UIColor.green
//            button.layer.cornerRadius = 10
//            button.setTitle("Share", for: .normal)
//            button.titleLabel?.textAlignment = .center
//            button.titleLabel?.textColor = UIColor.white
//            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//            button.addTarget(self, action: #selector(shareRing), for: .touchUpInside)
//            
//            return button
//        }
        
        
        uiview.addSubview(blurView)
        uiview.tag = 100
        
        uiview.addSubview(escButton)
//        uiview.addSubview(buttonsView)
//        buttonsView.alpha = 0
//        
//        buttonsView.addSubview(renameRingButton)
//        buttonsView.addSubview(removeRingButton)
//        buttonsView.addSubview(playRingButton)
//        buttonsView.addSubview(shareRingButton)
        
        return uiview
    }
    
    func buttonsView() -> UIView {
        let frame = CGRect(x: view.center.x, y: view.center.y, width: view.frame.width - 40, height: 350)
        let buttonsView = UIView(frame: frame)
        buttonsView.center = view.center
        buttonsView.layer.masksToBounds = true
        buttonsView.layer.cornerRadius = 17
    
        buttonsView.backgroundColor = UIColor.darkGray
        
        
        
        var renameRingButton : UIButton {
//            let frame = CGRect(x: buttonsView.frame.width / 2 - 60, y: 30, width: 120, height: 70)
            let frame = CGRect(x: buttonsView.frame.width / 2 - 60, y: 130, width: 120, height: 70)
            let button = UIButton(frame: frame)
            button.backgroundColor = UIColor.orange
            button.layer.cornerRadius = 10
            button.setTitle("Rename", for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.textColor = UIColor.white
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
            button.addTarget(self, action: #selector(renameRing), for: .touchUpInside)
            
            return button
        }
        
        var removeRingButton : UIButton {
//            let frame = CGRect(x: buttonsView.frame.width / 2 - 60, y: 130, width: 120, height: 70)
            let frame = CGRect(x: buttonsView.frame.width / 2 - 60, y: 230, width: 120, height: 70)
            let button = UIButton(frame: frame)
            button.backgroundColor = UIColor.red
            button.layer.cornerRadius = 10
            button.setTitle("Remove", for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.textColor = UIColor.white
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
            button.addTarget(self, action: #selector(removeRing), for: .touchUpInside)
            
            return button
        }
        
        var playRingButton : UIButton {
//            let frame = CGRect(x: buttonsView.frame.width / 2 - 60, y: 230, width: 120, height: 70)
            let iPhoneModel = UIDevice.current.modelName
        
            var frame : CGRect?
            
            switch iPhoneModel {
            case "iPhone 4s", "iPhone 5", "iPhone 5c", "iPhone 5s", "iPhone SE":
                frame = CGRect(x: buttonsView.frame.width - 130, y: 30, width: 120, height: 70)
            case "iPhone 6", "iPhone 6s", "iPhone 7":
                frame = CGRect(x: buttonsView.frame.width - 127.5, y: 30, width: 120, height: 70)
            default:
                frame = CGRect(x: buttonsView.frame.width - 150, y: 30, width: 120, height: 70)
            }
            
            
            let button = UIButton(frame: frame!)
            button.backgroundColor = UIColor.blue
            button.layer.cornerRadius = 10
            button.setTitle("Play", for: .normal)
            button.setTitle("Stop", for: .application)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.textColor = UIColor.white
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
            button.addTarget(self, action: #selector(playRingtone(sender:)), for: .touchUpInside)
            
            return button
        }
        
//        func addButton() -> UIButton {
//            let frame = CGRect(x: buttonsView.frame.width - 150, y: 30, width: 120, height: 70)
//            let button = UIButton(frame: frame)
//            button.backgroundColor = UIColor.blue
//            button.layer.cornerRadius = 10
//            button.setTitle("Play", for: .normal)
//            button.setTitle("Stop", for: .focused)
//            button.titleLabel?.textAlignment = .center
//            button.titleLabel?.textColor = UIColor.white
//            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
//            button.addTarget(self, action: #selector(playRingtone(sender:)), for: .touchUpInside)
//            
//            return button
//        }
        
        var shareRingButton : UIButton {
//            let frame = CGRect(x: 10, y: 130, width: 100, height: 70)
            let iPhoneModel = UIDevice.current.modelName
            
            var frame : CGRect?
            
            switch iPhoneModel {
            case "iPhone 4s", "iPhone 5", "iPhone 5c", "iPhone 5s", "iPhone SE":
                frame = CGRect(x: 10, y: 30, width: 120, height: 70)
            case "iPhone 6", "iPhone 6s", "iPhone 7":
                frame = CGRect(x: 7.5, y: 30, width: 120, height: 70)
            default:
                frame = CGRect(x: 30, y: 30, width: 120, height: 70)
            }
            
            
            let button = UIButton(frame: frame!)
            button.backgroundColor = UIColor.green
            button.layer.cornerRadius = 10
            button.setTitle("Share", for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.textColor = UIColor.white
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
            button.addTarget(self, action: #selector(shareRing), for: .touchUpInside)
            
            return button
        }
        
        buttonsView.addSubview(renameRingButton)
        buttonsView.addSubview(removeRingButton)
        
        //let playRingButton = addButton()
        buttonsView.addSubview(playRingButton)
        buttonsView.addSubview(shareRingButton)
        
        return buttonsView
    }
    
    
    @objc func shareRing() {
        let offset = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let urlString = offset.appending("/\(suoneriaSelezionata)")
        let item = URL(fileURLWithPath: urlString)
        
        let activityController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    
    var audioPlayer : AVAudioPlayer?
    var isPlaying = false
    
    @objc func playRingtone(sender: UIButton) {
        let offset = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let urlString = offset.appending("/\(suoneriaSelezionata)")
        let url = URL(fileURLWithPath: urlString)
        
        if isPlaying == false {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                sender.setTitle("Stop", for: .normal)
                isPlaying = !isPlaying
            }
            catch {
                print("audioPlayer Error : \(error)")
            }
        }
        else {
            audioPlayer?.stop()
            sender.setTitle("Play", for: .normal)
            isPlaying = !isPlaying
        }
        
    }
    
    
    @objc func renameRing() {
        print("Rename the ringtone...")
        let alert = UIAlertController(title: "Rename", message: "Write a new name for this ringtone", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.suoneriaSelezionata.replacingOccurrences(of: ".m4r", with: "")
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            if let text = alert.textFields?.first?.text {
                if text != "" {
                    let fileManager = FileManager()
                    
                    let offset = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                    let urlFrom = offset.appending("/\(self.suoneriaSelezionata)")
                    
                    
                    let urlAfter = offset.appending("/\(String(describing: text.appending(".m4r")))")
                    
                    
                    do {
                        print("URLFROM: \(urlFrom)\nURLAFTER: \(urlAfter)")
                        try fileManager.moveItem(atPath: urlFrom, toPath: urlAfter)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.returnSuonerieNomi()
                            self.dismissView()
                        }
                        
                    }
                    catch {
                        print("Error durante la copia: \(error)")
                    }
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func removeRing() {
        
        let alert = UIAlertController(title: "Delete ringtone", message: "Are you sure you want to delete this Ringtone?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            let fileManager = FileManager()
            
            let offset = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let urlString = offset.appending("/\(self.suoneriaSelezionata)")
            
            do {
                print("URL DA CANCELLARE: \(urlString)")
                try fileManager.removeItem(atPath: urlString)
                print("Suoneria cancellata con successo")
                
                DispatchQueue.main.async {
                    self.suonerieNomi?.remove(at: self.indexPath!)
                    self.tableView.deselectRow(at: self.indexPathValue!, animated: true)
                    self.tableView.deleteRows(at: [self.indexPathValue!], with: .fade)
                    self.tableView.reloadData()
                    self.nRingtonesLabel.text = "Ringtones count: \(self.nSuonerie)"
                    self.dismissView()

                }
//                self.suonerieNomi?.remove(at: self.indexPath!)
//                self.tableView.deselectRow(at: self.indexPathValue!, animated: true)
//                self.tableView.deleteRows(at: [self.indexPathValue!], with: .fade)
//                self.tableView.reloadData()
//                self.nRingtonesLabel.text = "Ringtones count: \(self.nSuonerie)"
//                self.dismissView()
            }
                
            catch {
                print("Errore nel cancellare la suoneria: \(error)")
            }
        }))
        present(alert, animated: true)
    }
    
    var suoneriaSelezionata = ""
    var indexPath : Int?
    var indexPathValue : IndexPath?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let buttonsVieww = buttonsView()
        buttonsVieww.tag = 100
        
        view.addSubview(blurView)
        view.addSubview(buttonsVieww)
        buttonsVieww.alpha = 0
        
        UIView.animate(withDuration: 0.45) {
            buttonsVieww.alpha = 1
        }
        
        
        
        self.indexPath = indexPath.row
        suoneriaSelezionata = suonerieNomi![indexPath.row]
        self.indexPathValue = indexPath
        print("SUONERIA SELEZIONATA: \(suoneriaSelezionata)")
        print("AT INDEX PATH: \(String(describing: self.indexPath!))")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let fileManager = FileManager()
            let offset = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            let urlString = offset.appending("/\(suonerieNomi![indexPath.row])")
            print("URL DA ELIMINARE: \(urlString)")
            do {
                try fileManager.removeItem(atPath: urlString)
                //nRingtonesLabel.text = "Ringtones count: \(suonerieNomi!.count)"
                
                
                    
                    
            }
            catch {
                print("Errore: \(error)")
            }
            
            suonerieNomi?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
           
            
            NotificationCenter.default.post(name: NSNotification.Name("updateCount"), object: nil)
            
        }
    }
    
}


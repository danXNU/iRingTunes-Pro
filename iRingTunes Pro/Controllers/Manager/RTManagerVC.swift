//
//  RTManagerVC.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 15/06/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit


class RTManagerVC: UIViewController {
    
    let model = RTGenericModel()
    var files : [String] = [String]()
    
    lazy var backButton : UIBarButtonItem = {
        let b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(dismissVC))
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managerView.tableView.delegate = self
        managerView.tableView.dataSource = self
        
        navigationItem.setRightBarButton(backButton, animated: true)
        navigationItem.title = "Manager"
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadFiles()
        reloadTableView()
    }
    

    let managerView = RTManagerView()
    override func loadView() {
        super.loadView()
        self.view = managerView
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    private func reloadFiles() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        
        files = model.getFiles(from: path, withFilter: { (file) -> Bool in
            //print("FILENAME: \(file)\t\t\t\t\t\t\t\t\t\t->\t\tHas Suffix: \((file.hasSuffix(".m4r")) ? true : false)")
            return (file.hasSuffix(".m4r")) ? true : false
        })
        files.forEach({print($0)})
        reloadTableView()
    }

    private func reloadTableView() {
        managerView.tableView.reloadData()
    }
}

extension RTManagerVC : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.6
        cell.textLabel?.text = files[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RTManagerSongInfoVC()
        vc.songName = files[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

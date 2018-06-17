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
//        let b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(dismissVC))
        let b = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissVC))
        return b
    }()
    
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        managerView.tableView.delegate = self
        managerView.tableView.dataSource = self
        
        navigationItem.setRightBarButton(backButton, animated: true)
        navigationItem.title = "Manager"
        
        refreshControl.addTarget(self, action: #selector(reloadFiles), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            managerView.tableView.refreshControl = refreshControl
        } else {
            managerView.tableView.addSubview(refreshControl)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadFiles()
    }
    

    let managerView = RTManagerView()
    override func loadView() {
        super.loadView()
        self.view = managerView
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func reloadFiles() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        files = model.getFiles(from: path, withFilter: { (file) -> Bool in
            return (file.hasSuffix(".m4r")) ? true : false
        })
        reloadTableView()
        refreshControl.endRefreshing()
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
        let cell = RTRingtonesListCell()
        cell.backgroundColor = .clear
//        cell.textLabel?.textColor = .white
//        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
//        cell.textLabel?.adjustsFontSizeToFitWidth = false
//        cell.textLabel?.minimumScaleFactor = 0.6
//        cell.textLabel?.text = files[indexPath.row]
//        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.songLabel.text = files[indexPath.row]
        //TODO: AGGIUNGERE IL LABEL DENTRO LA CUSTOM VIEW CON IL NOME DEL FILE
        
//        let v = TouchView()
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.backgroundColor = UIColor.darkGray.darker(by: 20)
//        v.layer.cornerRadius = 10
//        cell.addSubview(v)
//        v.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 15).isActive = true
//        v.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -15).isActive = true
//        v.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -7).isActive = true
//        v.topAnchor.constraint(equalTo: cell.topAnchor, constant: 7).isActive = true
//
//        v.layer.shadowColor = UIColor.gray.cgColor
//        v.layer.shadowOffset = CGSize(width: 0, height: 0)
//        v.layer.shadowOpacity = 1.0
//        v.layer.shadowRadius = 10
//        v.layer.masksToBounds = false
//
//
//        let songLabel = UILabel()
//        songLabel.translatesAutoresizingMaskIntoConstraints = false
//        songLabel.font = UIFont.boldSystemFont(ofSize: 17)
//        songLabel.text = files[indexPath.row]
//        songLabel.textColor = .white
//        v.addSubview(songLabel)
//        songLabel.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
//        songLabel.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 10).isActive = true
//        songLabel.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -10).isActive = true
//        songLabel.heightAnchor.constraint(equalTo: v.heightAnchor, multiplier: 0.35).isActive = true
        
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let path = model.getPath(fromName: files[indexPath.row])
            files.remove(at: indexPath.row)
            model.removeItem(atPath: path)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}

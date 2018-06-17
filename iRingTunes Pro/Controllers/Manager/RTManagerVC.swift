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
        cell.selectionStyle = .none
        cell.songLabel.text = files[indexPath.row]
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

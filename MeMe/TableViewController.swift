//
//  TableViewController.swift
//  MeMe
//
//  Created by Seungwook Jeong on 2017. 1. 25..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

private let tableViewIdentifier = "tableViewReuseIdentifier"

class TableViewController: UITableViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // memes Array Count
        return 1
    }
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // memes Array Count
        return appDelegate.memes.count
    }
 
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewIdentifier, for: indexPath)
        let memeItem = appDelegate.memes[indexPath.row]
        cell.imageView?.image = memeItem.memedImage
        cell.textLabel?.text = "\(memeItem.topText) ... \(memeItem.bottomText)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.memedImage = appDelegate.memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }
}

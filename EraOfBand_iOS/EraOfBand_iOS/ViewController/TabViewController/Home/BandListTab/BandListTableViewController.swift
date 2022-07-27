//
//  BandListTableViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/26.
//

import UIKit

class BandListTableViewController: UIViewController {

    @IBOutlet weak var bandTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bandTableView.delegate = self
        bandTableView.dataSource = self
        
    }
    
}

extension BandListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BandListTableViewCell", for: indexPath) as! BandListTableViewCell
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }
    

}

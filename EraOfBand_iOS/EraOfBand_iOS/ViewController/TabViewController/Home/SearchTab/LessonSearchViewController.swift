//
//  LessonSearchViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/08/04.
//

import UIKit

class LessonSearchViewController: UIViewController {

    @IBOutlet weak var lessonResultTableView: UITableView!
    
    var lessonResult: [lessonInfo] = []
    
    @objc func lessonReload(notification: NSNotification) {
        
        print("lesson reload Data")
        
        guard let getResult: [lessonInfo] = notification.userInfo?["lesson"] as? [lessonInfo] else { return }
        
        self.lessonResult = getResult
        
        self.lessonResultTableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lessonResultTableView.dataSource = self
        lessonResultTableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(lessonReload), name: .notifName, object: nil)
    }
    

}

extension LessonSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BandLessonSearchTableViewCell", for: indexPath) as! BandLessonSearchTableViewCell
        
        if let url = URL(string: lessonResult[indexPath.item].lessonImgUrl) {
            cell.repreImageView.load(url: url)
            cell.repreImageView.contentMode = .scaleAspectFill
        } else {
            cell.repreImageView.backgroundColor = .gray
        }
        
        cell.titleLabel.text = lessonResult[indexPath.item].lessonTitle
        
        cell.regionLabel.text = lessonResult[indexPath.item].lessonRegion
        
        let capacity = lessonResult[indexPath.item].capacity
        let memberCount = lessonResult[indexPath.item].memberCount
        cell.memberLabel.text = "\(memberCount) / \(capacity)"
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lessonVC = self.storyboard?.instantiateViewController(withIdentifier: "LessonRecruit") as! LessonRecruitViewController
        
        let lessonIdx = lessonResult[indexPath.item].lessonIdx
        
        GetLessonInfoService.getLessonInfo(lessonIdx){ [self]
            (isSuccess, response) in
            if isSuccess{
                lessonVC.lessonInfo = response.result
                lessonVC.lessonIdx = lessonIdx

                self.navigationController?.pushViewController(lessonVC, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    
}

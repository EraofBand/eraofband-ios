//
//  LessonViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/11.
//

import UIKit
import Alamofire

class LessonViewController: UIViewController {

    var lessonList: [GetUserLesson]?
    @IBOutlet weak var lessonTableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getLessonList(){
        let header : HTTPHeaders = [
            "x-access-token": appDelegate.jwt,
            "Content-Type": "application/json"]
        
        AF.request(appDelegate.baseUrl + "/users/info/my-page/" + String(appDelegate.userIdx!),
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseDecodable(of: UserDataModel.self){ response in
            
            let responseData = response.value
            self.lessonList = (responseData?.result.getUserLesson)!
            
            self.lessonTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lessonTableView.separatorStyle = .none

        lessonTableView.delegate = self
        lessonTableView.dataSource = self
        
        getLessonList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLessonList()
    }

}

extension LessonViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BandListTableViewCell", for: indexPath) as! BandListTableViewCell
        
        let lessoninfo = lessonList![indexPath.row]
        
        let url = URL(string: lessoninfo.lessonImgUrl)!
        cell.tableImageView.load(url: url)
        cell.tableImageView.contentMode = .scaleAspectFill
        cell.tableTitleLabel.text = lessoninfo.lessonTitle
        cell.tableRegionLabel.text = lessoninfo.lessonRegion
        cell.memberNumLabel.text = String(lessoninfo.memberCount) + " / " + String(lessoninfo.capacity)
        cell.tableIntroLabel.text = lessoninfo.lessonIntroduction
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let lessonRecruitVC = self.storyboard?.instantiateViewController(withIdentifier: "LessonRecruitViewController") as? LessonRecruitViewController else { return }
        
        GetLessonInfoService.getLessonInfo((lessonList?[indexPath.row].lessonIdx)!){ [self]
            (isSuccess, response) in
            if isSuccess{
                lessonRecruitVC.lessonInfo = response.result
                lessonRecruitVC.lessonIdx = (lessonList?[indexPath.row].lessonIdx)!

                self.navigationController?.pushViewController(lessonRecruitVC, animated: true)
            }
        }
    }
}

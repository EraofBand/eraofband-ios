//
//  WishLessonViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/23.
//

import UIKit
import Alamofire

class WishLessonViewController: UIViewController {
    
    @IBOutlet weak var wishLessonTableView: UITableView!
    
    var lessonList: [lessonInfo] = []
    
    func getWishLessonList() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var url = appDelegate.baseUrl + "/lessons/info/likes"
        print("url: \(url)")
        
        url = url.encodeUrl()!
        let header: HTTPHeaders = ["x-access-token": appDelegate.jwt,
                                   "Content-Type": "application/json"]
        
        let request = AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header)
        
        request.responseDecodable(of: LessonListData.self) { [self] response in
            switch response.result {
            case .success(let lessonListData):
                lessonList = lessonListData.result
                print(lessonList)
            case .failure(let err):
                print(err)
            }
        }
        
        wishLessonTableView.delegate = self
        wishLessonTableView.dataSource = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getWishLessonList()
        
    }
    

}

extension WishLessonViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BandListTableViewCell", for: indexPath) as! BandListTableViewCell
        
        cell.backgroundColor = .clear
        
        let lessoninfo = lessonList[indexPath.item]
        let url = URL(string: lessoninfo.lessonImgUrl)!
        cell.tableImageView.load(url: url)
        cell.tableImageView.contentMode = .scaleAspectFill
        cell.tableRegionLabel.text = lessoninfo.lessonRegion
        cell.tableTitleLabel.text = lessoninfo.lessonTitle
        cell.tableIntroLabel.text = lessoninfo.lessonIntroduction
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let lessonRecruitVC = self.storyboard?.instantiateViewController(withIdentifier: "LessonRecruitViewController") as? LessonRecruitViewController else { return }
        
        GetLessonInfoService.getLessonInfo(lessonList[indexPath.row].lessonIdx){ [self]
            (isSuccess, response) in
            if isSuccess{
                lessonRecruitVC.lessonInfo = response.result
                lessonRecruitVC.lessonIdx = lessonList[indexPath.row].lessonIdx

                self.navigationController?.pushViewController(lessonRecruitVC, animated: true)
            }
        }
    }
    
}

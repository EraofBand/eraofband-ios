//
//  OnboardingViewController.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/03.
//

import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var onboardingModel = OnboardingModel.fetchMember()
    
    var currentPage = 0
    
    /*스킵 버튼 눌렀을 때 로그인 뷰로 이동*/
    @IBAction func skipBtnTapped(_ sender: Any) {
        
        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}
        loginVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        self.present(loginVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    
        collectionView.isPagingEnabled = true

    }
    
}

extension OnboardingViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        
        let onboarding = onboardingModel[indexPath.item]
        cell.onboardingModel = onboarding
                
        /*page control 설정*/
        /*
        cell.pageControl.pageIndicatorTintColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        cell.pageControl.currentPageIndicatorTintColor = UIColor(red: 0.094, green: 0.392, blue: 0.992, alpha: 1)
        cell.pageControl.currentPage = indexPath.row*/
        
        return cell
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 414)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
    
}

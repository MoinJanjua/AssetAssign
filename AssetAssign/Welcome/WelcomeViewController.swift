//
//  WelcomeViewController.swift
//  AssetAssign
//
//  Created by Moin Janjua on 19/08/2024.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var curveView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        curveTopCorners(of: curveView, radius: 35)
        imageView.layer.cornerRadius = 20
    }
    func curveTopCorners(of view: UIView, radius: CGFloat) {
           let path = UIBezierPath(roundedRect: view.bounds,
                                   byRoundingCorners: [.topLeft, .topRight],
                                   cornerRadii: CGSize(width: radius, height: radius))
           
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           view.layer.mask = mask
       }

    @IBAction func LetsStartButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
        // self.tabBarController?.selectedIndex = 3
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
}

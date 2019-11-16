//
//  ViewControllerExtension.swift
//  MemeApp
//
//  Created by Abdulla Hasanov on 11/16/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addPlusAction() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(openMemeEditor))
    }
    
    @objc func openMemeEditor() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editorViewController = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        editorViewController.modalPresentationStyle = .fullScreen
        editorViewController.presentingVC = self
        self.present(editorViewController, animated:true, completion:nil)
    }
    
    @objc func saveCompleted() {
        print("Save completed")
    }
    
    func pushDetailController(_ image: UIImage) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! MemeDetail
        detailViewController.memeImagePre = image
        if let navigator = self.navigationController {
            navigator.pushViewController(detailViewController, animated: true)
        }
    }

}

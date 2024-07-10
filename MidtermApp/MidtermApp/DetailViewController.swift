//
//  DetailViewController.swift
//  MidtermApp
//
//  Created by Keval on 8/3/24.
//

import UIKit
import QuartzCore
class DetailViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var imagetask: UIImageView!
    
    var task: TaskModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let task = task else { return }
        
        labelTitle.text = task.title
        labelDesc.text = task.desc
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        labelDate.text = formatter.string(from: task.dueDate)
        labelStatus.text = task.status
        if let imageData = task.imgData {
            imagetask.image = UIImage(data: imageData)
        } else {
            imagetask.image = nil
        }
    }
}


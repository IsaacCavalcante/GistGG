//
//  GistViewController.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 01/04/21.
//

import UIKit
import SDWebImage

class GistViewController: UIViewController {
    
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var filesLabel: UILabel!
    @IBOutlet weak var commitsLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var filesTableView: UITableView!
    
    var gistUrl: String?
    private var gistManager = GistManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        filesTableView.delegate = self
        filesTableView.dataSource = self
        gistManager.delegate = self
        
        loadGist(url: gistUrl!)
        
        ownerImageView.layer.cornerRadius = ownerImageView.frame.size.width/2
        ownerImageView.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    private func loadGist(url: String) {
        let id = String(url.split(separator: "/").last!)
        gistManager.fetchRequest(withId: id)
        filesTableView.reloadData()
    }
}

//MARK: - GistManagerDelegate
extension GistViewController: GistManagerDelegate {
    func updateGistInformation(_ gistManager: GistManager) {
        self.gistManager = gistManager
        
        
        let numberOfFiles = gistManager.getNumberOfFiles()
        
        let textBubleImage = NSTextAttachment()
        textBubleImage.image = UIImage(systemName: "filemenu.and.selection")?.withTintColor(.white)

        let filesString = NSMutableAttributedString()
        filesString.append(NSAttributedString(attachment: textBubleImage))
        filesString.append(NSAttributedString(string: " \(numberOfFiles)"))
        
        
        
        filesLabel?.attributedText = filesString
        
        if let ownerName = gistManager.getGistOwnerName(){
            navigationItem.title = ownerName
        }
        if let numberOfComents = gistManager.getNumberOfComents(){
            let commentImage = NSTextAttachment()
            commentImage.image = UIImage(systemName: "text.bubble.fill")?.withTintColor(.white)

            let comentsString = NSMutableAttributedString()
            comentsString.append(NSAttributedString(attachment: commentImage))
            comentsString.append(NSAttributedString(string: " \(numberOfComents)"))
            commentsLabel?.attributedText = comentsString
        }
        if let numberOfCommits = gistManager.getNumberOfCommits(){
            let commitImage = NSTextAttachment()
            commitImage.image = UIImage(systemName: "person.3")?.withTintColor(.white)

            let commitsString = NSMutableAttributedString()
            commitsString.append(NSAttributedString(attachment: commitImage))
            commitsString.append(NSAttributedString(string: " \(numberOfCommits)"))
            
            commitsLabel?.attributedText = commitsString
        }
        if let ownerImageUrl = gistManager.getGistUrlImage(){
            ownerImageView?.sd_setImage(with: URL(string: ownerImageUrl))
        }
        
    }
    
    func didFailWithError(error: GistManagerError) {
        print(error)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension GistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.fileCell, for: indexPath)
        cell.textLabel?.text = "TEXTO"
//        cell.textLabel?.text = "\(observablesElements[indexPath.row].identifier!): \(confidence)"

        return cell
    }


}

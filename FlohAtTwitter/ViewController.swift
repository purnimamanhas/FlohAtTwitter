//
//  ViewController.swift
//  FlohAtTwitter
//
//  Created by Purnima on 15/04/17.
//  Copyright © 2017 Purnima. All rights reserved.

import UIKit
import TwitterKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tweetRecordTableView: UITableView!
    var updatedCount: Int = 0
    var tweet = [Tweet]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Floh@Twitter"

        //DataManager.sharedInstance.deleteTweets()
        self.getUpdatedDataFromTwitter()
        if let records = DataManager.sharedInstance.fetchTweets() {
            
            self.tweet = records
        }
        
        self.tweetRecordTableView.separatorColor = UIColor(red: 33/255.0, green: 150/255.0, blue: 243/255.0, alpha: 1)
        self.automaticallyAdjustsScrollViewInsets = false

        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        self.refreshControl.addTarget(self, action: #selector(ViewController.refreshTicketStatus), for: UIControlEvents.valueChanged)
        self.tweetRecordTableView?.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tweetRecordTableView.reloadData()
       
    }
    
    
    func refreshTicketStatus() {
        counter = 0
        DataManager.sharedInstance.deleteTweets()
        if self.refreshControl.isRefreshing {

        let client = TWTRAPIClient()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json?q=%40FlohNetwork"
        let params = ["": ""]
        var clientError : NSError?
        var text: String!
        var name: String!
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                if let status = json["statuses"] as? [AnyObject] {
                    for eachStatus in status {
                        text = eachStatus["text"] as! String!
                        if let retweet = eachStatus["user"] as? [String: AnyObject]{
                            let image = retweet["profile_image_url_https"] as! String!
                            name = retweet["name"] as! String!
                            DataManager.sharedInstance.saveTweet(name, username: name, message: text, image: image)
                            
                        } else {
                            
                        }
                    }
                }
                self.updatedCount = counter
                if let records = DataManager.sharedInstance.fetchTweets() {
                    
                    self.tweet = records
                }
                self.tweetRecordTableView.reloadData()
                self.refreshControl.endRefreshing()
                

            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
      }
    }

    
    func getUpdatedDataFromTwitter() {
        
        let client = TWTRAPIClient()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json?q=%40FlohNetwork"
        let params = ["": ""]
        var clientError : NSError?
        var text: String!
        var name: String!
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                if let status = json["statuses"] as? [AnyObject] {
                    for eachStatus in status {
                        text = eachStatus["text"] as! String!
                        if let retweet = eachStatus["user"] as? [String: AnyObject]{
                            let image = retweet["profile_image_url_https"] as! String!
                            name = retweet["name"] as! String!
                            DataManager.sharedInstance.saveTweet(name, username: name, message: text, image: image)
                        } else {
                            print("Error")
                        }
                    }
                }
                self.updatedCount = counter
                if let records = DataManager.sharedInstance.fetchTweets() {
                    
                    self.tweet = records
                }
                self.tweetRecordTableView.reloadData()

            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.updatedCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsCell", for: indexPath) as! TweetsTableViewCell
        
        if self.tweet.count >= counter {
        
        let singleTweet = self.tweet[indexPath.row]
        
        cell.username.text = singleTweet.userName
        cell.tweetMessage.text = singleTweet.message
            
        let url = URL(string: singleTweet.avatar!)
            
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    cell.avatar.image = UIImage(data: data)
                    }
                }
            }
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red: 64/255, green: 153/255, blue: 255/255, alpha: 0.1)
    }
    
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


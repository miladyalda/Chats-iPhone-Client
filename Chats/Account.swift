import UIKit

class Account: NSObject {
    private let AccountAccessTokenKey = "AccountAccessTokenKey"
    dynamic var accessToken: String! {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(AccountAccessTokenKey)
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: AccountAccessTokenKey)
        }
    }
    var chats = [Chat]()
    dynamic var email: String!
    var user: User!
    dynamic var users = [User]()

    func continueAsGuest() {
        let minute: NSTimeInterval = 60, hour = minute * 60, day = hour * 24
        chats = [
            Chat(user: User(ID: 1, username: "mattdipasquale", firstName: "Matt", lastName: "Di Pasquale"), lastMessageText: "Thatnks for checking out Chats! :-)", lastMessageSentDate: NSDate()),
            Chat(user: User(ID: 2, username: "samihah", firstName: "Angel", lastName: "Rao"), lastMessageText: "6 sounds good :-)", lastMessageSentDate: NSDate(timeIntervalSinceNow: -minute)),
            Chat(user: User(ID: 3, username: "walterstephanie", firstName: "Valentine", lastName: "Sanchez"), lastMessageText: "Haha", lastMessageSentDate: NSDate(timeIntervalSinceNow: -minute*12)),
            Chat(user: User(ID: 23, username: "benlu", firstName: "Ben", lastName: "Lu"), lastMessageText: "I have no profile picture.", lastMessageSentDate: NSDate(timeIntervalSinceNow: -hour*5)),
            Chat(user: User(ID: 4, username: "wake_gs", firstName: "Aghbalu", lastName: "Amghar"), lastMessageText: "Damn", lastMessageSentDate: NSDate(timeIntervalSinceNow: -hour*13)),
            Chat(user: User(ID: 22, username: "doitlive", firstName: "中文 日本語", lastName: "한국인"), lastMessageText: "I have no profile picture or extended ASCII initials.", lastMessageSentDate: NSDate(timeIntervalSinceNow: -hour*24)),
            Chat(user: User(ID: 5, username: "kfriedson", firstName: "Candice", lastName: "Meunier"), lastMessageText: "I can't wait to see you! ❤️", lastMessageSentDate: NSDate(timeIntervalSinceNow: -hour*34)),
            Chat(user: User(ID: 6, username: "mmorits", firstName: "Ferdynand", lastName: "Kaźmierczak"), lastMessageText: "http://youtu.be/UZb2NOHPA2A", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*2-1)),
            Chat(user: User(ID: 7, username: "krystalfister", firstName: "Lauren", lastName: "Cooper"), lastMessageText: "Thinking of you...", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*3)),
            Chat(user: User(ID: 8, username: "christianramsey", firstName: "Bradley", lastName: "Simpson"), lastMessageText: "👍", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*4)),
            Chat(user: User(ID: 9, username: "curiousonaut", firstName: "Clotilde", lastName: "Thomas"), lastMessageText: "Sounds good!", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*5)),
            Chat(user: User(ID: 10, username: "acoops_", firstName: "Tania", lastName: "Caramitru"), lastMessageText: "Cool. Thanks!", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*6)),
            Chat(user: User(ID: 11, username: "tpatteri", firstName: "Ileana", lastName: "Mazilu"), lastMessageText: "Hey, what are you up to?", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*7)),
            Chat(user: User(ID: 12, username: "giuliusa", firstName: "Asja", lastName: "Zuhrić"), lastMessageText: "Drinks tonight?", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*8)),
            Chat(user: User(ID: 13, username: "liang", firstName: "Sarah", lastName: "Lam"), lastMessageText: "Are you going to Blues on the Green tonight?", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*9)),
            Chat(user: User(ID: 14, username: "dhoot_amit", firstName: "Ishan", lastName: "Sarin"), lastMessageText: "Thanks for open sourcing Chats.", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*10)),
            Chat(user: User(ID: 15, username: "leezlee", firstName: "Stella", lastName: "Vosper"), lastMessageText: "Those who dance are considered insane by those who can't hear the music.", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
            Chat(user: User(ID: 16, username: "elenadissi", firstName: "Georgeta", lastName: "Mihăileanu"), lastMessageText: "Hey, what are you up to?", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
            Chat(user: User(ID: 17, username: "juanadearte", firstName: "Alice", lastName: "Adams"), lastMessageText: "Hey, want to hang out tonight?", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
            Chat(user: User(ID: 18, username: "teleject", firstName: "Gerard", lastName: "Gómez"), lastMessageText: "Haha. Hell yeah! No problem, bro!", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
            Chat(user: User(ID: 19, username: "oksanafrewer", firstName: "Melinda", lastName: "Osváth"), lastMessageText: "I am excellent!!! I was thinking recently that you are a very inspirational person.", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
            Chat(user: User(ID: 20, username: "cynthiasavard", firstName: "Saanvi", lastName: "Sarin"), lastMessageText: "See you soon!", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
            Chat(user: User(ID: 21, username: "stushona", firstName: "Jade", lastName: "Roger"), lastMessageText: "😊", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11))
        ]

        for chat in chats {
            users.append(chat.user)
        }

        email = "guest@example.com"
        user = User(ID: 0, username: "guest", firstName: "Guest", lastName: "User")
        accessToken = "guest_access_token"
    }

    func getMe() -> NSURLSessionDataTask {
        let request = NSMutableURLRequest(URL: api.URLWithPath("/me"))
        request.setValue("Bearer "+accessToken, forHTTPHeaderField: "Authorization")
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if response != nil {
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                let collection = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! Dictionary<String, AnyObject>

                dispatch_async(dispatch_get_main_queue(), {
                    if statusCode == 200 {
                        let name = collection!["name"] as! Dictionary<String, String>
                        self.user.firstName = name["first"]!
                        self.user.lastName = name["last"]!
                        self.email = collection!["email"]! as! String
                    }
                })
            }
        })
        dataTask.resume()
        return dataTask
    }

    func changeEmail(editEmailTableViewController: EditEmailTableViewController, newEmail: String) -> NSURLSessionDataTask {
        let loadingViewController = LoadingViewController(title: "Loading")
        editEmailTableViewController.presentViewController(loadingViewController, animated: true, completion: nil)

        let request = api.formRequest("POST", "/email", ["email": newEmail])
        request.setValue("Bearer "+accessToken, forHTTPHeaderField: "Authorization")
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if response != nil {
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                var enterCodeViewController: EnterCodeViewController!
                var dictionary: Dictionary<String, String>?

                if statusCode == 200 {
                    enterCodeViewController = EnterCodeViewController(email: newEmail)
                    enterCodeViewController.method = .Email
                } else { // error
                    dictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))) as! Dictionary<String, String>?
                }

                dispatch_async(dispatch_get_main_queue(), {
                    editEmailTableViewController.dismissViewControllerAnimated(true, completion: {
                        if (enterCodeViewController != nil) {
                            enterCodeViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: enterCodeViewController, action: "cancelAction")
                            let navigationController = UINavigationController(rootViewController: enterCodeViewController)
                            let rootNavigationController = editEmailTableViewController.navigationController!
                            rootNavigationController.presentViewController(navigationController, animated: true, completion: {
                                rootNavigationController.popViewControllerAnimated(false)
                            })
                        } else { // error
                            let alert = UIAlertController(dictionary: dictionary, error: error, handler: nil)
                            editEmailTableViewController.presentViewController(alert, animated: true, completion: nil)
                        }
                    })
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    editEmailTableViewController.dismissViewControllerAnimated(true, completion: {
                        let alert = UIAlertController(dictionary: nil, error: error, handler: nil)
                        editEmailTableViewController.presentViewController(alert, animated: true, completion: nil)
                    })
                })
            }
        })
        dataTask.resume()
        return dataTask
    }

    func logOut(settingsTableViewController: SettingsTableViewController) -> NSURLSessionDataTask {
        let loadingViewController = LoadingViewController(title: "Logging Out")
        settingsTableViewController.presentViewController(loadingViewController, animated: true, completion: nil)

        let request = NSMutableURLRequest(URL: api.URLWithPath("/sessions"))
        request.HTTPMethod = "DELETE"
        request.setValue("Bearer "+accessToken, forHTTPHeaderField: "Authorization")
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if response != nil {
                let statusCode = (response as! NSHTTPURLResponse).statusCode

                dispatch_async(dispatch_get_main_queue(), {
                    settingsTableViewController.dismissViewControllerAnimated(true, completion: {
                        if statusCode == 200 {
                            self.reset()
                        } else {
                            let dictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))) as! Dictionary<String, String>?
                            let alert = UIAlertController(dictionary: dictionary, error: error, handler: nil)
                            settingsTableViewController.presentViewController(alert, animated: true, completion: nil)
                        }
                    })
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    settingsTableViewController.dismissViewControllerAnimated(true, completion: {
                        let alert = UIAlertController(dictionary: nil, error: error, handler: nil)
                        settingsTableViewController.presentViewController(alert, animated: true, completion: nil)
                    })
                })
            }
        })
        dataTask.resume()
        return dataTask
    }

    func deleteAccount(settingsTableViewController: SettingsTableViewController) -> NSURLSessionDataTask {
        let loadingViewController = LoadingViewController(title: "Deleting")
        settingsTableViewController.presentViewController(loadingViewController, animated: true, completion: nil)

        let request = NSMutableURLRequest(URL: api.URLWithPath("/me"))
        request.HTTPMethod = "DELETE"
        request.setValue("Bearer "+accessToken, forHTTPHeaderField: "Authorization")
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if response != nil {
                let statusCode = (response as! NSHTTPURLResponse).statusCode

                dispatch_async(dispatch_get_main_queue(), {
                    settingsTableViewController.dismissViewControllerAnimated(true, completion: {
                        switch statusCode {
                        case 200:
                            self.reset()
                        default:
                            let dictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))) as! Dictionary<String, String>?
                            let alert = UIAlertController(dictionary: dictionary, error: error, handler: nil)
                            settingsTableViewController.presentViewController(alert, animated: true, completion: nil)
                        }
                    })
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    settingsTableViewController.dismissViewControllerAnimated(true, completion: {
                        let alert = UIAlertController(dictionary: nil, error: error, handler: nil)
                        settingsTableViewController.presentViewController(alert, animated: true, completion: nil)
                    })
                })
            }
        })
        dataTask.resume()
        return dataTask
    }

    func setUserWithAccessToken(accessToken: String, firstName: String, lastName: String) {
        let userIDString = accessToken.substringToIndex(accessToken.endIndex.advancedBy(-33))
        let userID = UInt(Int(userIDString)!)
        user = User(ID: userID, username: "", firstName: firstName, lastName: lastName)
    }

    private func reset() {
        accessToken = nil
        chats = []
        email = nil
        user = nil
        users = []
    }

    func logOutGuest() {
        reset()
    }
}

import UIKit

enum EnterCodeMethod : Int {
    case SignUp
    case LogIn
    case Email
}

class EnterCodeViewController: UIViewController, CodeInputViewDelegate {
    var email: String
    var method = EnterCodeMethod.SignUp

    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
        title = "Verify Email"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        let noticeLabel = UILabel(frame: CGRectZero)
        noticeLabel.numberOfLines = 2
        noticeLabel.text = "Enter the code sent to\n\(email)"
        noticeLabel.textAlignment = .Center
        view.addSubview(noticeLabel)
        noticeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: noticeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: noticeLabel, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: noticeLabel, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: -20)
        ])

        let codeInputView = CodeInputView(frame: CGRect(x: (view.frame.width-215)/2, y: 142, width: 215, height: 60))
        codeInputView.delegate = self
        codeInputView.tag = 17
        view.addSubview(codeInputView)
        codeInputView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: codeInputView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: codeInputView, attribute: .Top, relatedBy: .Equal, toItem: noticeLabel, attribute: .Bottom, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: codeInputView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 215),
            NSLayoutConstraint(item: codeInputView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 60)
        ])
        codeInputView.becomeFirstResponder()
    }

    // MARK: - CodeInputViewDelegate

    func codeInputView(codeInputView: CodeInputView, didFinishWithCode code: String) {
        func HTTPMethod() -> String {
            switch method {
            case .SignUp, .LogIn: return "POST"
            case .Email: return "PUT"
            }
        }

        func path() -> String {
            switch method {
            case .SignUp: return "/users"
            case .LogIn: return "/sessions"
            case .Email: return "/email"
            }
        }

        func statusCodeSuccess() -> Int {
            switch method {
            case .SignUp: return 201
            case .LogIn, .Email: return 200
            }
        }

        func clearCodeInputView(_: UIAlertAction) {
            (view.viewWithTag(17) as! CodeInputView).clear()
        }

        let loadingViewController = LoadingViewController(title: method == .SignUp ? "Signing Up" : "Loging In")
        presentViewController(loadingViewController, animated: true, completion: nil)

        let request = api.formRequest(HTTPMethod(), path(), ["code": code, "email": email])
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if response != nil {
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                let dictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))) as! Dictionary<String, String>?

                dispatch_async(dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: {
                        if statusCode == statusCodeSuccess() {
                            account.email = self.email

                            switch self.method {
                            case .SignUp, .LogIn:
                                let accessToken = dictionary!["access_token"]!
                                account.setUserWithAccessToken(accessToken, firstName: "", lastName: "")
                                account.accessToken = accessToken
                            case .Email:
                                self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
                            }
                        } else {
                            let alert = UIAlertController(dictionary: dictionary, error: error, handler: clearCodeInputView)
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    })
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: {
                        let alert = UIAlertController(dictionary: nil, error: error, handler: nil)
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                })
            }
        })
        dataTask.resume()
    }

    // MARK: - Actions

    func cancelAction() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

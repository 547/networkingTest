//
//  ViewController.swift
//  networkingTest
//
//  Created by seven on 2018/3/29.
//  Copyright © 2018年 seven. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ApiCenter.getHomeData().finish { (response) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



class Networking {
    static var `default` = Networking()
    
}
extension Networking {
    func request(_ request:Request) -> () {
        log(request)
        let response = createResponse(request)
        request.complete?(response)
        
        
        
    }
}
fileprivate extension Networking {
    func log(_ request:Request) -> () {
        print("url:\(request.api?.url ?? "")\n")
    }
    func createResponse(_ request:Request) -> Networking.Response {
        let response = Networking.Response.init()
        response.request = request
        response.code = 0
        response.data = nil
        response.message = "success"
        print("url:\(response.request?.api?.url ?? "")\n")
        return response
    }
}
extension Networking {
    typealias RequestComplete = (_ response:Networking.Response) -> ()
    typealias ProgressBlock = (_ progress:Progress?) -> ()
    class Request {
        fileprivate var api:Api? = nil
        fileprivate var complete:RequestComplete?
        fileprivate var progress:ProgressBlock?
    }
    class Response {
        var data:[String:Any]? = nil
        var code:Int = 0
        var message:String? = nil
        var request:Request? = nil
    }
    struct UploadFile {
        var data:Data
        var name:String
        var type:FileType
        
        enum FileType:String {
            case jpg = "image/jpeg"
            case png = "image/png"
            case bmp = "image/bmp"
            
            var suffix: String {
                switch self {
                case .jpg: return ".jpg"
                case .png: return ".png"
                case .bmp: return ".bmp"
                }
            }
        }
    }
    
}

protocol Api {
    var api:String {get set}
    var parameters:[String:Any]?{ get set }
    var mothod:RequestMothod {get set}
}
extension Api {
    var url:String{
        return api
    }
}

enum RequestMothod {
    case get
    case post
    case upload
}

extension Networking.Request {
    static func get(_ api:Api) -> Networking.Request {
        
        let request = Networking.Request.init()
        request.api = api
        request.api?.mothod = .get
        return request
    }
    static func post(_ api:Api) -> Networking.Request {
        let request = Networking.Request.init()
        request.api = api
        request.api?.mothod = .post
        return request
    }
    static func upload(_ api:Api) -> Networking.Request {
        let request = Networking.Request.init()
        request.api = api
        request.api?.mothod = .upload
        return request
    }
    
}
extension Networking.Request {
    func finish(_ complete:@escaping Networking.RequestComplete) -> Networking.Request {
        self.complete = complete
        Networking.default.request(self)
        return self
    }
    func progress(_ complete:@escaping Networking.ProgressBlock) -> Networking.Request {
        self.progress = complete
        return self
    }
}







class ApiCenter: Api {
    var api: String
    
    var parameters: [String : Any]?
    
    var mothod: RequestMothod
    
    init(api:String, parameters:[String:Any]? = nil, mothod:RequestMothod = .get) {
        self.api = api
        self.parameters = parameters
        self.mothod = mothod
    }
    
}
fileprivate extension ApiCenter {
    static func get(api:String, parameters:[String:Any]? = nil, mothod:RequestMothod = .get) -> Networking.Request {
        let request = Networking.Request.get(ApiCenter.init(api: api, parameters: parameters, mothod: mothod))
        return request
    }
}

extension ApiCenter {
    static func getHomeData() -> Networking.Request {
        return ApiCenter.get(api: "test/test_1", parameters: nil, mothod: .get)
    }
}


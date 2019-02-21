//
//  Location.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/31.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

var callbackfun:String = ""
extension MainViewController: CLLocationManagerDelegate{
    
    func getLocationJSON() -> String{
        var result = self.locationModel.toJSONString()!
        result = result.replacingOccurrences(of: "\"", with: "\\\"")
        print(result)
        return result
    }

    //打开定位
    func loadLocation(){
        //定位方式
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //iOS8.0以上才可以使用
//        if(Double(UIDevice.current.systemVersion)! >= 8.0 ){
            //始终允许访问位置信息
            locationManager.requestAlwaysAuthorization()
            //使用应用程序期间允许访问位置数据
            locationManager.requestWhenInUseAuthorization()
//        }
        //开启定位
        locationManager.startUpdatingLocation()
    }

    //获取定位信息
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //取得locations数组的最后一个
        let location:CLLocation = locations[locations.count-1]
        currLocation = locations.last!
        //判断是否为空
        if(location.horizontalAccuracy > 0){
            let dimension = String(format: "%.6f", location.coordinate.latitude)
            let longitude = String(format: "%.6f", location.coordinate.longitude)
            print("经度:\(longitude)")
            print("纬度:\(dimension)")
            locationModel.dimension = dimension
            locationModel.longitude = longitude
            LonLatToCity()
            //停止定位
            locationManager.stopUpdatingLocation()
            
        }

    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    //出现错误
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        locationManager.stopUpdatingLocation()
        print(error ?? "default value")
    }
    
    ///将经纬度转换为城市名
    func LonLatToCity() {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currLocation) { (placemark, error) -> Void in
            print(error)
            if(error == nil){
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
                //城市
                let city: String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                let citynameStr = city.replacingOccurrences(of:"市", with: "")
                self.locationModel.cityName = citynameStr
                //国家
//                let country: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Country") as! NSString
                //国家编码
                let CountryCode: String = (mark.addressDictionary! as NSDictionary).value(forKey: "CountryCode") as! String
                self.locationModel.GBCode = CountryCode
                //回调
                ExecWinJS(JSFun: callbackfun + "(\"" + self.getLocationJSON()  + "\")")
                //街道位置
//                let FormattedAddressLines: NSString = ((mark.addressDictionary! as NSDictionary).value(forKey: "FormattedAddressLines") as AnyObject).firstObject as! NSString
                //具体位置
//                let Name: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Name") as! NSString
                //省
//                var State: String = (mark.addressDictionary! as NSDictionary).value(forKey: "State") as! String
                //区
//                let SubLocality: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "SubLocality") as! NSString
                //如果需要去掉“市”和“省”字眼
//                State = State.replacingOccurrences(of: "省", with: "")
            }
            else{
                print(error ?? "LonLatToCity error")
            }
        }
    }
}


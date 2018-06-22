//
//  ViewController.swift
//  DownSampleDemo
//
//  Created by GuanZhenwei on 2018/6/16.
//  Copyright © 2018年 GuanZhenwei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // a. 一个最大的疑问：是否图片的内存在系统里面有占用的部分，而不只是xcode里面所显示的那些！ 需要根据wwdc session复现其步骤，明确这些细节！
        
        // Notice: with the malloc stack button selected,
        // memory shown in the xcode will rise 4-5MB.(raw demo)
        
        // 1.first, we got 11.6MB~12.xMB raw. iphone8 11.4
        // 7.5MB raw, iphone6 12beta2
        
        // benchmarking...
        
        // -----png test begin-----
        
        // tested in iphone8 11.4, 55.3MB  really bad! pic nearly 44MB
        // 1440*2560*4*3 = 44MB!
        // ARGB_888 just this! with png format.
        // imageIO 42MB, malloc nano 3MB, -- by instruments
        
        // tested in iphone6 12beta2, 50MB, 50-7.5=42.5MB ～= 44MB
        // instruments: imageIO 42.2MB
//        image1.image = UIImage(named: "000.png")
//        image2.image = UIImage(named: "001.png")
//        image3.image = UIImage(named: "002.png")
        
        
        print(":]")
        
        // tested in iphone8 11.4, 12.3MB much better!
        // 44*564/2560*564/2560 = 2.13MB  564*564
        //
        // not added simply, maybe created by the UIView?
        // 42MB ImageIO (peaking?) + 3.70MB CG raster data, just fake xcode!
        // by instruments
        
        // tested in iphone6 12beta2, 50.2MB, 50.2-7.5=42.7MB ～= 44MB
        // seems useless in saving memory.
//        image1.image = ImgHelper.originImage(UIImage(named: "000.png")!, scaleTo: CGSize(width:564, height:564))
//        image2.image = ImgHelper.originImage(UIImage(named: "001.png")!, scaleTo: CGSize(width:564, height:564))
//        image3.image = ImgHelper.originImage(UIImage(named: "002.png")!, scaleTo: CGSize(width:564, height:564))
        

        // tested in iphone8 11.4, 12.0MB, lowest cost! but similar as the above
        //  with instruments we can get really 2.1M!!!
        
        // tested in iphone6 12beta2, 7.8MB, lowest cost!
        // only added 300KB  564*564 不对，改成了2560也才占用这么点，猜测应该是在系统里面，没显示在这里！
        //  with instruments we can get really 2.13M!!!
        //  MMAP的显示不出来？我更倾向于认为这个是xcode的bug或者功能不完善。
        let url1 = Bundle.main.url(forResource: "000", withExtension: "png")
        let img = downsample(imageAt: url1!, to: CGSize(width:564, height:564), scale: 1.0)
        image1.image = img

        let url2 = Bundle.main.url(forResource: "001", withExtension: "png")
        let img1 = downsample(imageAt: url2!, to: CGSize(width:564, height:564), scale: 1.0)
        image2.image = img1

        let url3 = Bundle.main.url(forResource: "002", withExtension: "png")
        let img2 = downsample(imageAt: url3!, to: CGSize(width:564, height:564), scale: 1.0)
        image3.image = img2
        
        print(":]")
        
        // -----png test end-----
        
        // -----jpg test begin-----
        
        // tested in iphone8 11.4, 29.1MB
        // 29.1-11.6 ~= 18MB??? how we got this?
        
        // ImageIO 14MB, IOKit 11MB, malloc NANO 3mb,  malloc large 2mb
        // by instruments
        
        // tested in iphone6 12beta2, 34.6MB
        // 34.6-7.5~= 24.1MB??? how we got this? RGB_565?? nearly half compared with png.
        // 24.8MB, IOSurface 10.8MB, ImageIO 14MB. by Instruments
        // Maybe different pics.
//        image1.image = UIImage(named: "000.jpg")
//        image2.image = UIImage(named: "001.jpg")
//        image3.image = UIImage(named: "002.jpg")
        
        print(":]")
        
        // tested in iphone8 11.4, 13.2MB much better! so it works before iOS12?
        // 42 ImageIO (peaking ???) , CG raster data 3.7 -- by instruments
        // need to snapshot launched immediately!
        
        // tested in iphone6 12beta2, 50.0MB
        // fucking worse! so we really can not do this in iOS12!
        // cgRastdata 3.7M, malloc large 40MB! 44MB total.
//        image1.image = ImgHelper.originImage(UIImage(named: "000.png")!, scaleTo: CGSize(width:564, height:564))
//        image2.image = ImgHelper.originImage(UIImage(named: "001.png")!, scaleTo: CGSize(width:564, height:564))
//        image3.image = ImgHelper.originImage(UIImage(named: "002.png")!, scaleTo: CGSize(width:564, height:564))
        
        
        // tested in iphone8 11.4, 12.1MB, lowest cost! but similar as the above
        // 2.14MB added, CG raster data, by instruments.
        
        // tested in iphone6 12beta2, 7.8MB, lowest cost!
        // only added 300KB ???
        // 2.1MB added, CG raster data, by instruments.
//        let url1 = Bundle.main.url(forResource: "000", withExtension: "png")
//        let img = downsample(imageAt: url1!, to: CGSize(width:564, height:564), scale: 1.0)
//        image1.image = img
//
//        let url2 = Bundle.main.url(forResource: "001", withExtension: "png")
//        let img1 = downsample(imageAt: url2!, to: CGSize(width:564, height:564), scale: 1.0)
//        image2.image = img1
//
//        let url3 = Bundle.main.url(forResource: "002", withExtension: "png")
//        let img2 = downsample(imageAt: url3!, to: CGSize(width:564, height:564), scale: 1.0)
//        image3.image = img2
        
        print(":]")
        
        // -----jpg test end-----
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage
    {
        let sourceOpt = [kCGImageSourceShouldCache : false] as CFDictionary
        // 其他场景可以用createwithdata (data并未decode,所占内存没那么大),
        let source = CGImageSourceCreateWithURL(imageURL as CFURL, sourceOpt)!
        
        let maxDimension = max(pointSize.width, pointSize.height) * scale
        let downsampleOpt = [kCGImageSourceCreateThumbnailFromImageAlways : true,
                             kCGImageSourceShouldCacheImmediately : true ,
                             kCGImageSourceCreateThumbnailWithTransform : true,
                             kCGImageSourceThumbnailMaxPixelSize : maxDimension] as CFDictionary
        let downsampleImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOpt)!
        return UIImage(cgImage: downsampleImage)
    }
}


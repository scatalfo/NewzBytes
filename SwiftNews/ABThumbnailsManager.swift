import UIKit
import AVFoundation

class ABThumbnailsManager: NSObject {
    
    var thumbnailViews = [UIImageView]()

    private func addImagesToView(images: [UIImage], view: UIView){
        
        self.thumbnailViews.removeAll()
        var xPos: CGFloat = 0.0
        var width: CGFloat = 0.0
        for image in images{
            DispatchQueue.main.async {
                if xPos + view.frame.size.height < view.frame.width{
                    width = view.frame.size.height
                }else{
                    width = view.frame.size.width - xPos
                }
                
                let imageView = UIImageView(image: image)
                imageView.alpha = 0
                imageView.contentMode = UIViewContentMode.scaleAspectFill
                imageView.clipsToBounds = true
                imageView.frame = CGRect(x: xPos,
                                         y: 0.0,
                                         width: width,
                                         height: view.frame.size.height)
                self.thumbnailViews.append(imageView)
                
                
                view.addSubview(imageView)
                UIView.animate(withDuration: 0.2, animations: {() -> Void in
                    imageView.alpha = 1.0
                })
                view.sendSubview(toBack: imageView)
                xPos = xPos + view.frame.size.height
            }
        }
    }
    
    private func thumbnailCount(inViewFrame: CGRect) -> Int{
        let num = Double(inViewFrame.size.width) / Double(inViewFrame.size.height)
        return Int(ceil(num))
    }
    
    func updateThumbnails(view: UIView, videoURL: URL, duration: Float64) -> [UIImageView]{
        
        for view in self.thumbnailViews{
            DispatchQueue.main.async {
                view.removeFromSuperview()
            }
        }
        
        var thumbnails = [UIImage]()
        var offset: Float64 = 0
        DispatchQueue.main.async {
            let imagesCount = self.thumbnailCount(inViewFrame: view.frame)
            
            for i in 0..<imagesCount{
                let thumbnail = ABVideoHelper.thumbnailFromVideo(videoUrl: videoURL,
                                                                 time: CMTimeMake(Int64(offset), 1))
                offset = Float64(i) * (duration / Float64(imagesCount))
                thumbnails.append(thumbnail)
            }
            self.addImagesToView(images: thumbnails, view: view)
        }
        return self.thumbnailViews
    }
}

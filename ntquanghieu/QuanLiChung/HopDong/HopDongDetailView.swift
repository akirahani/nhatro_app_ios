
import SwiftUI

struct HopDongDetailView: View {
    let hopDongItem : HopDong
    
    var body: some View {
        Text(hopDongItem.chuphong!)
        Text(hopDongItem.idhd!)
        Text(hopDongItem.khach!)
        Text(hopDongItem.ngaybatdau!)
        Text(hopDongItem.ngayketthuc!)
        Text(hopDongItem.phong!)
        Text(hopDongItem.trangthai!
        )
    }
}

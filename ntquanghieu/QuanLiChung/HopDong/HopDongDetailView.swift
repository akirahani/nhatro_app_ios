
import SwiftUI

struct HopDongDetailView: View {
    
    let hopDongItem : HopDong
    @State var hopDongModel = [HopDong]()
    @State var khachModel = [KhachDetail]()
    @State public var idKhachThue: String = ""

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isSideBarOpened = false
    @State private var goHome = false
    @State var tabIndex = 0
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image("back")
            }
        }
    }
    // Api thành viên hợp đồng
    
    func apiThanhVien() async {
        
        guard let urlTVD = URL(string: "http://192.168.1.183/nhatro/admin/api/hop-dong/khach-detail.php") else {
            print("Invalid URL")
            return
        }
        
        let body: [String: Any] = [
            "khach": (hopDongItem.khach ?? "")!
        ]
        
        print(body)
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body,options: .fragmentsAllowed)
        var request = URLRequest(url: urlTVD)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
                
        do {
            let (data, _) = try await URLSession.shared.data(from: urlTVD)
            khachModel = try JSONDecoder().decode([KhachDetail].self, from: data) // <-- here
            print("ok")
        } catch {
            print(error)  // <-- important
        }
    }
    
    
    struct RoundedCorners: View {
        var color: Color = .blue
        var tl: CGFloat = 0.0
        var tr: CGFloat = 0.0
        var bl: CGFloat = 0.0
        var br: CGFloat = 0.0
        
        var body: some View {
            GeometryReader { geometry in
                Path { path in
                    
                    let w = geometry.size.width
                    let h = geometry.size.height

                    // Make sure we do not exceed the size of the rectangle
                    let tr = min(min(self.tr, h/2), w/2)
                    let tl = min(min(self.tl, h/2), w/2)
                    let bl = min(min(self.bl, h/2), w/2)
                    let br = min(min(self.br, h/2), w/2)
                    
                    path.move(to: CGPoint(x: w / 2.0, y: 0))
                    path.addLine(to: CGPoint(x: w - tr, y: 0))
                    path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                    path.addLine(to: CGPoint(x: w, y: h - br))
                    path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                    path.addLine(to: CGPoint(x: bl, y: h))
                    path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                    path.addLine(to: CGPoint(x: 0, y: tl))
                    path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                    path.closeSubpath()
                }
                .fill(self.color)
            }
        }
    }
    
var body: some View {
    ZStack{
        NavigationView{
            VStack{
                
                // tieu de dich vu
                ZStack{
                    HStack{
                        Image("hopdong")
                        Text("Quản lí hợp đồng").textCase(.uppercase).foregroundColor(Color(hex: "#354B9C"))
                            .font(.system(size: 18, weight: .bold))
                    }.padding(.top, 13)
                        .padding(.leading, 23)
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: 59,
                            alignment: .topLeading
                        )
                }.background(Color.white)
                    .zIndex(2)
                    
                ZStack{
                    VStack{
                        //
                        if(hopDongItem.trangthai == "1"){
                            HStack{
                                Text("Chi tiết hợp đồng")
                                    .padding(.leading,36)
                                    .padding(.trailing,36)
                                    .padding(.top,8)
                                    .padding(.bottom,8)
                                    .foregroundColor(Color.white)
                                    .background(RoundedCorners(color: Color(hex: "B71616"), tl: 10, tr: 10, bl: 0, br: 0))
                                Spacer()
                            }.padding(.top,25)
                        }else{
                            HStack{
                                Text("Chi tiết hợp đồng")
                                    .padding(.leading,36)
                                    .padding(.trailing,36)
                                    .padding(.top,8)
                                    .padding(.bottom,8)
                                    .foregroundColor(Color.white)
                                    .background(RoundedCorners(color: Color(hex: "1338BD"), tl: 10, tr: 10, bl: 0, br: 0))
                                Spacer()
                            }.padding(.top,18)
                        }
                            
                        // thong tin danh sach hop dong
                        ScrollView{
                            VStack {
                                Text("Hợp đồng số \(hopDongItem.idhd!) - phòng \(hopDongItem.phong!)")
                                    .padding(.top,20)
                                    .padding(.bottom
                                             ,20).textCase(.uppercase)
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                
                                VStack{
                                    Text("Người đại diện")
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                        .padding(.top,10)
                                        .padding(.leading,10)
                                        .font(.system(size: 16, weight: .bold, design: .default))
                                    VStack{
                                        
                                        // Tên chủ phòng
                                        ZStack{
                                            HStack{
                                                Text("Họ và tên: ").font(.system(size: 16, weight: .bold))
                                                    .padding(.leading, 9)
                                                Text(hopDongItem.chuphong!).font(.system(size: 16))
                                                    .padding(.trailing, 9)
                                                Spacer()
                                            }.padding(.top, 15)
                                                .frame(maxWidth: .infinity)
                                                .padding(.bottom,15)
                                                .background(Color.white)
                                                .clipShape(RoundedRectangle(cornerRadius:10))
                                        }.padding(.trailing, 14)
                                            .padding(.leading, 14)
                                            .padding(.bottom, 6)
                                            .padding(.top, 6)
                                        // điện thoại chủ phòng
                                        ZStack{
                                            HStack(){
                                                Text("Số điện thoại: ").font(.system(size: 16, weight: .bold))
                                                    .padding(.leading, 9)
                                                Text(hopDongItem.dienthoaichuphong ?? "").font(.system(size: 16))
                                                    .padding(.trailing, 9)
                                                Spacer()
                                            }.padding(.top, 15)
                                                .frame(maxWidth: .infinity)
                                                .padding(.bottom, 15)
                                                .background(Color.white)
                                                .clipShape(RoundedRectangle(cornerRadius:10))
                                        }.padding(.trailing, 14)
                                            .padding(.leading, 14)
                                            .padding(.bottom, 16)
                                            .padding(.top, 6)
                                        
                                        
                                        // Thành viên phòng
                                        List(khachModel) { model in
                                            VStack{
                                                ZStack{
                                                    HStack{
                                                        Text("Họ và tên: ").font(.system(size: 16, weight: .bold))
                                                            .padding(.leading, 9)
                                                        Text(model.fullname!).font(.system(size: 16))
                                                            .padding(.trailing, 9)
                                                        Spacer()
                                                    }.padding(.top, 15)
                                                        .frame(maxWidth: .infinity)
                                                        .padding(.bottom,15)
                                                        .background(Color.white)
                                                        .clipShape(RoundedRectangle(cornerRadius:10))
                                                }.padding(.trailing, 14)
                                                    .padding(.leading, 14)
                                                    .padding(.bottom, 6)
                                                    .padding(.top, 6)
                                                // điện thoại chủ phòng
                                                ZStack{
                                                    HStack(){
                                                        Text("Số điện thoại: ").font(.system(size: 16, weight: .bold))
                                                            .padding(.leading, 9)
                                                        Text(model.dienthoai ?? "").font(.system(size: 16))
                                                            .padding(.trailing, 9)
                                                        Spacer()
                                                    }.padding(.top, 15)
                                                        .frame(maxWidth: .infinity)
                                                        .padding(.bottom, 15)
                                                        .background(Color.white)
                                                        .clipShape(RoundedRectangle(cornerRadius:10))
                                                }.padding(.trailing, 14)
                                                    .padding(.leading, 14)
                                                    .padding(.bottom, 16)
                                                    .padding(.top, 6)
                                                
                                            }
                                        }
                                    }.frame(maxWidth: .infinity)
                                }.background(Color(hex: "F3F6FF"))
                                    .clipShape(RoundedRectangle(cornerRadius:10))
                                    .padding(.leading,10)
                                    .padding(.trailing,10)
                                
                                Text(hopDongItem.khach!)
                                Text(hopDongItem.ngaybatdau!)
                                Text(hopDongItem.ngayketthuc!)
                            }
                            .task {
                                await apiThanhVien()
                            }
                            .frame(maxWidth: .infinity)
                            . background(Color.white)
                        }
                        .padding(.top, -10)
                    }
                }
                Spacer()
                    
            }.background(Color(hex: "#F2F1F6"))
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    btnBack
                }
                ToolbarItem(placement: .principal) {
                       NavigationLink( destination: HomeView())
                       {
                           Image("logohome")
                       }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("bar") .onTapGesture {
                        isSideBarOpened.toggle()
                    }
                }
            }.navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarBackButtonHidden(true)
     
        MenuSlideView(isSidebarVisible: $isSideBarOpened)

    }
        
   }
}

struct KhachDetail: Codable, Identifiable {
    var id = UUID()
    let idkhach: String?
    let fullname: String?
    let dienthoai: String?
    
    enum CodingKeys: String, CodingKey {
        case idkhach = "id"
        case fullname = "fullname"
        case dienthoai = "dienthoai"
    }
}

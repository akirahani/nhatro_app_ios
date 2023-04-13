import SwiftUI

struct ThuKhacView: View {
    @State var thuKhacModel = [ThuKhac]()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isSideBarOpened = false
    @State private var goHome = false
    @State var tabIndex = 0
    
    @State var timeThuKhac = Date()
    @State var getMonthThuKhac = ""
    @State var getYearThuKhac: Int = 0

    
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
        
//        let body: [String: Any] = [
//        ]
    
        
        
//        let jsonData = try? JSONSerialization.data(withJSONObject: body,options: .fragmentsAllowed)
//        var request = URLRequest(url: urlTVD)
        
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
                
        do {
            let (data, _) = try await URLSession.shared.data(from: urlTVD)
//            khachModel = try JSONDecoder().decode([KhachDetail].self, from: data) // <-- here
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
    //
    var body: some View {
        ZStack{
            NavigationView{
                VStack{
                    
                    // tieu de dich vu
                    ZStack{
                        HStack{
                            Image("thukhacpage")
                            Text("Thu khác").textCase(.uppercase).foregroundColor(Color(hex: "#354B9C"))
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                            NavigationLink(destination: ThuKhacAddView()){
                                Image("add")
                                    .padding(.trailing,10)
                                    .padding(.bottom,10)
                            }
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
                            // thong tin danh sach hop dong
                            ScrollView{
                                VStack {
                                    DatePicker("",  selection: $timeThuKhac,
                                               in: ...Date(),
                                               displayedComponents: [.date])
                                        .clipShape(RoundedRectangle(cornerRadius:10))
                                        .id(timeThuKhac)
                                        .foregroundColor(Color.white)
                                        .padding(.leading,14)
                                        .padding(.trailing,14)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .background(Color(hex: "1338BD"))
                                        .onChange(of: timeThuKhac) { newDate in
                                            let monthTK = Calendar.current.dateComponents([.month], from: newDate).month!
                                            let yearTK = Calendar.current.dateComponents([.year], from: newDate).year!
                                            
                                            var thangTK = ""
                                
                                            if(monthTK < 10){
                                                thangTK = "0\(monthTK)"
                                            }else{
                                                thangTK = "\(monthTK)"
                                            }
                                            
                                            getYearThuKhac = yearTK
                                            getMonthThuKhac = thangTK
                                            print(getYearThuKhac)
                                            print(getMonthThuKhac)
                                        }
                                    
                                    // tiêu đề
                                    HStack{
                                        Text("Tiền").font(.system(size: 16, weight: .bold))
                                        Spacer()
                                        Text("Lý do").font(.system(size: 16, weight: .bold))
                                        Spacer()
                                        Text("Phòng").font(.system(size: 16, weight: .bold))
                                        Spacer()
                                        Text("Chi tiết").font(.system(size: 16, weight: .bold))
                                    }.padding(.top, 16)
                                        .padding(.leading, 25)
                                        .padding(.trailing, 15)
                                        .padding(.bottom, 4)
                                    // nội dung
                                }
                                .padding(.top,25)
                                .frame(maxWidth: .infinity)
                                . background(Color.white)
                            }
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
struct ThuKhac : Codable, Identifiable{
    var id = UUID()
    let idthukhac: String?
    let tienformat: String?
    let tien: String?
    let lydo: String?
    let ngay: String?
    let gio: String?
    let phong: String?
    
    enum CodingKeys: String, CodingKey {
        case idthukhac = "id"
        case tienformat = "tienformat"
        case tien = "tien"
        case lydo = "lydo"
        case ngay = "ngay"
        case gio = "gio"
        case phong = "phong"
    }
    
    
}
struct ThuKhacView_Previews: PreviewProvider {
    static var previews: some View {
        ThuKhacView()
    }
}

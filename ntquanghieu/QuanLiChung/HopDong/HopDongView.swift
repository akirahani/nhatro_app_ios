//
//  HopDongView.swift
//  ntquanghieu
//
//  Created by admin on 29/03/2023.
//

import SwiftUI

struct HopDongView: View {
    @State var hopDongModel = [HopDong]()

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isSideBarOpened = false
    @State var tabIndex = 0
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image("back")
            }
        }
    }
    
    func coHieuLuc() async {
          guard let url = URL(string: "http://192.168.1.183/nhatro/admin/api/hop-dong/con-hieu-luc.php")
//          guard let url = URL(string: "http://192.168.0.104/nhatro/admin/api/hop-dong/con-hieu-luc.php")
        
        else {
              print("Invalid URL")
              return
          }
          do {
              let (data, _) = try await URLSession.shared.data(from: url)
              hopDongModel = try JSONDecoder().decode([HopDong].self, from: data) // <-- here
          } catch {
              print(error)  // <-- important
          }
      }
    
    func hetHieuLuc() async {
          guard let url = URL(string: "http://192.168.1.183/nhatro/admin/api/hop-dong/het-hieu-luc.php") else {
              print("Invalid URL")
              return
          }
          do {
              let (data, _) = try await URLSession.shared.data(from: url)
              hopDongModel = try JSONDecoder().decode([HopDong].self, from: data) // <-- here
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
                // thong tin danh sach hop dong
                GeometryReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                            Section {
                                TabView(selection: $tabIndex) {
                                    VStack {
                                        ScrollView{
                                            // Tiêu đề HĐ còn hiệu lực
                                            VStack{
                                                HStack{
                                                    Text("Tên khách").font(.system(size: 16, weight: .bold))
                                                    Spacer()
                                                    Text("Hợp đồng").font(.system(size: 16, weight: .bold))
                                                    Spacer()
                                                    Text("Tác vụ").font(.system(size: 16, weight: .bold))
                                                }.padding(.top, 16)
                                                    .padding(.leading, 25)
                                                    .padding(.trailing, 25)
                                                    .padding(.bottom, 16)
                                            }.background(Color.white)
                                                .padding(.top,10)
                                            
                                            // nội dung HĐ Còn HL
                                            VStack{
                                                ForEach(hopDongModel) { model in
                                                    HStack(spacing: 10){
                                                        Text(model.chuphong ?? "").padding(.leading, 5)
                                                        Spacer()
                                                        Text(model.idhd ?? "").padding(.leading, 5)
                                                        Spacer()
                                                        HStack{
                                                            NavigationLink(destination: HopDongDetailView(hopDongItem :model)){
                                                                Image("edit")
                                                            }
                                                            
                                                        }.padding(.trailing, 5)
                                                    }
                                                    .frame(width: .none, height: 44)
                                                    .background(Color(hex: "E8EDFF"))
                                                    .clipShape(RoundedRectangle(cornerRadius:10))
                                                    .padding(.top, 4)
                                                    .padding(.leading, 10)
                                                    .padding(.trailing, 10)
                                                    .padding(.bottom, 4)
                                                }
                                            }.task {
                                                await coHieuLuc()
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(.white)
                                    .tag(0)
                                    
                                    VStack {
                                        ScrollView{
                                            // Tiêu đề HĐ còn hiệu lực
                                            VStack{
                                                HStack{
                                                    Text("Tên khách").font(.system(size: 16, weight: .bold))
                                                    Spacer()
                                                    Text("Hợp đồng").font(.system(size: 16, weight: .bold))
                                                    Spacer()
                                                    Text("Tác vụ").font(.system(size: 16, weight: .bold))
                                                }.padding(.top, 16)
                                                    .padding(.leading, 25)
                                                    .padding(.trailing, 25)
                                                    .padding(.bottom, 16)
                                            }.background(Color.white)
                                                .padding(.top,10)
                                            
                                            // nội dung HĐ Còn HL
                                            VStack{
                                                ForEach(hopDongModel) { model in
                                                    HStack(spacing: 10){
                                                        Text(model.chuphong ?? "").padding(.leading, 5)
                                                            .frame(alignment: .leading)
                                                        
                                                        Spacer()
                                                        Text(model.idhd ?? "").padding(.leading, 5)                       .frame(alignment: .center)

                                                        Spacer()
                                                        HStack{
                                                            NavigationLink(destination: HopDongDetailView(hopDongItem :model)){
                                                                Image("detail-het-hieu-luc")
                                                            }
                                                            
                                                        }.padding(.trailing, 5)                .frame(alignment: .trailing)

                                                    }
                                                    .frame(width: .none, height: 44)
                                                    .background(Color(hex: "E9E9E9"))
                                                    .clipShape(RoundedRectangle(cornerRadius:10))
                                                    .padding(.top, 4)
                                                    .padding(.leading, 10)
                                                    .padding(.trailing, 10)
                                                    .padding(.bottom, 4)
                                                }
                                            }.task {
                                                await hetHieuLuc()
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(.white)
                                    .tag(1)
                                
                                }
                                .tabViewStyle(.page(indexDisplayMode: .never))
                                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
                            } header: {
                                HStack {
                                    Button {
                                        withAnimation {
                                            tabIndex = 0
                                        }
                                    } label: {
                                        Text("Còn hiệu lực")
                                            .padding(.leading,36)
                                            .padding(.trailing,36)
                                            .padding(.top,8)
                                            .padding(.bottom,8)
                                            .foregroundColor(Color.white)
                                            .background(RoundedCorners(color: Color(hex: "1338BD"), tl: 10, tr: 10, bl: 0, br: 0))
                                    }
                                    
                  
                            
                                    Button {
                                        withAnimation {
                                            tabIndex = 1
                                        }
                                    } label: {
                                        Text("Hết hiệu lực")
                                            .padding(.leading,36)
                                            .padding(.trailing,36)
                                            .padding(.top,8)
                                            .padding(.bottom,8)
                                            .foregroundColor(Color.white)
                                            .background(RoundedCorners(color: Color(hex: "1338BD"), tl: 10, tr: 10, bl: 0, br: 0))
                                    }
     

                                }
                                .padding(.top, 20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.regularMaterial)
                            }                        }
                    }
                }
                .zIndex(1)
                Spacer()
            }.background(Color(hex: "#F2F1F6"))
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    btnBack
                }
                ToolbarItem(placement: .principal) {
                    Image("logohome")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("bar") .onTapGesture {
                        isSideBarOpened.toggle()
                    }
                }
            }.navigationBarBackButtonHidden(true)
            MenuSlideView(isSidebarVisible: $isSideBarOpened)

        }
    }
}

struct HopDong: Codable, Identifiable {
    var id = UUID()
    let idhd : String?
    let phong : String?
    let chuphong: String?
    let ngaybatdau : String?
    let ngayketthuc: String?
    let trangthai : String?
    let khach : String?
    
    enum CodingKeys: String, CodingKey {
        case idhd = "id"
        case phong = "phong"
        case chuphong = "chuphong"
        case ngaybatdau = "ngaybatdau"
        case ngayketthuc = "ngayketthuc"
        case trangthai = "trangthai"
        case khach = "khach"        
    }
}

struct HopDongView_Previews: PreviewProvider {
    static var previews: some View {
        HopDongView()
    }
}

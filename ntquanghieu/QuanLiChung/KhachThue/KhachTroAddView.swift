//
//  KhachTroAddView.swift
//  ntquanghieu
//
//  Created by Phạm Khải on 04/04/2023.
//

import SwiftUI

struct KhachTroAddView: View {
    @State var khachModel = [Khach]()

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isSideBarOpened = false
    
    @State var tenKhach: String = ""
    @State var nhomTuoi: String = ""
    @State var dienThoai: String = ""
    @State var diaChi: String = ""
    @State var canCuoc: String = ""
    @State var ngayCap: String = ""
    @State var quocTich: String = ""
    @State var ngaySinh: String = ""
    @State var gioiTinh: String = ""

    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        isSideBarOpened = false
    }) {
            HStack {
                Image("back")
            }
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
    
    func addKhach() async throws {

       guard let urlAddTB =  URL(string:"http://192.168.1.183/nhatro/admin/api/khach/add.php")
//       guard let urlAddTB =  URL(string:"http://192.168.0.104/nhatro/admin/api/khach/add.php")
        
        else { return }

        let body: [String: Any] = [
            "fullname": tenKhach,
            "dienthoai": dienThoai,
            "diachi": diaChi,
            "cancuoc": canCuoc,
            "ngaycap": ngayCap,
            "quoctich": quocTich,
            "ngaysinh": ngaySinh,
            "gioitinh": gioiTinh,
            "nhomtuoi": nhomTuoi,
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: body,options: .fragmentsAllowed)
        var request = URLRequest(url: urlAddTB)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
               
       URLSession.shared.dataTask(with: request) { data, response, error in

           guard let data = data, error == nil else {
               return
           }
      
           let responseJSON = try? JSONDecoder().decode([Khach].self ,from: data )
           
       }.resume()
    }

    var body: some View {
        ZStack{
            VStack{
                // tieu de khach tro
                ZStack{
                    HStack{
                        Image("khachtro")
                        Text("Thêm khách trọ").textCase(.uppercase).foregroundColor(Color(hex: "#354B9C"))
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
                
                    HStack{
                        Text("Thêm khách")
                            .padding(.leading,36)
                            .padding(.trailing,36)
                            .padding(.top,8)
                            .padding(.bottom,8)
                            .foregroundColor(Color.white)
                            .background(RoundedCorners(color: Color(hex: "1338BD"), tl: 10, tr: 10, bl: 0, br: 0))
                        Spacer()
                    }.padding(.top,18)
                       
                    ScrollView{
                            VStack{
                                ZStack
                                {
                                    HStack{
                                        Text("Tên khách: ").font(.system(size: 16, weight: .bold))
                                            .padding(.leading, 9)
                                        TextField("", text: $tenKhach)
                                            .padding(.trailing, 9)
                                    }.padding(.top, 5)
                                        .padding(.bottom, 5)
                                        .background(Color(hex: "F3F6FF"))
                                        .clipShape(RoundedRectangle(cornerRadius:10))
                                    
                                }.padding(.trailing, 14)
                                    .padding(.leading, 14)
                                    .padding(.bottom, 6)
                                    .padding(.top, 16)
                                
                                ZStack
                                {
                                    HStack{
                                        Text("Điện thoại: ").font(.system(size: 16, weight: .bold))
                                            .padding(.leading, 9)
                                        TextField("", text: $dienThoai)
                                            .padding(.trailing, 9)
                                    }.padding(.top, 5)
                                        .padding(.bottom, 5)
                                        .background(Color(hex: "F3F6FF"))
                                        .clipShape(RoundedRectangle(cornerRadius:10))
                                    
                                }.padding(.trailing, 14)
                                    .padding(.leading, 14)
                                    .padding(.bottom, 6)
                                    .padding(.top, 6)
                                
                                ZStack
                                {
                                    HStack{
                                        Text("Số CCCD/ CMND: ").font(.system(size: 16, weight: .bold))
                                            .padding(.leading, 9)
                                        TextField("", text: $canCuoc)
                                            .padding(.trailing, 9)
                                    }.padding(.top, 5)
                                        .padding(.bottom, 5)
                                        .background(Color(hex: "F3F6FF"))
                                        .clipShape(RoundedRectangle(cornerRadius:10))
                                    
                                }.padding(.trailing, 14)
                                    .padding(.leading, 14)
                                    .padding(.bottom, 6)
                                    .padding(.top, 6)
                                
                                ZStack
                                {
                                    HStack{
                                        Text("Địa chỉ: ").font(.system(size: 16, weight: .bold))
                                            .padding(.leading, 9)
                                        TextField("", text: $diaChi)
                                            .padding(.trailing, 9)
                                    }.padding(.top, 5)
                                        .padding(.bottom, 5)
                                        .background(Color(hex: "F3F6FF"))
                                        .clipShape(RoundedRectangle(cornerRadius:10))
                                    
                                }.padding(.trailing, 14)
                                    .padding(.leading, 14)
                                    .padding(.bottom, 6)
                                    .padding(.top, 6)
                                
                                ZStack
                                {
                                    HStack{
                                        Text("Ngày cấp: ").font(.system(size: 16, weight: .bold))
                                            .padding(.leading, 9)
                                        TextField("", text: $ngayCap)
                                            .padding(.trailing, 9)
                                    }.padding(.top, 5)
                                        .padding(.bottom, 5)
                                        .background(Color(hex: "F3F6FF"))
                                        .clipShape(RoundedRectangle(cornerRadius:10))
                                    
                                }.padding(.trailing, 14)
                                    .padding(.leading, 14)
                                    .padding(.bottom, 6)
                                    .padding(.top, 6)
                                
                                ZStack
                                {
                                    HStack{
                                        Text("Ngày sinh: ").font(.system(size: 16, weight: .bold))
                                            .padding(.leading, 9)
                                        TextField("", text: $ngaySinh)
                                            .padding(.trailing, 9)
                                    }.padding(.top, 5)
                                        .padding(.bottom, 5)
                                        .background(Color(hex: "F3F6FF"))
                                        .clipShape(RoundedRectangle(cornerRadius:10))
                                    
                                }.padding(.trailing, 14)
                                    .padding(.leading, 14)
                                    .padding(.bottom, 6)
                                    .padding(.top, 6)
                                
                                ZStack
                                {
                                    HStack{
                                        Text("Quốc tịch: ").font(.system(size: 16, weight: .bold))
                                            .padding(.leading, 9)
                                        TextField("", text: $quocTich)
                                            .padding(.trailing, 9)
                                    }.padding(.top, 5)
                                        .padding(.bottom, 5)
                                        .background(Color(hex: "F3F6FF"))
                                        .clipShape(RoundedRectangle(cornerRadius:10))
                                    
                                }.padding(.trailing, 14)
                                    .padding(.leading, 14)
                                    .padding(.bottom, 6)
                                    .padding(.top, 6)
                                
                                ZStack
                                {
                                    HStack{
                                        Text("Giới tính: ").font(.system(size: 16, weight: .bold))
                                            .padding(.leading, 9)
                                        TextField("", text: $gioiTinh)
                                            .padding(.trailing, 9)
                                    }.padding(.top, 5)
                                        .padding(.bottom, 5)
                                        .background(Color(hex: "F3F6FF"))
                                        .clipShape(RoundedRectangle(cornerRadius:10))
                                    
                                }.padding(.trailing, 14)
                                    .padding(.leading, 14)
                                    .padding(.bottom, 6)
                                    .padding(.top, 6)
                                
                                ZStack
                                {
                                    HStack{
                                        Text("Đối tượng: ").font(.system(size: 16, weight: .bold))
                                            .padding(.leading, 9)
                                        TextField("", text: $nhomTuoi)
                                            .padding(.trailing, 9)
                                    }.padding(.top, 5)
                                        .padding(.bottom, 5)
                                        .background(Color(hex: "F3F6FF"))
                                        .clipShape(RoundedRectangle(cornerRadius:10))
                                    
                                }.padding(.trailing, 14)
                                    .padding(.leading, 14)
                                    .padding(.bottom, 6)
                                    .padding(.top, 6)
                                
                                HStack{
                                    Button
                                    {
                                    }label: {
                                        Text("Quay lại")
                                            .padding(.top,5)
                                            .padding(.bottom,5)
                                            .padding(.leading, 44)
                                            .padding(.trailing ,44)
                                            .foregroundColor(.white)
                                    }
                                    .foregroundColor(Color.white)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#8091CE"),Color(hex:"#3252C5")]),startPoint: .topLeading,endPoint: .bottomTrailing))
                                    .cornerRadius(6)
                                    .padding(.top,22)
                                    .padding(.bottom,17)
                                    .padding(.leading,9)
                                    
                                    Spacer()
                                    
                                    Button{
                                        Task{
                                            do {
                                                try await addKhach()
                                            }
                                            catch {
                                                print(error)
                                            }
                                        }
                                    }
                                label:{
                                    Text("Thêm mới")
                                        .padding(.top,5)
                                        .padding(.bottom,5)
                                        .padding(.leading, 44)
                                        .padding(.trailing ,44)
                                }
                                .foregroundColor(Color.white)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#B71616"), Color(hex:"#ec323780")]),startPoint: .topLeading,endPoint: .trailing))
                                .cornerRadius(6)
                                .padding(.top,22)
                                .padding(.bottom,17)
                                .padding(.trailing,9)
                                }
                            }
                            .background(Color.white)
                    }
                    .zIndex(1)
                    .padding(.top, -10)
            }
            .background(Color(hex: "#F2F1F6"))
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

struct KhachTroAddView_Previews: PreviewProvider {
    static var previews: some View {
        KhachTroAddView()
    }
}

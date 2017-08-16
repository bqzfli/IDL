;从相机坐标系-旋转至-地图坐标系转换
;地面X轴：纬度方向；      地面Y轴：经度方向；     地面Z轴：海拔
;像平面坐标，单位：米
;c_x 目标点，相框坐标 x    米
;c_y 目标点，相框坐标 y    米
;c_f 主距                  0米
;坐标系旋转角度，单位：°
;r_x 绕x轴旋转角度    °
;r_y 绕y轴旋转角度    °
;r_z 绕z轴旋转角度    °
FUNCTION Convert_Rotate_CameraCoodinate2MAP,c_x,c_y,c_f,r_x,r_y,r_z
  a1 = cosD(r_y)*cosD(r_z)-sinD(r_y)*sinD(r_x)*sinD(r_z)
  a2 = -cosD(r_y)*sinD(r_z)-sinD(r_y)*sinD(r_x)*cosD(r_z)
  a3 = -sinD(r_y)*cosD(r_x)
  b1 = cosD(r_x)*sinD(r_z)
  b2 = cosD(r_x)*cosD(r_z)
  b3 = -sinD(r_x)
  c1 = sinD(r_y)*cosD(r_z)+cosD(r_y)*sinD(r_x)*sinD(r_z)
  c2 = -sinD(r_y)*sinD(r_z)+cosD(r_y)*sinD(r_x)*cosD(r_z)
  c3 = cosD(r_y)*cosD(r_x)
;  print, a1*c_x
;  print, a2*c_y
;  print, a3*c_f  
  p_X = a1*c_x+a2*c_y-a3*c_f
  P_Y = b1*c_x+b2*c_y-b3*c_f
  P_Z = c1*c_x+c2*c_y-c3*c_f
  Position_R = HASH('X',P_X,'Y',P_Y,'Z',P_Z)  
  print,Position_R
  return,Position_R
END

;从相机坐标系-转换至-地图坐标系转换
;地面X轴：纬度方向；      地面Y轴：经度方向；     地面Z轴：海拔
;像平面坐标，单位：米
;c_x 目标点，相框坐标 x    
;c_y 目标点，相框坐标 y    
;c_v 像距                                              
;坐标系旋转角度，单位：°
;r_x 绕x轴旋转角度    
;r_y 绕y轴旋转角度    
;r_z 绕z轴旋转角度    
;飞机位置，单位：米
;PLANE_Elevation        飞机航高，气压计
;PLANE_X                飞机地图x轴坐标， 经度方向
;PLANE_Y                飞机地图x轴坐标， 经度方向
FUNCTION Convert_CameraCoodinate2Map,c_x,c_y,c_v,r_x,r_y,r_z,PLANE_X,PLANE_Y,PLANE_Elevation
  Position_R=Convert_Rotate_Camera2MAP(c_x,c_y,c_v,r_x,r_y,r_z)
  ;缩放参数
  rate = PLANE_Elevation/c_v
  Position_x = PLANE_X+rate*Position_R["X"]
  Position_y = PLANE_Y+rate*Position_R["Y"]
  Position_z = PLANE_Elevation+rate*Position_R["Z"]
  Position = HASH('X',Position_x,'Y',Position_y,'Z',Position_z)
  return,Position
END

;相机姿态->像平面坐标姿态的转换
;单位：°
;YAW      航向角
;PITCH    俯仰角
;ROLL     横滚角
FUNCTION Convert_CameraR2CameraCoodinateR,YAW,PITCH,ROLL
  c_x = 90+PITCH;
  c_y = ROLL;
  c_z = YAW
  R_c = HASH('X',c_x,'Y',c_y,'Z',c_z)
  return, R_c
END

;从相机-转换至-地图坐标系转换
;id  点编号：用于打印日志
;地面X轴：纬度方向；      地面Y轴：经度方向；     地面Z轴：海拔
;像平面坐标，单位：米
;c_x 目标点，相框坐标 x    
;c_y 目标点，相框坐标 y    
;c_v 像距          
;f   焦距                                    
;相机姿态->像平面坐标姿态的转换
;单位：°
;YAW      航向角
;PITCH    俯仰角
;ROLL     横滚角
;飞机位置，单位：米
;PLANE_Elevation        飞机航高，气压计
;PLANE_X                飞机地图x轴坐标， 经度方向
;PLANE_Y                飞机地图Y轴坐标， 经度方向
;FOV_Horizontal_2       半x视角
;Fov_vertical_2         半y视角
FUNCTION Convert_Camera2Map,id,c_x,c_y,c_v,f,YAW,PITCH,ROLL,PLANE_X,PLANE_Y,PLANE_Elevation;,FOV_Horizontal_2,Fov_vertical_2
  ;转换为坐标轴旋转
  R_c = Convert_CameraR2CameraCoodinateR(YAW,PITCH,ROLL);
  r_x = R_c["X"];
  r_y = R_c["Y"];
  r_z = R_c["Z"];
  
  ;求坐标轴旋转后位置
  ;Position_R=Convert_Rotate_CameraCoodinate2MAP(c_x,c_y,0,r_x,r_y,r_z)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;七参数转换
  ;缩放参数
  ;因为主光轴不垂直地面，所以必须用“高程/cos(x旋转)”
  ;rate = (PLANE_Elevation/COSD(r_x))/c_v
;  Position_x = PLANE_X+rate*Position_R["X"] + PLANE_Elevation*tanD(r_x)*sinD(-r_z)
;  Position_y = PLANE_Y+rate*Position_R["Y"] + PLANE_Elevation*tanD(r_x)*cosD(r_z)
;  Position_z = PLANE_Elevation+rate*Position_R["Z"]
;  print,'rate:'+String(rate)
;  Position = HASH('X',Position_x,'Y',Position_y,'Z',Position_z)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;---------------三角函数--------------------
  ;print,strcompress('*********点:'+String(id)+'************')
  ;-----------一.计算正北方向俯仰角变化--------------------
  ;通过（视场角/2),计算目标点的“变化y”
  Fov_vertical_2 = atan(c_y/f)/!DTOR
  ;print,'视线与主光轴夹角在竖直面的投影：'+String(Fov_vertical_2);
  h_y_tan = PLANE_Elevation*tanD(r_x+Fov_vertical_2)
  ;print,'视线与y轴负方向夹角：'+String(r_x+Fov_vertical_2)
  ;print,'y轴方向距离：'+String(h_y_tan)
  ;通过勾股定理，计算目标点在“光线”所在面的“变化y（立体）”
  h_y_tan_3d = (PLANE_Elevation^2+h_y_tan^2)^(0.5)  
  
  ;通过（视场角/2),计算目标点的“变化x”  
  FOV_Horizontal_2 = atan(c_x/f)/!DTOR
  h_x_tan = h_y_tan_3d*tanD(FOV_Horizontal_2)
  ;print,'视点水平角：'+String(FOV_Horizontal_2)
  ;print,'x轴方向距离：'+String(h_x_tan) 
  
  ;-----------二.计算方向角变化 ----------------------------
  ;目标点在水平面内与o点连线的长度
  Distance_Postion2O = (h_x_tan^2+h_y_tan^2)^0.5
  ;目标点在水平面内与o点连线，与y轴夹角
  R_Postion_O_Y = atan(h_x_tan/h_y_tan)/!DTOR  
  if (h_y_tan<0 and h_x_tan<0) then begin
    R_Postion_O_Y = R_Postion_O_Y - 180
  endif else if(h_y_tan<0 and h_x_tan>0) then begin
    R_Postion_O_Y = 180 + R_Postion_O_Y
  endif  
  ;print,'目标点在水平面内与o点连线，与y轴夹角:'+String(R_Postion_O_Y)
    
  ;旋转后角度
  R_Postion_O_Y_Rotate = R_Postion_O_Y + r_z  
  ;print,'旋转后角度:'+String(R_Postion_O_Y_Rotate)
  ;计算x、y的旋转后的位置
  h_y_tan_yaw = Distance_Postion2O*cosD(R_Postion_O_Y_Rotate)
  h_x_tan_yaw = Distance_Postion2O*sinD(R_Postion_O_Y_Rotate)
  
  ;-----------三.计算最终坐标
;  Position_y = PLANE_Y+h_y_tan
;  Position_x = Plane_x+h_x_tan
  Position_x = PLANE_X+h_x_tan_yaw
  Position_y = PLANE_Y+h_y_tan_yaw  
  
  ;print,'x:'+String(h_x_tan_yaw)
  ;print,'y:'+String(h_y_tan_yaw)
  
  Position = HASH('X',Position_x,'Y',Position_y)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  return,Position
END

FUNCTION Convert_Camera2Map_PRE
  initial
  X = 946567.369900695
  Y = 4354520.61702462
  FOV_Horizontal = !FOV_HORIZONTAL
  Fov_vertical = !FOV_VERTICAL
  f = !F_G
  CCDwidth = 2.0*tanD(FOV_Horizontal/2.0)*f
  print,strcompress('ccd宽：'+String(CCDwidth))
  CCDheight = 2.0*tanD(FOV_VERTICAL/2.0)*f
  print,strcompress('ccd高：'+String(CCDheight))
  pitch = -55.0000000
  yaw = 25.000000000
  roll = 0.000000000
  ELEVATION = 80.000000000
  p1=Convert_Camera2Map(1,CCDwidth/2,CCDheight/2,f,f,yaw,pitch,roll,X,Y,ELEVATION)
  p2=Convert_Camera2Map(2,-CCDwidth/2,CCDheight/2,f,f,yaw,pitch,roll,X,Y,ELEVATION)
  p3=Convert_Camera2Map(3,-CCDwidth/2,-CCDheight/2,f,f,yaw,pitch,roll,X,Y,ELEVATION)
  p4=Convert_Camera2Map(4,CCDwidth/2,-CCDheight/2,f,f,yaw,pitch,roll,X,Y,ELEVATION)
  Cov = HASH('1',p1,'2',p2,'3',p3,'4',p4)
  return, Cov
END

;计算图框交点位置
;pitch:       俯仰角
;yaw:         航偏角
;roll:        横滚角
;ELEVATION:   海拔
FUNCTION Convert_Camera2Map_Frame,pitch,yaw,roll,ELEVATION
  initial  
  X = 946567.369900695
  Y = 4354520.61702462
  FOV_Horizontal = !FOV_HORIZONTAL
  Fov_vertical = !FOV_VERTICAL
  f = !F_G
  CCDwidth = 2.0*tanD(FOV_Horizontal/2.0)*f
  CCDheight = 2.0*tanD(FOV_VERTICAL/2.0)*f
  p1=Convert_Camera2Map(1,CCDwidth/2,CCDheight/2,f,f,yaw,pitch,roll,X,Y,ELEVATION)
  p2=Convert_Camera2Map(2,-CCDwidth/2,CCDheight/2,f,f,yaw,pitch,roll,X,Y,ELEVATION)
  p3=Convert_Camera2Map(3,-CCDwidth/2,-CCDheight/2,f,f,yaw,pitch,roll,X,Y,ELEVATION)
  p4=Convert_Camera2Map(4,CCDwidth/2,-CCDheight/2,f,f,yaw,pitch,roll,X,Y,ELEVATION)
  Cov = HASH('1',p1,'2',p2,'3',p3,'4',p4)
  return, Cov
END
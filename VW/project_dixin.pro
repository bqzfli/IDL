

PRO precision
  initial
  t=drawOffsetCausePitch(90.00,-180.0,0.0,10)
  p=drawOffsetCauseHeight(30.0,100.00,10)
  result = cos(!PI)
  PRINT, result
END

;飞机姿态角度->绕x、y、z三轴的旋转角度，单位：十进制°
;yaw_plane      飞机方向角，指向北极为0°，偏东为+，偏西为-
;pitch_plane    飞机俯仰角，与地面平行为0°，垂直地面为-90°
;roll_plane     飞机横滚角，水平为0°，左低为+，右低为-
FUNCTION Convert_Plane2XYZ, yaw_plane,pitch_plane,roll_plane
  YAW_G = -yaw_plane
  PITCH_G = !LAT_G+pitch_plane
  ROLL_G = roll_plane
  xyz_rotate = Hash('X',YAW_G,'Y',PITCH_G,'Z',ROLL_G)
  return,  xyz_rotate
END


;获取从highst到lowest之间的数组
function getHeights,lowest,highest
  heights = FINDGEN(highest-lowest)
  heights += lowest
  RETURN, heights
END


;获取地心点X
FUNCTION getXdixin,x,y,f,H,YAW,P,R,B_g,L_g,H_g,a,b
  X_dinxin = cosD(L_g)*sinD(B_g)*(f*((H*sinD(R)*sinD(YAW))/f - (H*cosD(R)*cosD(YAW)*sinD(P))/f)  $
    + y*((H*cosD(R)*sinD(YAW))/f +(H*cosD(YAW)*sinD(P)*sinD(R))/f) $
    -(H*x*cosD(P)*cosD(YAW))/f $
    ) $
    - sinD(L_g)*(f*((H*cosD(YAW)*sinD(R))/f+(H*cosD(R)*sinD(P)*sinD(YAW))/f) $
    + y*((H*cosD(R)*cosD(YAW))/f-(H*sinD(P)*sinD(R)*sinD(YAW))/f) $
    + (H*x*cosD(P)*sinD(YAW))/f $
    )  $
    + cosD(B_g)*cosD(L_g)*((H*x*sinD(P))/f-H*cosD(P)*cosD(R)+(H*y*cosD(P)*sinD(R))/f) $
    + cosD(B_g)*cosD(L_g)*(H_g+a/((1- (sinD(B_g)^2*(a^2 - b^2))/a^2)^0.5))
  RETURN, X_dinxin
END


;获取地心点Y
FUNCTION getYdixin,x,y,f,H,YAW,P,R,B_g,L_g,H_g,a,b
  Y_dinxin = cosD(L_g)*(f*((H*cosD(YAW)*sinD(R))/f $
    +(H*cosD(R)*sinD(P)*sinD(YAW))/f $
    ) $
    +y*((H*cosD(R)*cosD(YAW))/f-(H*sinD(P)*sinD(R)*sinD(YAW))/f) $
    +(H*x*cosD(P)*sinD(YAW))/f $
    )$
    +sinD(B_g)*sinD(L_g)*(f*((H*sinD(R)*sinD(YAW))/f-(H*cosD(R)*cosD(YAW)*sinD(P))/f) $
    + y*((H*cosD(R)*sinD(YAW))/f + (H*cosD(YAW)*sinD(P)*sinD(R))/f) $
    - (H*x*cosD(P)*cosD(YAW))/f $
    ) $
    + cosD(B_g)*sinD(L_g)*((H*x*sinD(P))/f - H*cosD(P)*cosD(R) + (H*y*cosD(P)*sinD(R))/f) $
    + cosD(B_g)*sinD(L_g)*(H_g + a/((1 - (sinD(B_g)^2*(a^2 - b^2))/a^2))^0.5)
  RETURN, Y_dinxin
END

;获取地心点Z
FUNCTION getZdixin,x,y,f,H,YAW,P,R,B_g,L_g,H_g,a,b
  Z_dinxin = sinD(B_g)*(H_g-(a*((a^2-b^2)/(a^2)-1))/((1-(sinD(B_g)^2*(a^2-b^2))/a^2)^0.5))$
    -cosD(B_g)*( f*((H*sinD(R)*sinD(YAW))/f-(H*cosD(R)*cosD(YAW)*sinD(P))/f)  $
    +y*((H*cosD(R)*sinD(YAW))/f+(H*cosD(YAW)*sinD(P)*sinD(R))/f) $
    -(H*x*cosD(P)*cosD(YAW))/f                                   $
    )                                                             $
    +sinD(B_g)*((H*x*sinD(P))/f-H*cosD(P)*cosD(R)+ (H*y*cosD(P)*sinD(R))/f);
  RETURN, Z_dinxin
END

;获取目标点地心坐标系中的位置，X,Y,Z
;x    像平面坐标
;y    像平面坐标
;f    相机主距
;H    为航高
;YAW  航偏角Yaw
;P    俯仰角Pitch
;R    侧滚角度
;B_g  飞行器纬度
;L_g  飞行器经度
;H_G  飞行器海拔
FUNCTION getXYZ,x,y,f,H,YAW,P,R,B_g,L_g,H_g
  x_dixin = getXdixin(x,y,f,H,YAW,P,R,B_g,L_g,H_g,!aR,!bR)
  y_dixin = getYdixin(x,y,f,H,YAW,P,R,B_g,L_g,H_g,!aR,!bR)
  z_dixin = getZdixin(x,y,f,H,YAW,P,R,B_g,L_g,H_g,!aR,!bR)
  result = Hash('X',x_dixin,'Y',y_dixin,'Z',z_dixin);
  RETURN, result
END


;高度偏差的影响
;H:   高度
;H_OffSet: 高度误差
;yaw_plane: 飞机航向角
;pitch_plane: 飞机俯仰角
;roll_plane:  飞机横滚角
FUNCTION getOffsetCauseHeight,H,H_OffSet,yaw_plane,pitch_plane,roll_plane
  position = getBL(!x_G,!y_G,!f_G,H,yaw_plane,pitch_plane,roll_plane,!LAT_G,!LON_g,H)
  H_G = H + H_offSet
  position_OffSet = getBL(!x_G,!y_G,!f_G,H_G,yaw_plane,pitch_plane,roll_plane,!LAT_G,!LON_g,H_G)
  ;经纬度偏差
  offsetLogitude = position_OffSet["LONGITUDE"]-position["LONGITUDE"]
  offsetLatitude = position_OffSet["LATITUDE"]-position["LATITUDE"]
  ;距离偏差
  ;  offset=getDistanceOfCircle(position["LATITUDE"],$
  ;    position["LONGITUDE"],$
  ;    position_OffSet["LATITUDE"],$
  ;    position_OffSet["LONGITUDE"])
  ;偏差距离：平面直角坐标
  offset = getDistanceCartesin(position,position_OffSet)
  return, offset
END

;绘制不同高度下，高度偏差造成的误差
;h_lowest：最低高度
;h_highest:最高高度
;H_offset:偏差高度
FUNCTION drawOffsetCauseHeight,h_lowest,h_highest,H_offset
  heights = findgen(h_highest-h_lowest)
  heights += h_lowest+1
  offsets = getOffsetCauseHeight(heights,H_offset,!YAW_PLANE,!PITCH_PLANE,!ROLL_PLANE);
  ;直接绘图
  ;DEVICE,Decomposed = 1
  ;!P.BACKGROUND ='FFFFFF'xl
  ;!P.COLOR ='000000'xl
  ;Window,Xsize=800,Ysize =400
  ;plot,heights,offsets,TITLE='绘制不同高度下，高度偏差造成的误差'
  ;对象绘图
  p=plot(heights,offsets,$
    TITLE=strcompress('摄像头-方向角：'+String(!YAW_PLANE)+'°； 俯仰角'+String(!PITCH_PLANE)+'°；，不同高度下，高度偏差造成的误差'),$
    xtitle = '高度（米）',$
    ytitle = '误差距离（米）',$
    font_name = 'Microsoft Yahei')
END


;不同俯仰角度下，高度偏差造成的误差
;height：                高度
;Pitch_low:    最低角度
;Pitch_high：      最高角度
;h_offset:     高度偏差
FUNCTION drawOffsetCausePitch,height,Pitch_low,Pitch_high,h_offset
  Pitchs = findgen(Pitch_high-Pitch_low)
  Pitchs += Pitch_low + 1
  offsets = getOffsetCauseHeight(height,h_offset,!YAW_PLANE,Pitchs,!ROLL_PLANE);
  ;直接绘图
  ;DEVICE,Decomposed = 1
  ;!p.FONT = 0
  ;DEVICE, SET_FONT = "宋体"
  ;!P.BACKGROUND ='FFFFFF'xl
  ;!P.COLOR ='000000'xl
  ;Window,Xsize=800,Ysize =400
  ;plot,Pitchs,offsets,TITLE=STRING(height)+'米高度;不同俯仰角度下，高度偏差（'+STRING(h_offset)+'米）造成的误差',xtitle = '俯仰角（°）', ytitle='误差距离（米）'
  ;对象绘图
  p=plot(Pitchs,offsets,$
    TITLE=strcompress('摄像头:'+STRING(height)+'米高;方向角：'+String(!YAW_PLANE)+'°；不同俯仰角下，高度偏差（'+STRING(h_offset)+'米）造成的误差'),$
  xtitle = '俯仰角（°）',$
    ytitle = '误差距离（米）',$
    font_name = 'Microsoft Yahei')
END


;地心坐标系-》大地坐标系:十进制°
;Y_dixin:   地心坐标系Y
;X_dixin:   地心坐标系X
FUNCTION getLFromDixin,X_dixin,Y_dixin
  L = atan(Y_dixin/X_dixin)
  return ,L
END

;地心坐标系-》大地坐标系:十进制°
;Y_dixin:   地心坐标系Y
;X_dixin:   地心坐标系X
;Z_dixin:   地心坐标系Z
FUNCTION getBFromDixin,X_dixin,Y_dixin,Z_dixin
  e = ((!aR^2-!bR^2)^0.5)/(!aR)
  e2= ((!aR^2-!bR^2)^0.5)/(!bR)
  U = atan(Z_dixin/((X_dixin^2+Y_dixin^2)^0.5*(1-e^2)^0.5))
  B = atan((Z_dixin+!bR*(e2^2)*((sin(U))^3))/((X_dixin^2+Y_dixin^2)^0.5-!aR*(e^2)*((cos(U))^3)))
  N = !aR/((1-(e^2)*((sin(B))^2))^0.5)
  H = ((Y_dixin^2+X_dixin^2)^0.5)/cos(B)-N
  BH = HASH('B',B,'H',H,'N',N,'U',U)
  print,BH
  return ,BH
END

;获取目标点大地坐标系中的位置，十进制°
;x    像平面坐标
;y    像平面坐标
;f    相机主距
;H    为航高
;YAW_PLANE  飞机航偏角Yaw
;PITCH_PLAEN    飞机俯仰角Pitch
;ROLL_PLANE    飞机侧滚角度
;B_g  飞行器纬度
;L_g  飞行器经度
;H_G  飞行器海拔
FUNCTION getBL,x,y,f,H,YAW_PLANE,P_PLANE,ROLL_PLANE,B_g,L_g,H_g

  xyz_rotate=Convert_Plane2XYZ(YAW_PLANE,P_PLANE,ROLL_PLANE);
  YAW=xyz_rotate['X']
  P=xyz_rotate['Y']
  R=xyz_rotate['Z']
  xyz = getXYZ(x,y,f,H,YAW,P,R,B_g,L_g,H_g)
  x_dixin = xyz["X"]
  y_dixin = xyz["Y"]
  z_dixin = xyz["Z"]
  BH = getBFromDixin(x_dixin,y_dixin,z_dixin);
  Latitude = BH["B"]
  Latitude *= 180/!PI
  ELEVATION = BH["H"]
  Logitude = getLFromDixin(x_dixin,y_dixin);
  Logitude *= 180/!PI
  Logitude = Logitude + 180
  LL = HASH('LONGITUDE',Logitude,'LATITUDE',Latitude,'ELEVATION',ELEVATION);
  return, LL
END


;获取预设信息的坐标，水平单位：°，高程单位：米
FUNCTION getBLH_pre
  position = getBL(!x_G,!y_G,!f_G,!H_G,!YAW_PLANE,!PITCH_PLANE,!ROLL_PLANE,!LAT_G,!LON_G,!ELE_G)
  return, position
END

;获取预设信息的坐标，水平单位：°，高程单位：米
FUNCTION getBLH_pix,x,y
  position = getBL(x,y,!f_G,!H_G,!YAW_PLANE,!PITCH_PLANE,!ROLL_PLANE,!LAT_G,!LON_G,!ELE_G)
  return, position
END

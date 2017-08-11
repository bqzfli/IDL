;不同俯仰角度下，高度偏差造成的误差
;height：                高度
;Pitch_low:   最低角度
;Pitch_high：    最高角度
;h_offset:    高度偏差
FUNCTION draw_Deviation_FromHeight_InPitchs,height,Pitch_low,Pitch_high,h_offset
  Pitchs = findgen(Pitch_high - Pitch_low)
  Pitchs += Pitch_low + 1
  yaw  = 30
  roll = 0
  offsets = findgen(Pitch_high - Pitch_low)
  for i=0,Pitchs.LENGTH-1 do begin
    offsets(i)= cal_Deviation_FromHeight(height,h_offset,yaw,Pitchs[i],roll);
  endfor
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
    TITLE=strcompress('摄像头:'+STRING(height)+'米高;方向角：'+String(yaw)+'°；不同俯仰角下，高度偏差（'+STRING(h_offset)+'米）造成的误差'),$
  xtitle = '俯仰角（°）',$
    ytitle = '误差距离（米）',$
    font_name = 'Microsoft Yahei')
END

;绘制不同高度下，高度偏差造成的误差
;pitch_camera:摄像头俯仰角
;h_lowest：最低高度
;h_highest:最高高度
;H_offset:偏差高度
FUNCTION draw_Deviation_FromHeight_InHeights,pitch_camera,h_lowest,h_highest,H_offset
  heights = findgen(h_highest-h_lowest)
  heights += h_lowest+1
  yaw  = 30
  roll = 0
  offsets = findgen(h_highest - h_lowest)
  for i=0,heights.LENGTH-1 do begin
    offsets(i)= cal_Deviation_FromHeight(heights[i],H_offset,yaw,pitch_camera,roll);
  endfor
  ;直接绘图
  ;DEVICE,Decomposed = 1
  ;!P.BACKGROUND ='FFFFFF'xl
  ;!P.COLOR ='000000'xl
  ;Window,Xsize=800,Ysize =400
  ;plot,heights,offsets,TITLE='绘制不同高度下，高度偏差造成的误差'
  ;对象绘图
  p=plot(heights,offsets,$
    TITLE=strcompress('摄像头-方向角：'+String(yaw)+'°； 俯仰角'+String(pitch_camera)+'°；，不同高度下，高度偏差造成的误差'),$
    xtitle = '高度（米）',$
    ytitle = '误差距离（米）',$
    font_name = 'Microsoft Yahei')
END


;高度偏差的影响
;H:   高度
;H_OffSet: 高度误差
;yaw_plane: 飞机航向角
;pitch_plane: 飞机俯仰角
;roll_plane:  飞机横滚角
FUNCTION cal_Deviation_FromHeight,Elevation,Ele_Deviation,yaw_plane,pitch_plane,roll_plane
  initial
  X = 946567.369900695
  Y = 4354520.61702462
  FOV_Horizontal = !FOV_HORIZONTAL
  Fov_vertical = !FOV_VERTICAL
  f = !F_G
  CCDwidth = 2.0*tanD(FOV_Horizontal/2.0)*f
  CCDheight = 2.0*tanD(FOV_VERTICAL/2.0)*f
  position = Convert_Camera2Map(0,0.01,0.01,f,f,yaw_plane,pitch_plane,roll_plane,X,Y,ELEVATION)
  Elevation_deviation = Elevation + Ele_Deviation
  position_Deviation = Convert_Camera2Map(0,CCDwidth/2,CCDheight/2,f,f,yaw_plane,pitch_plane,roll_plane,X,Y,Elevation_deviation)
  ;经纬度偏差
  x_deviation = position_Deviation["X"]-position["X"]
  y_deviation = position_Deviation["Y"]-position["Y"]
  ;距离偏差
  ;偏差距离：平面直角坐标
  offset = (x_deviation^2+y_deviation^2)^0.5
  return, offset
END
;不同俯仰角度下，高度偏差造成的误差
;height：                高度
;Pitch_low:   最低角度
;Pitch_high：    最高角度
;h_offset:    高度偏差
FUNCTION draw_Deviation_FromHeight_InPitchs,height,Pitch_low,Pitch_high,h_offset
  colors=['r','g','b','c','m','y','k','a','b','c']  
  Pitchs = findgen(Pitch_high - Pitch_low)
  Pitchs += Pitch_low + 1
  yaw  = 30
  roll = 0
  offsets = findgen(Pitch_high - Pitch_low)
  plots = MAKE_ARRAY(height.LENGTH,1,/OBJ)
  for i = 0 ,height.LENGTH-1 do begin
      for j=0,Pitchs.LENGTH-1 do begin
          offsets(j)= cal_Deviation_FromHeight(height[i],h_offset,yaw,Pitchs[j],roll);
      endfor  
      ;对象绘图
      if i eq 0 then begin
            plots[i] = plot(  Pitchs,$
                              offsets,$
                              thick = height.LENGTH - i,$
                              colors[i],$
                              Name = strcompress(STRING(height[i])+'米'),$
                              TITLE = strcompress(['摄像头方向角为'+String(yaw)+'°时在各高度下','相对高程定位偏差（'+STRING(h_offset)+'米）在各俯仰角造成的水平定位误差']),$
                              xtitle = '俯仰角（°）',$
                              ytitle = '误差距离（米）',$
                              font_name = 'Microsoft Yahei' $
                            )
      endif else begin
            plots[i] = plot(  Pitchs,$
                              offsets,$
                              thick = height.LENGTH - i,$
                              colors[i],$
                              Name = strcompress(STRING(height[i])+'米'),$
                              /OVERPLOT $
                            )
      endelse
  endfor
  lege = legend($
    target = plots,$
    POSITION=[Pitchs[Pitchs.LENGTH -1]-5,offsets[Pitchs.LENGTH -1]],/DATA, $
    ;POSITION=[1,1],/NORMAL,$
    ;POSITION=[100,100],/DEVICE,$
    font_name = 'Microsoft Yahei',$
    /AUTO_TEXT_COLOR $
    )
END

;绘制不同高度下，高度偏差造成的误差
;pitch_camera:摄像头俯仰角
;h_lowest：最低高度
;h_highest:最高高度
;H_offset:偏差高度
FUNCTION draw_Deviation_FromHeight_InHeights,pitch_camera,h_lowest,h_highest,H_offset
  colors=['r','g','b','c','m','y','k','a','b','c']  
  heights = findgen(h_highest-h_lowest)
  heights += h_lowest+1
  yaw  = 30
  roll = 0
  offsets = findgen(h_highest - h_lowest)  
  plots = MAKE_ARRAY(pitch_camera.LENGTH,1,/OBJ)
  for i = 0,pitch_camera.LENGTH-1 do begin
    for j=0,heights.LENGTH-1 do begin
      offsets(j)= cal_Deviation_FromHeight(heights[j],H_offset,yaw,pitch_camera[i],roll);
    endfor
    ;直接绘图
    ;DEVICE,Decomposed = 1
    ;!P.BACKGROUND ='FFFFFF'xl
    ;!P.COLOR ='000000'xl
    ;Window,Xsize=800,Ysize =400
    ;plot,heights,offsets,TITLE='绘制不同高度下，高度偏差造成的误差'
    ;对象绘图
    if i eq 0 then begin
        plots[i] = plot(  heights,$
                          offsets,$
                          colors[i],$
                          Name = strcompress(STRING(pitch_camera[i])+'°'),$
                          TITLE=strcompress('摄像头方向角为'+String(yaw)+'°时，在各俯仰角下'+STRING(10b)+'不同高度，高程误差造成的水平定位误差'),$
                          xtitle = '高度（米）',$
                          ytitle = '误差距离（米）',$
                          font_name = 'Microsoft Yahei' $
                        )
    endif else begin
        plots[i] = plot(  heights,$
                          offsets,$
                          colors[i],$
                          Name = strcompress(STRING(pitch_camera[i])+'°'),$
                          /OVERPLOT $
                        )        
    endelse
  endfor
  lege = legend($
    target = plots,$
    POSITION=[heights[heights.LENGTH -1]-5,offsets[0]],/DATA, $
    ;POSITION=[1,1],/NORMAL,$
    ;POSITION=[100,100],/DEVICE,$
    /AUTO_TEXT_COLOR $
    )
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
  c_x = CCDwidth/2;
  c_y = CCDheight/2;
  position = Convert_Camera2Map(0,c_x,c_y,f,f,yaw_plane,pitch_plane,roll_plane,X,Y,ELEVATION)
  Elevation_deviation = Elevation + Ele_Deviation
  ;position_Deviation = Convert_Camera2Map(0,CCDwidth/2,CCDheight/2,f,f,yaw_plane,pitch_plane,roll_plane,X,Y,Elevation_deviation)
  position_Deviation = Convert_Camera2Map(0,c_x,c_y,f,f,yaw_plane,pitch_plane,roll_plane,X,Y,Elevation_deviation)

  ;经纬度偏差
  x_deviation = position_Deviation["X"]-position["X"]
  y_deviation = position_Deviation["Y"]-position["Y"]
  ;距离偏差
  ;偏差距离：平面直角坐标
  offset = (x_deviation^2+y_deviation^2)^0.5
  return, offset
END

FUNCTION draw_deviations
   height_camera = [30,50,70,90,110]
   pitch_camera = [-90,-80,-70,-60,-50]
   result = draw_Deviation_FromHeight_InPitchs(height_camera,-90,-50,10)
   result = draw_Deviation_FromHeight_InHeights(pitch_camera,30,100,10)
END
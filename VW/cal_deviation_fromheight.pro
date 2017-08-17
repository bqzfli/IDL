
;绝对定位_高度偏差的影响，不同观测高度、俯仰角
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

;绝对定位_高度偏差的影响，距中心点不同距离或位置的目标点
;ccd_x 距离中心点的x距离
;ccd_y 距离中心点的y距离
;H:   高度
;H_OffSet: 高度误差
;yaw_plane: 飞机航向角
;pitch_plane: 飞机俯仰角
;roll_plane:  飞机横滚角
FUNCTION cal_Deviation_From_CCD,ccd_x_propotion,ccd_y_propotion,Elevation,Ele_Deviation,yaw_plane,pitch_plane,roll_plane
  initial
  X = 946567.369900695
  Y = 4354520.61702462
  FOV_Horizontal = !FOV_HORIZONTAL
  Fov_vertical = !FOV_VERTICAL
  f = !F_G
  CCDwidth = 2.0*tanD(FOV_Horizontal/2.0)*f
  CCDheight = 2.0*tanD(FOV_VERTICAL/2.0)*f
  ccd_x = CCDwidth/2*ccd_x_propotion
  ccd_y = CCDheight/2*ccd_y_propotion
  position = Convert_Camera2Map(0,ccd_x,ccd_y,f,f,yaw_plane,pitch_plane,roll_plane,X,Y,ELEVATION)
  Elevation_deviation = Elevation + Ele_Deviation
  ;position_Deviation = Convert_Camera2Map(0,CCDwidth/2,CCDheight/2,f,f,yaw_plane,pitch_plane,roll_plane,X,Y,Elevation_deviation)
  position_Deviation = Convert_Camera2Map(0,ccd_x,ccd_y,f,f,yaw_plane,pitch_plane,roll_plane,X,Y,Elevation_deviation)

  ;经纬度偏差
  x_deviation = position_Deviation["X"]-position["X"]
  y_deviation = position_Deviation["Y"]-position["Y"]
  ;距离偏差
  ;偏差距离：平面直角坐标
  offset = (x_deviation^2+y_deviation^2)^0.5
  return, offset
END

;距离量算_高度偏差的影响，不同观测高度、俯仰角
;c_x_change 水平变化占屏幕宽度的百分比
;c_y_change 竖直变化占屏幕宽度的百分比
;H:   高度
;H_OffSet: 高度误差
;yaw_plane: 飞机航向角
;pitch_plane: 飞机俯仰角
;roll_plane:  飞机横滚角
FUNCTION cal_DistanceMeasure_Deviation_FromHeight,c_x_change,c_y_change,Elevation,Ele_Deviation,yaw_plane,pitch_plane,roll_plane
  initial
  X = 946567.369900695
  Y = 4354520.61702462
  FOV_Horizontal = !FOV_HORIZONTAL
  Fov_vertical = !FOV_VERTICAL
  f = !F_G
  CCDwidth  = 2.0*tanD(FOV_Horizontal/2.0)*f
  CCDheight = 2.0*tanD(FOV_VERTICAL  /2.0)*f
;  c_x = CCDwidth /4;
;  c_y = CCDheight/4;
  c_x = 0.00;
  c_y = 0.00;
  ;无偏差状态下的距离
  position1 = Convert_Camera2Map(0,c_x,c_y,f,f,yaw_plane,pitch_plane,roll_plane,X,Y,ELEVATION)  
  position2 = Convert_Camera2Map(0,c_x + CCDwidth*c_x_change,c_y + CCDheight*c_y_change,f,f,yaw_plane,pitch_plane,roll_plane,X,Y,ELEVATION)
  x_distance = position1["X"]-position2["X"]
  y_distance = position1["Y"]-position2["Y"]
  distance_1_2 = (x_distance ^ 2 + y_distance ^ 2) ^ 0.5
  ;偏差状态下的距离
  Elevation_deviation = Elevation + Ele_Deviation
  position_1_Deviation = Convert_Camera2Map(0,c_x,c_y,f,f,yaw_plane,pitch_plane,roll_plane,X,Y,Elevation_deviation)
  position_2_Deviation = Convert_Camera2Map(0,c_x + CCDwidth*c_x_change,c_y + CCDheight*c_y_change,f,f,yaw_plane,pitch_plane,roll_plane,X,Y,Elevation_deviation)
  x_distance_deviation = position_1_Deviation["X"]-position_2_Deviation["X"]
  y_distance_deviation = position_1_Deviation["Y"]-position_2_Deviation["Y"]
  distance_1_2_deviation = (x_distance_deviation ^ 2 + y_distance_deviation ^ 2) ^ 0.5
    
  ;距离偏差
  ;偏差距离：平面直角坐标
  offset = ((distance_1_2_deviation - distance_1_2)^2)^0.5
  return, offset
END

;距离量算_高度偏差的影响，距中心点不同距离或位置的目标点
;ccd_x 距离中心点的x距离
;ccd_y 距离中心点的y距离
;H:   高度
;H_OffSet: 高度误差
;yaw_plane: 飞机航向角
;pitch_plane: 飞机俯仰角
;roll_plane:  飞机横滚角
FUNCTION cal_DistanceMeasure_Deviation_From_CCD,ccd_x_propotion,ccd_y_propotion,Elevation,Ele_Deviation,yaw_plane,pitch_plane,roll_plane
  
  initial
  X = 946567.369900695
  Y = 4354520.61702462
  FOV_Horizontal = !FOV_HORIZONTAL
  Fov_vertical = !FOV_VERTICAL
  f = !F_G
  CCDwidth  = 2.0 * tanD(FOV_Horizontal/2.0) * f
  CCDheight = 2.0 * tanD(FOV_VERTICAL  /2.0) * f
  ccd_x = CCDwidth / 2 * ccd_x_propotion
  ccd_y = CCDheight/ 2 * ccd_y_propotion
  position = Convert_Camera2Map(0,ccd_x,ccd_y,f,f,yaw_plane,pitch_plane,roll_plane,X,Y,ELEVATION)
  Elevation_deviation = Elevation + Ele_Deviation
  ;position_Deviation = Convert_Camera2Map(0,CCDwidth/2,CCDheight/2,f,f,yaw_plane,pitch_plane,roll_plane,X,Y,Elevation_deviation)
  position_Deviation  = Convert_Camera2Map(0,ccd_x,ccd_y,f,f,yaw_plane,pitch_plane,roll_plane,X,Y,Elevation_deviation)

  ;经纬度偏差
  x_deviation = position_Deviation["X"] - position["X"]
  y_deviation = position_Deviation["Y"] - position["Y"]
  
  ;距离偏差
  ;偏差距离：平面直角坐标
  offset = (x_deviation ^ 2 + y_deviation ^ 2) ^ 0.5
  return, offset
END


;绘制高度偏差造成的误差(Y)，屏幕中不同水平距离测量(X),不同俯仰角度下(LINE)
;c_x_change_low  水平量距占屏幕宽度的百分比——最小
;c_x_change_high 水平量距占屏幕宽度的百分比——最大
;c_y_change      竖直量距占屏幕宽度的百分比
;height：                高度
;Pitchs:      俯仰角
;h_offset:    高度偏差
FUNCTION draw_DistanceMeasure_Deviation_FromHeight_InchangesCCDX_InPitchs,c_x_change_low,c_x_change_high,c_y_change,height,Pitchs,h_offset
  colors=['r','g','b','c','m','y','k','a','b','c']
  c_x_changes = dindgen(c_x_change_high - c_x_change_low)
  c_x_changes += c_x_change_low
  c_x_changes = c_x_changes/100.00
  yaw  = 30
  roll = 0
  offsets = dindgen(c_x_change_high - c_x_change_low)
  plots = MAKE_ARRAY(Pitchs.LENGTH,1,/OBJ)
  for i = 0 ,Pitchs.LENGTH-1 do begin
    for j=0,c_x_changes.LENGTH-1 do begin
      offsets(j)= cal_DistanceMeasure_Deviation_FromHeight(c_x_changes[j],c_y_change,height,h_offset,yaw,Pitchs[i],roll);
    endfor
    ;对象绘图
    if i eq 0 then begin
      plots[i] = plot( long(c_x_changes*100),$
        offsets,$
        ;thick = c_x_changes.LENGTH - i,$
        colors[i],$
        YRANGE = [0,14], $
        Name = strcompress(STRING(long(Pitchs[i]))+'°'),$
        TITLE = strcompress(['观测点高程为：'+String(long(height))+'米，方向角为'+String(yaw)+'°高程定位偏差'+STRING(long(h_offset))+'米，',$
                             '观测镜头俯仰角在' $
                             +String(long(Pitchs[0])) $
                             +'°~' $
                             +String(long(Pitchs[Pitchs.LENGTH-1])) $
                             +'°之间时的距离量算误差'] $
                            ),$
        xtitle = '量算距离占屏幕宽度比例（%）',$
        ytitle = '误差距离（米）',$
        font_name = 'Microsoft Yahei' $
        )
    endif else begin
      plots[i] = plot(long(c_x_changes*100),$
        offsets,$
        thick = height.LENGTH - i,$
        colors[i],$
        Name = strcompress(STRING(long(Pitchs[i]))+'°'),$
        /OVERPLOT $
        )
    endelse
  endfor
  lege = legend($
    target = plots,$
    POSITION=[c_x_change_high-30,offsets[c_x_changes.LENGTH -1]],/DATA, $
    ;POSITION=[1,1],/NORMAL,$
    ;POSITION=[100,100],/DEVICE,$
    font_name = 'Microsoft Yahei',$
    /AUTO_TEXT_COLOR $
    )
END


;绘制高度偏差造成的误差(Y)，屏幕中不同竖直距离测量(X),不同俯仰角度下(LINE)
;c_x_change       水平量距占屏幕宽度的百分比
;c_y_change_low   竖直量距占屏幕宽度的百分比——最小
;c_y_change_high  竖直变化占屏幕宽度的百分比——最大
;height：                高度
;Pitchs:      俯仰角
;h_offset:    高度偏差
FUNCTION draw_DistanceMeasure_Deviation_FromHeight_InchangesCCDY_InPitchs,c_x_change,c_y_change_low,c_y_change_high,height,Pitchs,h_offset
  colors=['r','g','b','c','m','y','k','a','b','c']
  c_y_changes = dindgen(c_y_change_high - c_y_change_low)
  c_y_changes += c_y_change_low
  c_y_changes = c_y_changes/100.00
  yaw  = 30
  roll = 0
  offsets = dindgen(c_y_change_high - c_y_change_low)
  plots = MAKE_ARRAY(Pitchs.LENGTH,1,/OBJ)
  for i = 0 ,Pitchs.LENGTH-1 do begin
    for j=0,c_y_changes.LENGTH-1 do begin
      offsets(j)= cal_DistanceMeasure_Deviation_FromHeight(c_x_change,c_y_changes[j],height,h_offset,yaw,Pitchs[i],roll);
    endfor
    ;对象绘图
    if i eq 0 then begin
      plots[i] = plot( long(c_y_changes*100),$
        offsets,$
        ;thick = c_x_changes.LENGTH - i,$
        colors[i],$
        YRANGE = [0,14], $
        Name = strcompress(STRING(long(Pitchs[i]))+'°'),$
        TITLE = strcompress(['观测点高程为：'+String(long(height))+'米，方向角为'+String(yaw)+'°高程定位偏差'+STRING(long(h_offset))+'米，',$
        '观测镜头俯仰角在' $
        +String(long(Pitchs[0])) $
        +'°~' $
        +String(long(Pitchs[Pitchs.LENGTH-1])) $
        +'°之间时的距离量算误差'] $
        ),$
        xtitle = '量算距离占屏幕高度比例（%）',$
        ytitle = '误差距离（米）',$
        font_name = 'Microsoft Yahei' $
        )
    endif else begin
      plots[i] = plot(long(c_y_changes*100),$
        offsets,$
        thick = height.LENGTH - i,$
        colors[i],$
        Name = strcompress(STRING(long(Pitchs[i]))+'°'),$
        /OVERPLOT $
        )
    endelse
  endfor
  lege = legend($
    target = plots,$
    POSITION=[c_y_change_high-30,offsets[c_y_changes.LENGTH -1]],/DATA, $
    ;POSITION=[1,1],/NORMAL,$
    ;POSITION=[100,100],/DEVICE,$
    font_name = 'Microsoft Yahei',$
    /AUTO_TEXT_COLOR $
    )
END




;绘制高度偏差造成的误差(Y)，不同俯仰角度下(X)，屏幕中不同水平距离测量(line)
;c_x_changes 水平变化占屏幕宽度的百分比
;c_y_change 竖直变化占屏幕宽度的百分比
;height：                高度
;Pitch_low:   最低角度
;Pitch_high：    最高角度
;h_offset:    高度偏差
FUNCTION draw_DistanceMeasure_Deviation_FromHeight_InPitchs_InchangesCCDX,c_x_changes,c_y_change,height,Pitch_low,Pitch_high,h_offset
  colors=['r','g','b','c','m','y','k','a','b','c']
  Pitchs = dindgen(Pitch_high - Pitch_low)
  Pitchs += Pitch_low + 1
  yaw  = 30
  roll = 0
  offsets = dindgen(Pitch_high - Pitch_low)
  plots = MAKE_ARRAY(c_x_changes.LENGTH,1,/OBJ)
  for i = 0 ,c_x_changes.LENGTH-1 do begin
    for j=0,Pitchs.LENGTH-1 do begin
      offsets(j)= cal_DistanceMeasure_Deviation_FromHeight(c_x_changes[i],c_y_change,height,h_offset,yaw,Pitchs[j],roll);
    endfor
    ;对象绘图
    if i eq 0 then begin
      plots[i] = plot(  Pitchs,$
        offsets,$
        ;thick = c_x_changes.LENGTH - i,$
        colors[i],$ 
        YRANGE = [0,15], $
        Name = strcompress(STRING(long(c_x_changes[i]*100))+'%'),$
        TITLE = strcompress(['摄像头方向角为'+String(yaw)+'°时，在各高度下相对高程定位偏差（'+STRING(long(h_offset))+'米）',$
                             '在屏幕水平方向测量距离(横向占比屏幕' $
                             +String(long((c_x_changes[0]^2+c_y_change^2)^0.5*100)) $
                             +'%~' $
                             +String(long((c_x_changes[c_x_changes.LENGTH-1]^2+c_y_change^2)^0.5*100)) $
                             +'%)时的误差'] $
                            ),$
        xtitle = '俯仰角（°）',$
        ytitle = '误差距离（米）',$
        font_name = 'Microsoft Yahei' $
        )
    endif else begin
      plots[i] = plot(Pitchs,$
        offsets,$
        thick = height.LENGTH - i,$
        colors[i],$
        Name = strcompress(STRING(long(c_x_changes[i]*100))+'%'),$
        /OVERPLOT $
        )
    endelse
  endfor
  lege = legend($
    target = plots,$
    POSITION=[Pitchs[Pitchs.LENGTH -1]-15,offsets[Pitchs.LENGTH -1]-0.001],/DATA, $
    ;POSITION=[1,1],/NORMAL,$
    ;POSITION=[100,100],/DEVICE,$
    font_name = 'Microsoft Yahei',$
    /AUTO_TEXT_COLOR $
    )
END



;绘制高度偏差造成的误差(Y)，不同俯仰角度下(X)，屏幕中不同竖直距离测量(LINE)
;c_x_change 水平变化占屏幕宽度的百分比
;c_y_changes 竖直变化占屏幕宽度的百分比
;height：                高度
;Pitch_low:   最低角度
;Pitch_high：    最高角度
;h_offset:    高度偏差
FUNCTION draw_DistanceMeasure_Deviation_FromHeight_InPitchs_InchangesCCDY,c_x_change,c_y_changes,height,Pitch_low,Pitch_high,h_offset
  colors=['r','g','b','c','m','y','k','a','b','c']
  Pitchs = dindgen(Pitch_high - Pitch_low)
  Pitchs += Pitch_low + 1
  yaw  = 30
  roll = 0
  offsets = dindgen(Pitch_high - Pitch_low)
  plots = MAKE_ARRAY(c_y_changes.LENGTH,1,/OBJ)
  for i = 0 ,c_y_changes.LENGTH-1 do begin
    for j=0,Pitchs.LENGTH-1 do begin
      offsets(j)= cal_DistanceMeasure_Deviation_FromHeight(c_x_change,c_y_changes[i],height,h_offset,yaw,Pitchs[j],roll);
    endfor
    ;对象绘图
    if i eq 0 then begin
      plots[i] = plot(  Pitchs,$
        offsets,$
        ;thick = c_x_changes.LENGTH - i,$
        colors[i],$
        YRANGE = [0,15], $
        Name = strcompress(STRING(long(c_y_changes[i]*100))+'%'),$
        TITLE = strcompress(['摄像头方向角为'+String(yaw)+'°时，在各高度下相对高程定位偏差（'+STRING(long(h_offset))+'米）',$
                             '在屏幕竖直方向测量距离(横向占比屏幕' $
                             +String(long((c_x_change^2+c_y_changes[0]^2)^0.5*100)) $
                             +'%~' $
                             +String(long((c_x_change^2+c_y_changes[c_y_changes.LENGTH-1]^2)^0.5*100)) $
                             +'%)时的误差'] $
                             ),$
        xtitle = '俯仰角（°）',$
        ytitle = '误差距离（米）',$
        font_name = 'Microsoft Yahei' $
        )
    endif else begin
      plots[i] = plot(Pitchs,$
        offsets,$
        thick = height.LENGTH - i,$
        colors[i],$
        Name = strcompress(STRING(long(c_y_changes[i]*100))+'%'),$
        /OVERPLOT $
        )
    endelse
  endfor
  lege = legend($
    target = plots,$
    POSITION=[Pitchs[Pitchs.LENGTH -1]-15,offsets[Pitchs.LENGTH -1]-0.001],/DATA, $
    ;POSITION=[1,1],/NORMAL,$
    ;POSITION=[100,100],/DEVICE,$
    font_name = 'Microsoft Yahei',$
    /AUTO_TEXT_COLOR $
    )
END


;绘制高度偏差造成的误差，不同俯仰角度下，不同高度下测量
;c_x_change 水平变化占屏幕宽度的百分比
;c_y_change 竖直变化占屏幕宽度的百分比
;height：                高度
;Pitch_low:   最低角度
;Pitch_high：    最高角度
;h_offset:    高度偏差
FUNCTION draw_DistanceMeasure_Deviation_FromHeight_InPitchs,c_x_change,c_y_change,height,Pitch_low,Pitch_high,h_offset
  colors=['r','g','b','c','m','y','k','a','b','c']  
  Pitchs = dindgen(Pitch_high - Pitch_low)
  Pitchs += Pitch_low + 1
  yaw  = 30
  roll = 0
  offsets = dindgen(Pitch_high - Pitch_low)
  plots = MAKE_ARRAY(height.LENGTH,1,/OBJ)
  for i = 0 ,height.LENGTH-1 do begin
      for j=0,Pitchs.LENGTH-1 do begin
          offsets(j)= cal_DistanceMeasure_Deviation_FromHeight(c_x_change,c_y_change,height[i],h_offset,yaw,Pitchs[j],roll);
      endfor  
      ;对象绘图
      if i eq 0 then begin
            plots[i] = plot(  Pitchs,$
                              offsets,$
                              thick = height.LENGTH - i,$
                              colors[i],$
                              Name = strcompress(STRING(height[i])+'米'),$
                              TITLE = strcompress(['摄像头方向角为'+String(yaw)+'°时，在各高度下相对高程定位偏差（'+STRING(h_offset)+'米）',$
                                                   '在屏幕竖直方向测量距离(屏幕竖向占比'+String(long((c_x_change^2+c_y_change^2)^0.5*100))+'%)时的误差']$
                                                   ),$
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
    POSITION=[Pitchs[Pitchs.LENGTH -1]-15,offsets[Pitchs.LENGTH -1]-0.001],/DATA, $
    ;POSITION=[1,1],/NORMAL,$
    ;POSITION=[100,100],/DEVICE,$
    font_name = 'Microsoft Yahei',$
    /AUTO_TEXT_COLOR $
    )
END

;绘制高度偏差造成的误差，不同高度下，
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



;绘制高度偏差造成的误差，距相片中心点不同水平距离，
;pitchs:      高度角数组
;height：                高度
;ccd_x_low:   最近
;ccd_x_high：    最远
;h_offset:    高度偏差
FUNCTION draw_Deviation_FromHeight_InCCD_Xs,pitchs,height,ccd_x_low,ccd_x_high,h_offset
  colors=['r','g','b','c','m','y','k','a','b','c']
  numPoints = 200
  ccd_x = dindgen(numPoints,start=1)
  ccd_x -=100
  yaw  = 30
  roll = 0
  offsets = dindgen(numPoints,start=1)
  plots = MAKE_ARRAY(pitchs.LENGTH,1,/OBJ)
  for i = 0 ,pitchs.LENGTH-1 do begin
    for j=0,ccd_x.LENGTH-1 do begin
      offsets(j)= cal_Deviation_From_CCD(ccd_x[j]/100,0.0,height,h_offset,yaw,Pitchs[i],roll);
    endfor
    ;对象绘图
    if i eq 0 then begin
      plots[i] = plot( ccd_x,$
        offsets,$
        thick = height.LENGTH - i,$
        colors[i],$
        Name = strcompress(STRING(pitchs[i])),$
        TITLE = strcompress(['摄像头方向角为'+String(yaw)+'°时，相对高程定位偏差（'+STRING(h_offset)+'米），各俯仰角状态下',$
                             '像素点距画面中心不同距离比例时的水平定位误差']),$
        xtitle = strcompress('偏离中心的比率（%）'+String(10b)+'左偏移为-，右偏移为+，在中心点位0，在图幅边界处为100%'),$
        ytitle = '误差距离（米）',$
        font_name = 'Microsoft Yahei' $
        )
    endif else begin
      plots[i] = plot(  ccd_x,$
        offsets,$
        thick = height.LENGTH - i,$
        colors[i],$
        Name = strcompress(STRING(pitchs[i])),$
        /OVERPLOT $
        )
    endelse
  endfor
  lege = legend($
    target = plots,$
    POSITION=[ccd_x[ccd_x.LENGTH -80],offsets[offsets.LENGTH -5]],/DATA, $
    ;POSITION=[1,1],/NORMAL,$
    ;POSITION=[100,100],/DEVICE,$
    font_name = 'Microsoft Yahei',$
    /AUTO_TEXT_COLOR $
    )
END


;绘制高度偏差造成的误差，距相片中心点不同竖直距离，
;pitchs:      高度角数组
;height：                高度
;ccd_y_low:   最近
;ccd_y_high：    最远
;h_offset:    高度偏差
FUNCTION draw_Deviation_FromHeight_InCCD_Ys,pitchs,height,ccd_y_low,ccd_y_high,h_offset
  colors=['r','g','b','c','m','y','k','a','b','c']
  numPoints = 200
  ccd_y = dindgen(numPoints,start=1)
  ccd_y -=100
  yaw  = 30
  roll = 0
  offsets = dindgen(numPoints,start=1)
  plots = MAKE_ARRAY(pitchs.LENGTH,1,/OBJ)
  for i = 0 ,pitchs.LENGTH-1 do begin
    for j=0,ccd_y.LENGTH-1 do begin
      offsets(j)= cal_Deviation_From_CCD(0.0,ccd_y[j]/100,height,h_offset,yaw,Pitchs[i],roll);
    endfor
    ;对象绘图
    if i eq 0 then begin
      plots[i] = plot( ccd_y,$
        offsets,$
        thick = height.LENGTH - i,$
        colors[i],$
        Name = strcompress(STRING(pitchs[i])),$
        TITLE = strcompress(['摄像头方向角为'+String(yaw)+'°时，相对高程定位偏差（'+STRING(h_offset)+'米），各俯仰角状态下',$
        '像素点距画面中心不同距离比例时的水平定位误差']),$
        xtitle = strcompress('偏离中心的比率（%）'+String(10b)+'向下偏移为-，向上偏移为+，在中心点位0，在图幅边界处为100%'),$
        ytitle = '误差距离（米）',$
        font_name = 'Microsoft Yahei' $
        )
    endif else begin
      plots[i] = plot(  ccd_y,$
        offsets,$
        thick = height.LENGTH - i,$
        colors[i],$
        Name = strcompress(STRING(pitchs[i])),$
        /OVERPLOT $
        )
    endelse
  endfor
  lege = legend($
    target = plots,$
    POSITION=[ccd_y[ccd_y.LENGTH -80],offsets[offsets.LENGTH -5]],/DATA, $
    ;POSITION=[1,1],/NORMAL,$
    ;POSITION=[100,100],/DEVICE,$
    font_name = 'Microsoft Yahei',$
    /AUTO_TEXT_COLOR $
    )
END


FUNCTION draw_deviations
   height_camera = [30,50,70,90,110]
   pitch_camera = [-90,-80,-70,-60,-50]
;   result = draw_Deviation_FromHeight_InPitchs(height_camera,-90,-50,10)
;   result = draw_Deviation_FromHeight_InHeights(pitch_camera,30,100,10)
   pitch_camera_ccd = [-90,-85,-80,-75,-70]
;   result = draw_Deviation_FromHeight_InCCD_Xs(pitch_camera_ccd,80,0.001,0.0095656747,10)
;   result = draw_Deviation_FromHeight_InCCD_Ys(pitch_camera_ccd,80,0.001,0.0095656747,10)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ccd_x_persent = [0.10,0.15,0.20,0.25,0.30,0.35,0.40]   
   ccd_y_persent = [0.10,0.15,0.20,0.25,0.30,0.35,0.40] 
   ccd_y_persent = [-0.10,-0.15,-0.20,-0.25,-0.30,-0.35,-0.40]  
   for i = 0,ccd_x_persent.LENGTH-1 do begin
      ;result = draw_DistanceMeasure_Deviation_FromHeight_InPitchs(ccd_x_persent[i],0.00,height_camera,-90.0,-70.0,10.0)      
      result = draw_DistanceMeasure_Deviation_FromHeight_InPitchs(0.00,ccd_y_persent[i],height_camera,-90.0,-70.0,10.0)
   endfor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;---------------绘制量算距离误差  ----距离误差（Y）、俯仰角（X）、量算距离占比（LINE）-------------
;   result = draw_DistanceMeasure_Deviation_FromHeight_InPitchs_InchangesCCDX(ccd_x_persent,0.00,80,-90.0,-70.0,10.0)   
;   result = draw_DistanceMeasure_Deviation_FromHeight_InPitchs_InchangesCCDY(0.00,ccd_y_persent,80,-90.0,-70.0,10.0)   
;   ccd_y_persent = [-0.10,-0.15,-0.20,-0.25,-0.30,-0.35,-0.40]
;   result = draw_DistanceMeasure_Deviation_FromHeight_InPitchs_InchangesCCDY(0.00,ccd_y_persent,80,-90.0,-70.0,10.0)

;;;;;;---------------绘制量算距离误差  ----距离误差（Y）、量算距离占比（X）、俯仰角（LINE）-------------
;   pitch_camera = [-90,-85,-80,-75,-70]
;   result = draw_DistanceMeasure_Deviation_FromHeight_InchangesCCDX_InPitchs(-40.0,40.0,0.00,90,pitch_camera,10.0)
;   result = draw_DistanceMeasure_Deviation_FromHeight_InchangesCCDY_InPitchs(0.00,-40.0,40.0,90,pitch_camera,10.0)
;   result = draw_DistanceMeasure_Deviation_FromHeight_InchangesCCDY_InPitchs(0.00,-40.0,-1,90,pitch_camera,10.0)
;   result = draw_DistanceMeasure_Deviation_FromHeight_InchangesCCDY_InPitchs(0.00,0.0,40.0,90,pitch_camera,10.0)
END
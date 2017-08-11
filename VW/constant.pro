PRO initial
  ;!PI = asin(1)*2.0
  ;飞机姿态
  defsysv,'!YAW_PLANE',  0.0            ;方向角
  defsysv,'!PITCH_PLANE',  -90.0         ;俯仰角
  defsysv,'!ROLL_PLANE',  0.0            ;翻滚角

  defsysv,'!aR',    6378136.49000000    ;地球长轴——单位：米
  defsysv,'!bR',    6356755.00000000    ;地球短轴——单位：米
  defsysv,'!x_G',   -0.01                 ;像平面坐标x——单位：米
  defsysv,'!y_G',   0.01                 ;像平面坐标y——单位：米
  defsysv,'!f_G',   0.00367             ;焦距——单位：米
  defsysv,'!H_G',   40.000000           ;行高——单位：米
  defsysv,'!LAT_G', 9.000001            ;纬度——单位：十进制°
  defsysv,'!LON_G', 108.000001          ;经度——单位：十进制°
  defsysv,'!ELE_G', 40.000000           ;海拔——单位：米
  
  defsysv,'!FOV_Horizontal', 105.0000   ;水平市场角
  defsysv,'!Fov_vertical', 90.00000     ;垂直视场角
  ;像平面坐标标轴姿态,飞机角度需要转换才能得到像平面坐标
  ;defsysv,'!YAW_G', !LAT_G + !PITCH_PLANE      ;绕x轴角度      单位：十进制°；
  ;defsysv,'!P_G',   !ROLL_PLANE                  ;绕y轴旋转角度     单位：十进制°；
  ;defsysv,'!R_G',   180+!YAW_PLANE              ;绕Z轴旋转角度      单位：十进制°；
  ;  defsysv,'!YAW_G', 180+!YAW_PLANE           ;绕z轴角度      单位：十进制°；
  ;  defsysv,'!P_G',   !LAT_G + !PITCH_PLANE     ;绕x轴旋转角度     单位：十进制°；
  ;  defsysv,'!R_G',   !ROLL_PLANE              ;绕y轴旋转角度      单位：十进制°；
END


;从"度"转换为"弧度"
function Convert_D2R, degrees
  ;radain = degrees*!PI/180
  ;radain = degrees*!DPI/180
  radain = degrees*!DTOR
  return, radain
END

;十进制°的sin
function sinD, degrees
  result = sin(Convert_D2R(degrees))
  return, result
END

;十进制°的cos
function cosD, degrees
  result = cos(Convert_D2R(degrees))
  return, result
END

;十进制°的tan
function tanD, degrees
  result = tan(Convert_D2R(degrees))
  return, result  
END


;计算两点间球面距离，单位：米
;B1，L1: 纬度、经度，单位：°
;B2，L2: 纬度、经度，单位：°
FUNCTION getDistanceOfCircle,B1,L1,B2,L2
  distance= !aR*acos(sinD(B1)*sinD(B2)+cosD(B1)*cosD(B2)*cosD(L1-L2))
  return, distance
END

;计算两点间平面直角距离，单位：米
;position: 原始位置坐标   单位：°
;position_OffSet: 偏移后位置坐标  单位：°
FUNCTION getDistanceCartesin,position,position_OffSet
  ;经纬度偏差
  offsetLogitude = position_OffSet["LONGITUDE"]-position["LONGITUDE"]
  offsetLatitude = position_OffSet["LATITUDE"]-position["LATITUDE"]
  ;当前纬度
  B_g = position["LATITUDE"]
  ;东西向距离
  x_distance = !aR*cosD(B_g)*(offsetLogitude*!DTOR);
  ;南北向距离
  y_distance = !aR*offsetLatitude*!DTOR
  ;平面距离
  distance = (x_distance^2+y_distance^2)^0.5
  return, distance
END
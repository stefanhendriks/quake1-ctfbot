//////////////////////
//do not alter this file
//////////////////////

float(string mname)SpawnWaypointsForMap1 = 
{
local float us;

	us = FALSE;

	if (mname == "___foo___")
	{
		return FALSE;
	}
	else if (mname == "ctf1")
	{
		SpawnWaypointNum('-1270.7 488.0 536.0', 5, 1, us);
		SpawnWaypointNum('-751.3 779.6 544', 5, -1, us);
		SpawnWaypointNum('719.2 -49.5 544', 14, -1, us);
		SpawnWaypointNum('4.1 1614.8 296.0', 5, 5, us);
		SpawnWaypointNum('-200.0 581.5 344.1', 5, 7, us);
		SpawnWaypointNum('259.2 1612.3 296.0', 5, 6, us);
		SpawnWaypointNum('-231.9 1649.6 296.0', 5, 6, us);
		SpawnWaypointNum('-29.5 -903.2 296.0', 14, 5, us);
		SpawnWaypointNum('798.8 144.1 536.0', 14, 2, us);
		SpawnWaypointNum('200.0 296.7 342.8', 14, 7, us);
		SpawnWaypointNum('-245.7 -871.0 296.0', 14, 6, us);
		SpawnWaypointNum('239.8 -873.6 296.0', 14, 6, us);
		SpawnWaypointNum('1359.9 -96 536', -1, 1, us);
		SpawnWaypointNum('1263.9 221.0 536.0', 14, 1, us);
		SpawnWaypointNum('-200.0 213.9 344.1', 14, 7, us);
		SpawnWaypointNum('1329.8 214.2 536', -1, 0, us);
		SpawnWaypointNum('-1336.8 505.3 536', -1, 0, us);
		SpawnWaypointNum('-1360 855.8 536', -1, 1, us);
		SpawnWaypointNum('-1.9 173.7 536.0', 14, 3, us);
		SpawnWaypointNum('-755.7 568.2 536.0', 5, 2, us);
		SpawnWaypointNum('4.1 1044.6 536.0', 5, 4, us);
		SpawnWaypointNum('200.0 562.1 344.5', 5, 7, us);
		SpawnWaypointNum('1334.8  14.7 706.2', 14, 0, us);
		SpawnWaypointNum('-1332.4 770.1 700.1', 5, 0, us);
		SpawnWaypointNum('-3.6 567.3 536.0', 5, 3, us);
		SpawnWaypointNum('-4.5 -266.5 536.0', 14, 4, us);
		return TRUE;
	}

	else if (mname == "ctf2")
	{
		SpawnWaypointNum('16 -621.1 193.4', -1, 0, us);
		SpawnWaypointNum('16 -527.2 197.5', -1, 0, us);
		SpawnWaypointNum('335.8 -986.7  40.0', 5, -1, us);
		SpawnWaypointNum('320.1 -191.3  40.0', 5, -1, us);
		SpawnWaypointNum('296.6 -1033.2 40', 5, 1, us);
		SpawnWaypointNum('190 -944.8 40', 5, 2, us);
		SpawnWaypointNum('188.2 -851.4 40', 5, 3, us);
		SpawnWaypointNum('90.6 -132.6 40', 14, 1, us);
		SpawnWaypointNum('201.1 -230.9 40', 14, 2, us);
		SpawnWaypointNum('199.5 -301.8 40', 14, 3, us);
		SpawnWaypointNum('269.6 -1262.4 -88', 5, 1, us);
		SpawnWaypointNum('193.6 -1176.2 -88', 5, 2, us);
		SpawnWaypointNum('192.5 -934.8 -88', 5, 3, us);
		SpawnWaypointNum('190.5 -853.9 -112', 5, 4, us);
		SpawnWaypointNum('116.7 81.4 -88', 14, 1, us);
		SpawnWaypointNum('205.7 8.4 -88', 14, 2, us);
		SpawnWaypointNum('190.8 -240.2 -88', 14, 3, us);
		SpawnWaypointNum('195.4 -321.7 -101', 14, 4, us);
		SpawnWaypointNum('257.2 -596 131', 5, 4, us);
		SpawnWaypointNum('310.1 -1264.3 40', 5, 0, us);
		SpawnWaypointNum('71.1 71.5 40', 14, 0, us);
		SpawnWaypointNum('16.0 -621.1 193.4', -1, 0, us);
		SpawnWaypointNum('16.0 -527.2 197.5', -1, 0, us);
		return TRUE;
	}
	else if (mname == "ctf3")
	{
		SpawnWaypointNum('-1547.1 -508.7 417.0', 5, -1, us);
		SpawnWaypointNum('1457.0 498.0 417.0', 5, -1, us);
		SpawnWaypointNum('-1649.9 9.5 136', 5, 0, us);
		SpawnWaypointNum('-1546 -7 136', 5, 1, us);
		SpawnWaypointNum('-1303 -191.2 153', 5, 2, us);
		SpawnWaypointNum('-828.3 18.5 216', 5, 3, us);
		SpawnWaypointNum('-603 4.1 168', 5, 5, us);
		SpawnWaypointNum('-471.2 162.3 136', 5, 6, us);
		SpawnWaypointNum('1299.2 197.2 153', 14, 2, us);
		SpawnWaypointNum('822.9 -15.2 216', 14, 3, us);
		SpawnWaypointNum('1533.9 -1 136', 14, 1, us);
		SpawnWaypointNum('1652.4 -15.6 136', 14, 0, us);
		SpawnWaypointNum('730.5 -9.2 216', 14, 4, us);
		SpawnWaypointNum('526.7 0.5 136', 14, 5, us);
		SpawnWaypointNum('523 150.8 136', 14, 6, us);
		SpawnWaypointNum('-731.1 0.4 216', 5, 4, us);
		SpawnWaypointNum('-1343.4 0.8 200.0', -1, 0, us);
		SpawnWaypointNum('-1260.1 0.5 -404.0', -1, 1, us);
		SpawnWaypointNum('-1152.2 6.2 -408.0', -1, 2, us);
		SpawnWaypointNum('-1055.0 -2.6 -216.0', -1, 3, us);
		SpawnWaypointNum('-710.6 -15.3 -264.0', -1, 4, us);
		SpawnWaypointNum('-270.0 -3.8 -328.0', -1, 5, us);
		SpawnWaypointNum('1344.6 -1.1 200.0', -1, 0, us);
		SpawnWaypointNum('1267.0 -4.8 -346.0', -1, 1, us);
		SpawnWaypointNum('1054.6 -2.9 -216.0', -1, 3, us);
		SpawnWaypointNum('823.3 -0.8 -216.0', -1, 4, us);
		SpawnWaypointNum('250.1 -4.7 -328.0', -1, 5, us);
		SpawnWaypointNum('1165.1 0.0 -408.0', -1, 2, us);
		return TRUE;
	}
	else if (mname == "ctf4")
	{
		SpawnWaypointNum(' 87.7 -1488.0 -176.0', 5, -1, us);
		SpawnWaypointNum('112.1 2704.0 -176.0', 14, -1, us);
		SpawnWaypointNum('95 -1760.3 -184', 5, 0, us);
		SpawnWaypointNum(' 92.2 -1508.3 -184', 5, 1, us);
		SpawnWaypointNum(' 92.6 -1375.7 -184', 5, 2, us);
		SpawnWaypointNum(' 92.6 -1072 -184', 5, 3, us);
		SpawnWaypointNum('356.8 -1101.7 -184', 5, 4, us);
		SpawnWaypointNum('-149 -1040.7 -184', 5, 4, us);
		SpawnWaypointNum('-139.6 -442.7 -184', 5, 5, us);
		SpawnWaypointNum('366.5 -463.8 -184', 5, 5, us);
		SpawnWaypointNum(' 92.7 -424.2 -184', 5, 6, us);
		SpawnWaypointNum(' 91.8 -209.1 -184', 5, 7, us);
		SpawnWaypointNum('-46.9 -230.4 -203.8', 5, 8, us);
		SpawnWaypointNum(' 75.3 213.1 -248', 5, 9, us);
		SpawnWaypointNum(' 29.9 339.3 -248', 5, 10, us);
		SpawnWaypointNum('166.5 418.4 -248', 5, 11, us);
		SpawnWaypointNum('128 -1953.6 72', 5, 1, us);
		SpawnWaypointNum('-180.4 -1938.3 56', 5, 2, us);
		SpawnWaypointNum('-153.4 -1171.3 56', 5, 3, us);
		
		SpawnWaypointNum('-155.4 2275.6 -184', 14, 4, us);
		SpawnWaypointNum('352.8 2259.1 -184', 14, 4, us);
		SpawnWaypointNum('100.5 2587.4 -184', 14, 2, us);
		SpawnWaypointNum(' 95.8 2911.7 -184', 14, 0, us);
		SpawnWaypointNum('100.5 2722.6 -184', 14, 1, us);
		SpawnWaypointNum('101.6 2301.4 -184', 14, 3, us);
		SpawnWaypointNum('334.6 1665.3 -184', 14, 5, us);
		SpawnWaypointNum('-173.4 1682.9 -184', 14, 5, us);
		SpawnWaypointNum('110.6 1642.1 -184', 14, 6, us);
		SpawnWaypointNum('105.7 1443 -184', 14, 7, us);
		SpawnWaypointNum('223.8 1456 -200.3', 14, 8, us);
		SpawnWaypointNum('102.1 1002.1 -248', 14, 9, us);
		SpawnWaypointNum('160.8 898.7 -248', 14, 10, us);
		SpawnWaypointNum(' 25.9 794.4 -248', 14, 11, us);
		SpawnWaypointNum('350.5 3159.2 56', 14, 2, us);
		SpawnWaypointNum(' 64.8 3179 72', 14, 1, us);
		SpawnWaypointNum('347.4 2377.5 40', 14, 3, us);
		return TRUE;
	}
	else if (mname == "ctf5")
	{
		SpawnWaypointNum('-2097.9 1541.7 -24', 5, 4, us);
		SpawnWaypointNum('-2002.7 1537.2 -24', 5, 5, us);
		SpawnWaypointNum('-1219.5 1510.3 -24', 5, 6, us);
		SpawnWaypointNum('-1188 2269.4 -24', 5, 7, us);
		SpawnWaypointNum('-1013.1 2257.5  20.8', 5, 8, us);
		SpawnWaypointNum('619.7 1531.2 -24', 14, 4, us);
		SpawnWaypointNum('513.7 1536.4 -24', 14, 5, us);
		SpawnWaypointNum('-239.1 1536.2 -24', 14, 6, us);
		SpawnWaypointNum('-270.9 2264.4 -24', 14, 7, us);
		SpawnWaypointNum('-621.6 2264.9 24', 14, 8, us);
		SpawnWaypointNum('-1642 1517.2 190', -1, 0, us);
		SpawnWaypointNum('182.8 1514.9 190', -1, 0, us);
		SpawnWaypointNum('570.6 1465.6 408', -1, 1, us);
		SpawnWaypointNum('-2055 1597.6 408', -1, 1, us);
		SpawnWaypointNum('-881.9 1632.9 -8', -1, 4, us);
		SpawnWaypointNum('-880.5 1412.5 152', -1, 5, us);
		SpawnWaypointNum('-731.3 1443.6 152', -1, 6, us);
		SpawnWaypointNum('-737.1 1035.1 152', -1, 7, us);
		SpawnWaypointNum('-728.3 855.5 216', -1, 8, us);
		SpawnWaypointNum('-2090.8 1863.6 -24.0', 5, 3, us);
		SpawnWaypointNum('-2374.1 1877.1 -24.0', 5, 2, us);
		SpawnWaypointNum('-2192.0 1522.0 -24.0', 5, 1, us);
		SpawnWaypointNum('-2682.5 1535.2 -24.0', 5, 0, us);
		SpawnWaypointNum('618.2 1216.1 -24.0', 14, 3, us);
		SpawnWaypointNum('919.9 1196.6 -24.0', 14, 2, us);
		SpawnWaypointNum('727.5 1548.9 -24.0', 14, 1, us);
		SpawnWaypointNum('1173.8 1537.1 -24.0', 14, 0, us);
		return TRUE;
	}
	else if (mname == "ctf6")
	{
		SpawnWaypointNum('-1614.6 667.8 -886.0', 5, -1, us);
		SpawnWaypointNum('-1605.2  84.1 -886.0', 5, -1, us);
		SpawnWaypointNum('-432.7 -46.4 -283.0', 14, -1, us);
		SpawnWaypointNum('-1883.1 876.7 -1175', 5, 4, us);
		SpawnWaypointNum('-1890.4 1241.5 -1175', 5, 5, us);
		SpawnWaypointNum('-1642.4 1243.7 -1175', 5, 6, us);
		SpawnWaypointNum('-1536.1 1243.7 -1175', 5, 7, us);
		SpawnWaypointNum('-1120.8 1240.1 -1175', 5, 8, us);
		SpawnWaypointNum('-2175.1 241.4 -575', 5, 9, us);
		SpawnWaypointNum('-2310.4 236.8 -575', 5, 10, us);
		SpawnWaypointNum('-2313.2 -721.5 -492', 5, 11, us);
		SpawnWaypointNum('-2044.9 -763.8 -492', 5, 12, us);
		SpawnWaypointNum('-2051.4 -339.4 -398', 5, 13, us);
		SpawnWaypointNum('-2046.3 -260.8 -398', 5, 14, us);
		SpawnWaypointNum('-1985.9 -55.8 -398', 5, 15, us);
		SpawnWaypointNum('-1442.8 -36 -328', 5, 16, us);
		SpawnWaypointNum('-1441.8 64 -328', 5, 17, us);
		SpawnWaypointNum('-1447.7 199.2 -328', 5, 18, us);
		SpawnWaypointNum('-1171.7 273.8 -328', 14, 7, us);
		SpawnWaypointNum('516.4 422.6 -36', 14, 2, us);
		SpawnWaypointNum('-391.2 403 -283', 14, 3, us);
		SpawnWaypointNum('-369.4 653.3 -283', 14, 4, us);
		SpawnWaypointNum('-1171.4 684.8 -328', 14, 5, us);
		SpawnWaypointNum('-1171.4 429.3 -328', 14, 6, us);
		SpawnWaypointNum('-1755.3 724 -1175', 5, 3, us);
		SpawnWaypointNum('-1061.6 707.8 -886', 5, 2, us);
		SpawnWaypointNum('-1015.8 454.9 -886', 5, 1, us);
		SpawnWaypointNum('515.7 -165.1 -36', 14, 1, us);
		SpawnWaypointNum('-660.1 -748.9 -283.0', 14, 3, us);
		SpawnWaypointNum('-786.0 -751.1 -283.0', 14, 4, us);
		SpawnWaypointNum('-1248.8 -743.3 -344.8', 14, 5, us);
		SpawnWaypointNum('-1723.0 -642.9 -260.0', 14, 6, us);
		SpawnWaypointNum('-1842.0 -639.8 -260.0', 14, 7, us);
		SpawnWaypointNum('-1851.9 -319.0 -260.0', 14, 8, us);
		SpawnWaypointNum('-1117.8 -59.0 230.9', -1, 0, us);
		SpawnWaypointNum('-355.7 -354.6 -283.0', 14, 1, us);
		SpawnWaypointNum('-420.2 -757.9 -283.0', 14, 2, us);
		return TRUE;
	}
	else if (mname == "ctf7")
	{
		SpawnWaypointNum('2484.1 -1809.0 256.0', 14, -1, us);
		SpawnWaypointNum('2481.6 405.7  48.0', 5, -1, us);
		SpawnWaypointNum('2492.3 692.3 -144', 5, 0, us);
		SpawnWaypointNum('2482.5 440.4 -144', 5, 1, us);
		SpawnWaypointNum('2476.7 334.2 -144', 5, 2, us);
		SpawnWaypointNum('2471.8  49.4 -240', 5, 3, us);
		SpawnWaypointNum('2476.2 -87.1 -240', 5, 4, us);
		SpawnWaypointNum('2454.3 -1154.7 -256', 14, 6, us);
		SpawnWaypointNum('2470.5 -833.7 -240', 14, 7, us);
		SpawnWaypointNum('2499.5 640.1 -144', 5, 0, us);
		SpawnWaypointNum('2477.4 448.9 -144', 5, 1, us);
		SpawnWaypointNum('2475.4 361.8 -144', 5, 2, us);
		SpawnWaypointNum('2488.9 70 -240', 5, 3, us);
		SpawnWaypointNum('2612.8 -430.4 -56', 5, 5, us);
		SpawnWaypointNum('2444.3 -1380.9 -32', 14, 4, us);
		SpawnWaypointNum('2486.7 -14.8 -240', 5, 4, us);
		SpawnWaypointNum('2325.2 -443 80', 5, 6, us);
		SpawnWaypointNum('2319.2 -471.1 80', 14, 6, us);
		SpawnWaypointNum('2476.2 -1762.9 64', 14, 2, us);
		SpawnWaypointNum('2480.2 -1452.1 -32', 14, 3, us);
		SpawnWaypointNum('2467.6 -1854 64', 14, 1, us);
		SpawnWaypointNum('2469.6 -2154.3 64', 14, 0, us);
		SpawnWaypointNum('2470.0 -1307.4 -24.0', 14, 5, us);
		return TRUE;
	}
	else if (mname == "ctf8")
	{
		SpawnWaypointNum('1663.4 -556.9 184.0', 5, -1, us);
		SpawnWaypointNum('-1138.6  53.2 200.0', 14, -1, us);
		SpawnWaypointNum('1385.4 -119.8 104', 5, 0, us);
		SpawnWaypointNum('1513.6 -603.5 40', 5, 1, us);
		SpawnWaypointNum('1982.5 -540.8 40', 5, 2, us);
		SpawnWaypointNum('1976.4 236.1 216', 5, 3, us);
		SpawnWaypointNum('1866.1 612.8 280', 5, 4, us);
		SpawnWaypointNum('1043.4 778.8 152', 5, 5, us);
		SpawnWaypointNum('1029.1 -58.4 152', 5, 6, us);
		SpawnWaypointNum('754.2 -34.4 152', 5, 7, us);
		SpawnWaypointNum('-1595.5 -84.9 136', 14, 0, us);
		SpawnWaypointNum('-1560.7 279.1 88', 14, 1, us);
		SpawnWaypointNum('-1287.2 305.1 40', 14, 2, us);
		SpawnWaypointNum('-1257.3 531.9 40', 14, 3, us);
		SpawnWaypointNum('-888.9 550 40', 14, 4, us);
		SpawnWaypointNum('-865.9 215.5 40', 14, 5, us);
		SpawnWaypointNum('-496.3 190.7 40', 14, 6, us);
		SpawnWaypointNum('-1143.1 -207.3 200', 14, 1, us);
		SpawnWaypointNum('-1145.1 43.4 200', 14, 2, us);
		SpawnWaypointNum('-871.8 23.2 200', 14, 3, us);
		SpawnWaypointNum('-890.6 -176.7 168', 14, 4, us);
		SpawnWaypointNum('-464.1 -195.9 40', 14, 5, us);
		SpawnWaypointNum('1078.2 -592.1 120', 5, 2, us);
		SpawnWaypointNum('651.6 -549.2 40', 5, 3, us);
		SpawnWaypointNum('1372.1 -592.6 40', 5, 1, us);
		SpawnWaypointNum('461.2 -89.1 40', 5, 4, us);
		SpawnWaypointNum('1269.7 353.0 216.0', -1, 0, us);
		SpawnWaypointNum('1661.9 798.8 152.0', -1, 1, us);
		SpawnWaypointNum('1253.4 -178.2 216.0', -1, 1, us);
		SpawnWaypointNum('622.9 -367.5 216.0', -1, 0, us);
		SpawnWaypointNum('950.9 -366.9 216.0', -1, 1, us);
		SpawnWaypointNum('1327.8 784.0 152.0', -1, 0, us);
		return TRUE;
	}
	else if (mname == "q1ctf3")
	{
		SpawnWaypointNum('2.3 -3663.5 -40', 5, 0, us);
		SpawnWaypointNum('263.1 -2465.7 40', 5, 3, us);
		SpawnWaypointNum('-324.3 -1031.2 40', 5, 7, us);
		SpawnWaypointNum('-264.5 -1789 44', 5, 5, us);
		SpawnWaypointNum('-257.3 -2180.1 44', 5, 4, us);
		SpawnWaypointNum('5.9 2768.4 -40', 14, 0, us);
		SpawnWaypointNum('-330.1 -3101.3   9.1', 5, 1, us);
		SpawnWaypointNum('-817.7 -527.1 40', 5, 8, us);
		SpawnWaypointNum('-470 -2484.3 40', 5, 2, us);
		SpawnWaypointNum('-251.2 -2455.2 40', 5, 3, us);
		SpawnWaypointNum('271.5 -2211.6 44', 5, 4, us);
		SpawnWaypointNum('463.6 -2480.3 40', 5, 2, us);
		SpawnWaypointNum('-267.7 -1657.6 40', 5, 6, us);
		SpawnWaypointNum('364.2 105.1 40', 14, 7, us);
		SpawnWaypointNum('307.6 -3097.6   9.3', 5, 1, us);
		SpawnWaypointNum('275.3 -1790.5 44', 5, 5, us);
		SpawnWaypointNum('261 1568.8 40', 14, 3, us);
		SpawnWaypointNum('-353.5 107.8 40', 14, 7, us);
		SpawnWaypointNum('292.6 -954.7 40', 5, 7, us);
		SpawnWaypointNum('269.3 -1640.6 40', 5, 6, us);
		SpawnWaypointNum('862.6 -565.3 40', 5, 8, us);
		SpawnWaypointNum('-192.0 1608.4 -216.0', -1, 3, us);
		SpawnWaypointNum('271 1304.4 44', 14, 4, us);
		SpawnWaypointNum('479.1 1578.1 40', 14, 2, us);
		SpawnWaypointNum('280.6 812.3 40', 14, 6, us);
		SpawnWaypointNum('-281.6 2203.7   9.1', 14, 1, us);
		SpawnWaypointNum('268.5 876.9 44', 14, 5, us);
		SpawnWaypointNum('777.6 -314.3 40', 14, 8, us);
		SpawnWaypointNum('-256.6 1562.9 40', 14, 3, us);
		SpawnWaypointNum('-487.5 1601.7 40', 14, 2, us);
		SpawnWaypointNum('-274.2 1314.7 44', 14, 4, us);
		SpawnWaypointNum('-282.6 874.8 44', 14, 5, us);
		SpawnWaypointNum('-290.5 749.8 40', 14, 6, us);
		SpawnWaypointNum('-776.1 -326.9 40', 14, 8, us);
		SpawnWaypointNum('6.4 1355.2 -88.0', -1, 1, us);
		SpawnWaypointNum('298.3 2905.3 -40.0', 14, -1, us);
		SpawnWaypointNum('274.3 2222.0   8.1', 14, 1, us);
		SpawnWaypointNum('10.6 2471.3 184.0', -1, 0, us);
		SpawnWaypointNum('-400.1 493.1 296.0', -1, 0, us);
		SpawnWaypointNum('292.9 -3763.0 -40.0', 5, -1, us);
		SpawnWaypointNum('-335.4 -3828.7 -40.0', 5, -1, us);
		SpawnWaypointNum('-423.8 2832.7 -40.0', 14, -1, us);
		SpawnWaypointNum('10.9 2412.6 160.0', -1, 1, us);
		SpawnWaypointNum('-866.8 -1273.6 176.0', -1, 2, us);
		SpawnWaypointNum('-540.6 336.0 296.0', -1, 1, us);
		SpawnWaypointNum('-348.3 1219.4  44.0', -1, 0, us);
		SpawnWaypointNum('-13.9 2224.0 -136.0', -1, 2, us);
		SpawnWaypointNum('203.2 1139.1  44.0', -1, 0, us);
		SpawnWaypointNum('23.8 1584.0 -216.0', -1, 2, us);
		SpawnWaypointNum('-832.5 1228.4 -88.0', -1, 2, us);
		SpawnWaypointNum('-432.0 1231.5 -88.0', -1, 1, us);
		SpawnWaypointNum('-937.4 1171.6 168.0', -1, 3, us);
		SpawnWaypointNum('470.1 528.8 296.0', -1, 0, us);
		SpawnWaypointNum('-516.7 -1298.1 296.0', -1, 1, us);
		SpawnWaypointNum('466.2 -1413.4 296.0', -1, 0, us);
		SpawnWaypointNum('-456.8 -1423.2 296.0', -1, 0, us);
		SpawnWaypointNum('507.5 385.9 296.0', -1, 1, us);
		SpawnWaypointNum('879.4 384.2 176.0', -1, 2, us);
		SpawnWaypointNum('-9.9 -3120.0 -136.0', -1, 2, us);
		SpawnWaypointNum('498.7 -2130.7 -88.0', -1, 1, us);
		SpawnWaypointNum('-208.8 -2062.9  44.0', -1, 0, us);
		SpawnWaypointNum('331.5 -2099.1  44.0', -1, 0, us);
		SpawnWaypointNum('527.5 -1277.3 296.0', -1, 1, us);
		SpawnWaypointNum('-11.8 -2480.0 -216.0', -1, 2, us);
		SpawnWaypointNum('11.2 -3369.0 184.0', -1, 0, us);
		SpawnWaypointNum('865.2 -2169.1 -88.0', -1, 2, us);
		SpawnWaypointNum('936.2 -2071.4 168.0', -1, 3, us);
		SpawnWaypointNum('6.5 -2232.1 -88.0', -1, 1, us);
		SpawnWaypointNum('190.9 -2463.0 -216.0', -1, 3, us);
		SpawnWaypointNum('9.3 -3312.9 160.0', -1, 1, us);
		SpawnWaypointNum('-17.8 -2633.8 -216.0', -1, 3, us);
		return TRUE;
	}
	if (mname == "start")
	{
		SpawnWaypointNum('543.6 1349 8', 5, 1, us);
		SpawnWaypointNum('535.2 460.4 40', 5, 0, us);
		SpawnWaypointNum('682.6 2329.1 104', -1, 0, us);
		SpawnWaypointNum('-70.8 2161.6 -312', 14, 1, us);
		SpawnWaypointNum('-167.7 1894.2 -344', 14, 2, us);
		SpawnWaypointNum('541.1 1492.4 44', 5, 2, us);
		SpawnWaypointNum('414.2 2165.1 104', -1, 0, us);
		SpawnWaypointNum('1273.5 1723.2 144', 5, 5, us);
		SpawnWaypointNum('524.5 1734.9 40', 5, 3, us);
		SpawnWaypointNum('1115.6 1726.4 144', 5, 4, us);
		SpawnWaypointNum('-393 1856.1 -344', 14, 3, us);
		SpawnWaypointNum('1538.4 2312.6 104', -1, 1, us);
		SpawnWaypointNum('355.8 2240.9 -216', 14, 0, us);
		SpawnWaypointNum('425.4 2361.4 104', -1, 1, us);
		SpawnWaypointNum('1495.5 2060.8 -152.0', 14, 5, us);
		SpawnWaypointNum('1485.3 1905.6 -152.0', 14, 6, us);
		SpawnWaypointNum('990.6 1938.4 -80.0', 14, 3, us);
		SpawnWaypointNum('993.7 2081.5 -80.0', 14, 4, us);
		return TRUE;
	}
	else if (mname == "e1m1")
	{
//		SpawnCTFBOTReplace();
//		SpawnArmor . . .etc.
		SpawnWaypointNum('857.2 2803.6 -40', 14, 8, us);
		SpawnWaypointNum('809.9 2074.9 -136', 14, 7, us);
		SpawnWaypointNum('1219.2 2019.1 -200', 14, 6, us);
		SpawnWaypointNum('1255.6 2456.3 -264', 14, 5, us);
		SpawnWaypointNum('475.2 370 40', 5, 1, us);
		SpawnWaypointNum('493.5 569.1 40', 5, 2, us);
		SpawnWaypointNum('288 571.4 40', 5, 3, us);
		SpawnWaypointNum('148 574.6 40', 5, 4, us);
		SpawnWaypointNum('-44 579.4 40', 5, 5, us);
		SpawnWaypointNum('-349.5 2147.2 -120', 5, 10, us);
		SpawnWaypointNum('387.6 2812 -40', 14, 9, us);
		SpawnWaypointNum('-110.8 2804.4 -56', 14, 10, us);
		SpawnWaypointNum('1311.4 1765.7 -392', 14, 2, us);
		SpawnWaypointNum('131.1 1719.9 -168', 5, 8, us);
		SpawnWaypointNum('130.7 1849.9 -168', 5, 9, us);
		SpawnWaypointNum('1308.8 1082 -240', 14, 1, us);
		SpawnWaypointNum('830.6 1771.7 -392', 14, 3, us);
		SpawnWaypointNum('836.9 2456.1 -328', 14, 4, us);
		SpawnWaypointNum('1314.6 876.4 -240', 14, 0, us);
		SpawnWaypointNum('-27.2 569.3 -192.0', 5, 6, us);
		SpawnWaypointNum('89.2 728.0 -184.0', 5, 7, us);
		return TRUE;
	}
	else if (mname == "e1m2")
	{
		// CTF Bot 1.3 waypoints by player

		SpawnWaypointNum('231.2 -49.6 336', 14, 3, us);
		SpawnWaypointNum('-79.1 286.3 336', 14, 2, us);
		SpawnWaypointNum('1499.4 1296.1 216', 5, 0, us);
		SpawnWaypointNum('1464.7 649.7 280', 5, 1, us);
		SpawnWaypointNum('1117.1 662.9 328', 5, 2, us);
		SpawnWaypointNum('1124.9 -147.5 336', 5, 3, us);
		SpawnWaypointNum('788.2 -126.5 336', 5, 4, us);
		SpawnWaypointNum('666.2 -124.4 336', 5, 5, us);
		SpawnWaypointNum('-90.4 -504.8 400', 14, 1, us);
		SpawnWaypointNum('232.3 -369.4 336', 14, 4, us);
		SpawnWaypointNum('-447.9 -497.8 496', 14, 0, us);
		SpawnWaypointNum('578 -346.2 336', 14, 5, us);
		SpawnWaypointNum('1597.3 -912 440', -1, 5, us);
		SpawnWaypointNum('429 -289.4 336', -1, 0, us);
		SpawnWaypointNum('433.6 -214.1 329.8', -1, 1, us);
		SpawnWaypointNum('581.8 -781.5 448', -1, 0, us);
		SpawnWaypointNum('578.9 -1223.3 448', -1, 1, us);
		SpawnWaypointNum('861.8 -1234.1 448', -1, 2, us);
		SpawnWaypointNum('885.6 -912 456', -1, 3, us);
		SpawnWaypointNum('1216.8 -912 456', -1, 4, us);
		SpawnWaypointNum('1709.9 -816.4 408', -1, 6, us);
		SpawnWaypointNum('1608.9 -712.7 376', -1, 7, us);
		SpawnWaypointNum('1462 -662.7 328', -1, 8, us);
		SpawnWaypointNum('433.3 410.4 280', -1, 2, us);
		SpawnWaypointNum('676.4 497.3 280', -1, 3, us);
		SpawnWaypointNum('733.1 717.4 216', -1, 4, us);
		SpawnWaypointNum('1104.6 710.3 104', -1, 5, us);
		SpawnWaypointNum('1103.9 246.8 104', -1, 6, us);
		SpawnWaypointNum('2072.0 -124.2 328.0', -1, 4, us);
		SpawnWaypointNum('1798.0 -553.7 296.0', -1, 0, us);
		SpawnWaypointNum('1421.6 417.2 336.0', -1, 1, us);
		SpawnWaypointNum('1369.4 -547.3 184.0', -1, 2, us);
		SpawnWaypointNum('1742.3 354.4 156.6', -1, 7, us);
		SpawnWaypointNum('1804.0 -133.8 184.0', -1, 6, us);
		SpawnWaypointNum('1694.0 -555.2 296.0', -1, 1, us);
		SpawnWaypointNum('2073.3 -141.5 184.0', -1, 5, us);
		SpawnWaypointNum('1440.5 -92.3 336.0', -1, 0, us);
		SpawnWaypointNum('1767.5 394.1 328.0', -1, 2, us);
		SpawnWaypointNum('2081.4 -386.3 184.0', -1, 4, us);
		SpawnWaypointNum('1794.9 -76.5 328.0', -1, 3, us);
		SpawnWaypointNum('1412.3 -371.8 184.0', -1, 3, us);
		SpawnWaypointNum('2046.1 -363.4 328.0', -1, 5, us);
		return TRUE;
	}
	else if (mname == "e1m3")
	{
		SpawnWaypointNum('1352.5 449.8 -116', 14, 0, us);
		SpawnWaypointNum('1355.5 327.7 -116', 14, 1, us);
		SpawnWaypointNum('1357 163.5 -120', 14, 2, us);
		SpawnWaypointNum('1623.2 130.6 -120', 14, 3, us);
		SpawnWaypointNum('1601.3 -316.5 -120', 14, 4, us);
		SpawnWaypointNum('1503.9 -326.7 -120', 14, 5, us);
		SpawnWaypointNum('1405.2 -353.1 -120', 14, 6, us);
		SpawnWaypointNum('1103.8 -347.3 -168', 14, 7, us);
		SpawnWaypointNum('775.3 -352.4 -272', 14, 8, us);
		SpawnWaypointNum('679.4 -252.9 -272', 14, 9, us);
		SpawnWaypointNum('395 -252.9 -272', 14, 10, us);
		SpawnWaypointNum('379.9 113.4 -168', 14, 11, us);
		SpawnWaypointNum('68.5 143.1 -168', 14, 12, us);
		SpawnWaypointNum('81.5 -105.5 -56', 14, 13, us);
		SpawnWaypointNum('69 -465.7 -168', 14, 14, us);
		SpawnWaypointNum('-230.9 -469.7 -72', 14, 15, us);
		SpawnWaypointNum('-246 -163.7 -56', 14, 16, us);
		SpawnWaypointNum('-459.7 -158.5 -56', 14, 17, us);
		SpawnWaypointNum('-834.2 -1760 120', 5, 0, us);
		SpawnWaypointNum('-189.2 -1806.5 128', 5, 1, us);
		SpawnWaypointNum('-178.2 -1451.8 128', 5, 2, us);
		SpawnWaypointNum('-392.7 -1257.3 88', 5, 3, us);
		SpawnWaypointNum('-526 -1254.1 88', 5, 4, us);
		SpawnWaypointNum('-948.8 -1258.7 8', 5, 5, us);
		SpawnWaypointNum('-948.5 -953.6 8', 5, 6, us);
		SpawnWaypointNum('-1212 -953.4 8', 5, 7, us);
		SpawnWaypointNum('-1201.2 -152 -56', 5, 8, us);
		SpawnWaypointNum('-744.3 -150.9 -64', 5, 9, us);
		SpawnWaypointNum('-1074.5 -646.8 -56', -1, 0, us);
		SpawnWaypointNum('-772 -250.5 -352', -1, 3, us);
		SpawnWaypointNum('-541.9 -344.9 -352', -1, 4, us);
		SpawnWaypointNum('-1370.6 -629 -56', -1, 1, us);
		SpawnWaypointNum('347.3 -601.1 -270.8', -1, 1, us);
		SpawnWaypointNum('-513.9 -627.6 -312', -1, 5, us);
		SpawnWaypointNum('-163.2 -700.4 -312', -1, 6, us);
		SpawnWaypointNum('90.7 -612.7 -272.0', -1, 2, us);
		SpawnWaypointNum('392.2 -463.1 -272.0', -1, 0, us);
		SpawnWaypointNum('-704.8 -310.6 -56.0', -1, 0, us);
		return TRUE;
	}
	else if (mname == "e1m4")
	{
		SpawnWaypointNum('898.3 2044.1 560', -1, 16, us);
		SpawnWaypointNum('698.4 1573.7 360', -1, 19, us);
		SpawnWaypointNum('720 2431.8 552', -1, 15, us);
		SpawnWaypointNum('-250.7 2074.8 1256', 5, 1, us);
		SpawnWaypointNum('685.2 2864 552', -1, 14, us);
		SpawnWaypointNum('711.5 2317.3 960', -1, 13, us);
		SpawnWaypointNum('1102.7 2312.4 960', -1, 12, us);
		SpawnWaypointNum('162.7 1430.1 928', 5, 9, us);
		SpawnWaypointNum('713.1 536.4 789', 14, 6, us);
		SpawnWaypointNum('481.9 -579.3 856', -1, 10, us);
		SpawnWaypointNum('1103 -481.9 1144', -1, 9, us);
		SpawnWaypointNum('1047 -250.4 1176', -1, 8, us);
		SpawnWaypointNum('1072 2534.9 960', -1, 11, us);
		SpawnWaypointNum('-254.8 1800 1192', 5, 2, us);
		SpawnWaypointNum('706.5 1381.3 952', -1, 1, us);
		SpawnWaypointNum('1089.6 735.1 1424', 14, 1, us);
		SpawnWaypointNum('697.2 641.8 1296', 14, 2, us);
		SpawnWaypointNum('652.5 452 1296', 14, 3, us);
		SpawnWaypointNum('357.1 165.2 912', 14, 4, us);
		SpawnWaypointNum('713.1 273.2 912', 14, 5, us);
		SpawnWaypointNum('702.9 693.2 846.6', 14, 7, us);
		SpawnWaypointNum('-96 1635 1144', 5, 3, us);
		SpawnWaypointNum('-241.5 1472 1096', 5, 4, us);
		SpawnWaypointNum('-416 1641.6 1016', 5, 5, us);
		SpawnWaypointNum('-256.3 1800 952', 5, 6, us);
		SpawnWaypointNum('-131.3 1637.7 920', 5, 7, us);
		SpawnWaypointNum('692.9 1084.1 360', -1, 20, us);
		SpawnWaypointNum('287.3 2301.4 960', -1, 10, us);
		SpawnWaypointNum('280.5 2022.7 960', -1, 9, us);
		SpawnWaypointNum('42.2 1612.9 920', 5, 8, us);
		SpawnWaypointNum('712.4 1801.2 560', -1, 18, us);
		SpawnWaypointNum('696.1 2037.2 560', -1, 17, us);
		SpawnWaypointNum('697.5 -215.5 1288', -1, 7, us);
		SpawnWaypointNum('1037.5 -530.3 856.0', -1, 2, us);
		SpawnWaypointNum('704.9 -67.6 920.0', -1, 0, us);
		SpawnWaypointNum('1036.2 -92.8 920.0', -1, 1, us);
		SpawnWaypointNum('712.6 1847.7 968.0', -1, 2, us);
		SpawnWaypointNum('720.3 1958.1 968.0', -1, 3, us);
		return TRUE;
	}	else if (mname == "e1m5")
	{
		SpawnWaypointNum('-801.2 735.6 168', 5, 13, us);
		SpawnWaypointNum('-582.2 724.3 168', 5, 12, us);
		SpawnWaypointNum('-316.8 1622.6 168', 14, 6, us);
		SpawnWaypointNum('68 2159 280', 14, 3, us);
		SpawnWaypointNum('58.3 1947.9 280', 14, 4, us);
		SpawnWaypointNum('-137.6 2552.5 360', 14, 1, us);
		SpawnWaypointNum('-755.5 2182.1 336', -1, 2, us);
		SpawnWaypointNum('162.2 2547 440', 14, 0, us);
		SpawnWaypointNum('112.6 1174.6 111', 5, 6, us);
		SpawnWaypointNum('-80.5 538.5 127', 5, 10, us);
		SpawnWaypointNum('-720.5 1116.1 168', 5, 14, us);
		SpawnWaypointNum('-146.4 2162 280', 14, 2, us);
		SpawnWaypointNum('-83.5 875.4 127', 5, 9, us);
		SpawnWaypointNum('-1215.5 1618.1 172', -1, 2, us);
		SpawnWaypointNum('-72.7 1025.4 119', 5, 8, us);
		SpawnWaypointNum('-68.6 1191.2 111', 5, 7, us);
		SpawnWaypointNum('-763.8 1759 168', -1, 0, us);
		SpawnWaypointNum('710.2 1718 32', 5, 0, us);
		SpawnWaypointNum('586.1 1955.4 32', 5, 1, us);
		SpawnWaypointNum('-779.9 1851.1 340', -1, 1, us);
		SpawnWaypointNum('-1216 1840 168', -1, 1, us);
		SpawnWaypointNum('136 1335.2 111', 5, 5, us);
		SpawnWaypointNum('-574.3 546.3 191', 5, 11, us);
		SpawnWaypointNum('-307.2 1977.8 232', 14, 5, us);
		SpawnWaypointNum('-1417.7 1485 168', -1, 3, us);
		SpawnWaypointNum('122.7 1658 32', 5, 4, us);
		SpawnWaypointNum('305.4 1968 32', 5, 2, us);
		SpawnWaypointNum('317.1 1648.7 32', 5, 3, us);
		SpawnWaypointNum('-559 1128.1 168', 5, 15, us);
		SpawnWaypointNum('-200.2 1655 -8', -1, 0, us);
		SpawnWaypointNum('-197.9 1304 -8', -1, 1, us);
		SpawnWaypointNum('-586.3 2498.2 312.0', -1, 4, us);
		SpawnWaypointNum('-482.1 2197.8 326.0', -1, 3, us);
		SpawnWaypointNum('-917.6 2506.4 199.5', -1, 5, us);
		SpawnWaypointNum('-968.2 2210.5 168.0', -1, 6, us);
		return TRUE;
	}	else if (mname == "e1m6")
	{
		SpawnWaypointNum('467.5 397 40', 5, 1, us);
		SpawnWaypointNum('-508.6 425.5 40', 14, 2, us);
		SpawnWaypointNum('-901.9 447.3 40', 14, 0, us);
		SpawnWaypointNum('-728.8 507 40', 14, 1, us);
		SpawnWaypointNum('680.9 284.5 36', 5, 0, us);
		SpawnWaypointNum('478 704.9 40', 5, 3, us);
		SpawnWaypointNum('-316.2 822.7 -216', -1, 0, us);
		SpawnWaypointNum('83.5 273.1  69.6', 5, 6, us);
		SpawnWaypointNum('-510.4 51 120', 14, 3, us);
		SpawnWaypointNum('-329.7 1034 -216', -1, 1, us);
		SpawnWaypointNum('209.1 729.3 40', 5, 4, us);
		SpawnWaypointNum('483.6 912 40', 5, 2, us);
		SpawnWaypointNum('272 465.9  67.5', 5, 5, us);
		SpawnWaypointNum('468.8 1512.9  40.0', -1, 6, us);
		SpawnWaypointNum('198.1 1307.2  40.0', -1, 4, us);
		SpawnWaypointNum('-19.0 1334.5 -296.0', -1, 2, us);
		SpawnWaypointNum('208.9 1513.4  40.0', -1, 5, us);
		SpawnWaypointNum('-267.0 1281.7  32.0', -1, 3, us);
		return TRUE;
	}
	else if (mname == "e1m7")
	{
		SpawnWaypointNum('-499.8  80.9  72.0', 14, 0, us);
		SpawnWaypointNum('-391.7  79.8 248.0', 14, 1, us);
		SpawnWaypointNum('1022.7  61.1 188.0', 5, 0, us);
		SpawnWaypointNum('-238.9  67.4 252.0', 14, 2, us);
		SpawnWaypointNum('-246.9 -221.4 248.0', 14, 3, us);
		SpawnWaypointNum('991.4 -234.9 232.0', 5, 1, us);
		SpawnWaypointNum('558.8 -243.0 232.0', 5, 2, us);
		SpawnWaypointNum('157.7 -231.9 232.0', 14, 4, us);
		return TRUE;
	}
	else if (mname == "e1m8")
	{
		SpawnWaypointNum('445.1 653.5  40.0', 14, 3, us);
		SpawnWaypointNum('133.5 -669.9 -661.5', -1, 1, us);
		SpawnWaypointNum('718.6 -710.9 381.8', 5, 1, us);
		SpawnWaypointNum('685.4 -115 40', 5, 3, us);
		SpawnWaypointNum('519.1 733.7 340.2', 14, 2, us);
		SpawnWaypointNum('594.7 -302.1 296', 5, 0, us);
		SpawnWaypointNum('548.5 -729.4 -80', -1, 0, us);
		SpawnWaypointNum('432  32.4  79.9', -1, 0, us);
		SpawnWaypointNum('1035.0 137.8  40.0', -1, 3, us);
		SpawnWaypointNum('996.2 -203.3 40', -1, 2, us);
		SpawnWaypointNum('1186.4 -517.8 48', -1, 0, us);
		SpawnWaypointNum('1234.3 -206.8 40', -1, 1, us);
		SpawnWaypointNum('977.8 -412.3 -80', -1, 0, us);
		SpawnWaypointNum('169.9 -594.3 40', -1, 0, us);
		SpawnWaypointNum('671.1 257.5 296.0', 14, 0, us);
		SpawnWaypointNum('688.4 497.0 192.0', 14, 1, us);
		SpawnWaypointNum('693.3 493.7  40.0', 14, 5, us);
		SpawnWaypointNum('448.1 510.0  40.0', 14, 4, us);
		SpawnWaypointNum('1281.5 -527.8 -696.0', -1, 0, us);
		SpawnWaypointNum('722.1 -667.2  88.0', 5, 2, us);
		return TRUE;
	}

	else if (mname == "e2m1")
	{
		SpawnWaypointNum('-19.0 432.5   8.0', 14, 2, us);
		SpawnWaypointNum('308.0 444.6  40.0', 14, 3, us);
		SpawnWaypointNum('-62.3 147.7 -24.0', 14, 1, us);
		SpawnWaypointNum('96.0 1079.4  77.1', 14, 4, us);
		SpawnWaypointNum('943.8 1072.2 204.9', 14, 5, us);
		SpawnWaypointNum('1616.0 819.0   8.0', -1, 4, us);
		SpawnWaypointNum('1230.6 696.3 152.0', 5, 6, us);
		SpawnWaypointNum('1726.3 381.6   8.0', -1, 1, us);
		SpawnWaypointNum('1741.5 674.9 264.0', 5, 1, us);
		SpawnWaypointNum('1283.8 1575.2 200.0', -1, 20, us);
		SpawnWaypointNum('1275.0 1024.8  80.0', -1, 12, us);
		SpawnWaypointNum('1904.0 -46.1 152.0', 5, 3, us);
		SpawnWaypointNum('1557.5 -119.7 152.0', 5, 4, us);
		SpawnWaypointNum('1232.9 -114.1 152.0', 5, 5, us);
		SpawnWaypointNum('2022.5 688.0 152.0', 5, 2, us);
		SpawnWaypointNum('2038.4 736.0   8.0', -1, 3, us);
		SpawnWaypointNum('1840.2 797.2  -8.0', -1, 2, us);
		SpawnWaypointNum('971.9 1597.8  40.0', -1, 17, us);
		SpawnWaypointNum('792.7 1569.6  40.0', -1, 16, us);
		SpawnWaypointNum('1276.9 1974.3 296.0', -1, 19, us);
		SpawnWaypointNum('944.0 1987.4 295.6', -1, 18, us);
		SpawnWaypointNum('572.6 518.0 -200.0', -1, 20, us);
		SpawnWaypointNum('796.7 1411.9  40.0', -1, 15, us);
		SpawnWaypointNum('1021.6 1015.0  40.0', -1, 14, us);
		SpawnWaypointNum('1204.9 1064.0  72.0', -1, 13, us);
		SpawnWaypointNum('1131.8 558.1 -216.0', -1, 20, us);
		SpawnWaypointNum('1450.1 653.9 264.0', -1, 11, us);
		SpawnWaypointNum('257.1  57.8 -136.0', -1, 18, us);
		SpawnWaypointNum('245.9 -190.6 -88.0', -1, 17, us);
		SpawnWaypointNum('565.3  41.3 -200.0', -1, 19, us);
		SpawnWaypointNum('363.3 -187.8 -56.5', -1, 16, us);
		SpawnWaypointNum('696.9 -194.1  40.0', -1, 15, us);
		SpawnWaypointNum('985.4 -201.3   8.0', -1, 14, us);
		SpawnWaypointNum('1054.0 404.6 -216.0', -1, 19, us);
		return TRUE;
	}
	else if (mname == "e2m2")
	{
		SpawnWaypointNum('1468.8 -150.9 -200', -1, 4, us);
		SpawnWaypointNum('480 541.7 40', 5, 7, us);
		SpawnWaypointNum('151.7 408 40', 5, 5, us);
		SpawnWaypointNum('138.1 104.8 64', 5, 4, us);
		SpawnWaypointNum('-115.3 1668.3 32', -1, 1, us);
		SpawnWaypointNum('159.1 -678.5 40', 5, 3, us);
		SpawnWaypointNum('480 384.1 40', 5, 6, us);
		SpawnWaypointNum('-237.2 -1262.6 200', 5, 1, us);
		SpawnWaypointNum('196.3 -1081.5 88', 5, 2, us);
		SpawnWaypointNum('178.7 549.1 40', 5, 8, us);
		SpawnWaypointNum('-176.9 921.3 40', -1, 2, us);
		SpawnWaypointNum('-276.4 -1608.7 248', 5, 0, us);
		SpawnWaypointNum('1200.7 -134.5 -200', -1, 6, us);
		SpawnWaypointNum('-178.3 519.6 -24', -1, 3, us);
		SpawnWaypointNum('-257.3 1061.1 32', -1, 3, us);
		SpawnWaypointNum('96.5 1691.4 40', -1, 0, us);
		SpawnWaypointNum('-825.1 957.9 80', -1, 0, us);
		SpawnWaypointNum('-464.8 291.7 -24', -1, 4, us);
		SpawnWaypointNum('1399.4 259.7 96', -1, 1, us);
		SpawnWaypointNum('-138.2 103 -88', -1, 2, us);
		SpawnWaypointNum('335.2 110.9 -80', -1, 0, us);
		SpawnWaypointNum('-39 336.1 144', -1, 6, us);
		SpawnWaypointNum('-199.9 320.2 144', -1, 5, us);
		SpawnWaypointNum('174.3 924.6 104', 5, 9, us);
		SpawnWaypointNum('1786.1 -186.8 -200', -1, 5, us);
		SpawnWaypointNum('1325.6 244.6 96', -1, 0, us);
		SpawnWaypointNum('1410.4 275.2 -192', -1, 2, us);
		SpawnWaypointNum('1483.6 280.9 -200', -1, 3, us);
		SpawnWaypointNum('2072 -307.7 296.2', 14, 0, us);
		SpawnWaypointNum('1240.3 54 127', 14, 1, us);
		SpawnWaypointNum('81.9 118.4 -88', -1, 1, us);
		SpawnWaypointNum('-521.4 1265 -88', -1, 6, us);
		SpawnWaypointNum('631.6 966.2  98.1', 14, 4, us);
		SpawnWaypointNum('-326.2 1470 -88', -1, 5, us);
		SpawnWaypointNum('-16 -176 -88', -1, 3, us);
		SpawnWaypointNum('275.7 -19.7 -88', -1, 2, us);
		SpawnWaypointNum('-391.1 1041.1 32', -1, 4, us);
		SpawnWaypointNum('-272.9 -473.4 -280', -1, 5, us);
		SpawnWaypointNum('-557.8 706.7 -88', -1, 7, us);
		SpawnWaypointNum('653.3 453.1 -88', -1, 4, us);
		SpawnWaypointNum('-281 -144 -235.9', -1, 4, us);
		SpawnWaypointNum('411.9 869.3 56', 14, 5, us);
		SpawnWaypointNum('1295.5 466.3 80', 14, 2, us);
		SpawnWaypointNum('-223.7 1017.1 144', -1, 7, us);
		SpawnWaypointNum('48.0 1272.1 167.5', -1, 0, us);
		SpawnWaypointNum('980.6 432.0  97.3', 14, 3, us);
		SpawnWaypointNum('621 157 -88', -1, 3, us);
		return TRUE;
	}
	else if (mname == "e2m3")
	{
		SpawnWaypointNum('195.3 951.6 -120', 5, 4, us);
		SpawnWaypointNum('40.2 1454.4 -152', 5, 0, us);
		SpawnWaypointNum('387.6 1416.3 -120', 5, 1, us);
		SpawnWaypointNum('-187.1 598.1 -104', 5, 6, us);
		SpawnWaypointNum('195.3 1258.3 -120', 5, 3, us);
		SpawnWaypointNum('374.1 1231.3 -120', 5, 2, us);
		SpawnWaypointNum('190.6 -1190.5 40', -1, 0, us);
		SpawnWaypointNum('167.3 710 160', 14, 3, us);
		SpawnWaypointNum('-117.2 1085.3 168', 5, 7, us);
		SpawnWaypointNum('-576.2 -275.6 104', 14, 0, us);
		SpawnWaypointNum('195.4 601.1 -120', 5, 5, us);
		SpawnWaypointNum('198 -288  -7.6', 14, 3, us);
		SpawnWaypointNum('508 -526.4 -24', 14, 5, us);
		SpawnWaypointNum('201.5 -1261.9 -187.7', -1, 0, us);
		SpawnWaypointNum('200.5 -546.5 -24', 14, 4, us);
		SpawnWaypointNum('186.9 -186.4 168', 14, 2, us);
		SpawnWaypointNum('-135.7 -171.2 168', 14, 1, us);
		SpawnWaypointNum('-135.4 -526.8 -24', 14, 5, us);
		SpawnWaypointNum('847.6 592.8 -136.0', -1, 1, us);
		SpawnWaypointNum('831.0  70.9 -136.0', -1, 2, us);
		SpawnWaypointNum('866.0 -291.8 232.0', -1, 1, us);
		SpawnWaypointNum('582.2 -214.9 200.0', -1, 0, us);
		SpawnWaypointNum('712.3 627.8 -136.0', -1, 0, us);
		SpawnWaypointNum('331.0 -208.6 -88.0', -1, 5, us);
		SpawnWaypointNum('604.5 -12.1 -91.0', -1, 3, us);
		SpawnWaypointNum('302.2 -43.6 -88.0', -1, 4, us);
		return TRUE;
	}

	else if (mname == "e2m4")
	{
		SpawnWaypointNum('1207 2752 472', -1, 5, us);
		SpawnWaypointNum('1449.5 1972.4 24', 5, 15, us);
		SpawnWaypointNum('799.3 454.1 72', 14, 3, us);
		SpawnWaypointNum('-442.5 1524.8 320', 5, 7, us);
		SpawnWaypointNum('190.4 1494 256.3', 5, 10, us);
		SpawnWaypointNum('-484.9 1967.4 448', 5, 6, us);
		SpawnWaypointNum('1062.6 241.2 296', 14, 1, us);
		SpawnWaypointNum('-1140 1726.5 472.5', 5, 1, us);
		SpawnWaypointNum('1420.8 1349.2 24', 14, 11, us);
		SpawnWaypointNum('1667.3 1341.9 24', 14, 10, us);
		SpawnWaypointNum('1419.4 965.1  18.6', 14, 9, us);
		SpawnWaypointNum('845.9 642.5 -152', 14, 6, us);
		SpawnWaypointNum('1331.5 242.4 360', 14, 0, us);
		SpawnWaypointNum('915.3 2567.7 312', -1, 4, us);
		SpawnWaypointNum('822.2 300.2 296', 14, 2, us);
		SpawnWaypointNum('-1391.2 1706.6 168', 5, 0, us);
		SpawnWaypointNum('1281 1988.8 24', 5, 14, us);
		SpawnWaypointNum('1601.5 1316.8 200', -1, 0, us);
		SpawnWaypointNum('826.5 2215.7 312', -1, 3, us);
		SpawnWaypointNum('1922.8 1404.1 120', -1, 1, us);
		SpawnWaypointNum('859.4 2012.8 176', -1, 2, us);
		SpawnWaypointNum('816 656  27.9', 14, 4, us);
		SpawnWaypointNum('1906.7 2003.2 176', -1, 2, us);
		SpawnWaypointNum('838.4 610.8  -9.7', 14, 5, us);
		SpawnWaypointNum('729.6 2033.5 24', -1, 0, us);
		SpawnWaypointNum('595.5 1667.1 120', 5, 11, us);
		SpawnWaypointNum('104.5 2069.8 232', -1, 0, us);
		SpawnWaypointNum('519.1 2043.8 232', -1, 1, us);
		SpawnWaypointNum('1303.7 1681.2 24', 5, 13, us);
		SpawnWaypointNum('940.6 1692.5 72', 5, 12, us);
		SpawnWaypointNum('-1014.5 1723.7 256', 5, 2, us);
		SpawnWaypointNum('-67.7 1688.8 272', 5, 8, us);
		SpawnWaypointNum('-146 1702.6 528', 5, 5, us);
		SpawnWaypointNum('-1066.8 1731.8 512', 5, 3, us);
		SpawnWaypointNum('-654.1 1713.4 568', 5, 4, us);
		SpawnWaypointNum('1241.7 932.9 -35.7', 14, 8, us);
		SpawnWaypointNum('102.3 1685.2 272', 5, 9, us);
		SpawnWaypointNum('1028.9 865.5 -152', 14, 7, us);
		SpawnWaypointNum('1049.7 1331.5 -24.0', -1, 8, us);
		SpawnWaypointNum('124.7 1368.1 232.0', -1, 1, us);
		SpawnWaypointNum('410.4 1197.2 232.0', -1, 3, us);
		SpawnWaypointNum('-340.5 1944.0 488.0', -1, 10, us);
		SpawnWaypointNum('105.0 1458.2 240.6', -1, 0, us);
		SpawnWaypointNum('289.3 1173.9 232.0', -1, 2, us);
		SpawnWaypointNum('440.1 1346.3 232.0', -1, 4, us);
		SpawnWaypointNum('245.8 1334.1  72.0', -1, 3, us);
		SpawnWaypointNum('359.0 1724.9  72.0', -1, 0, us);
		SpawnWaypointNum('630.1 1338.9  72.0', -1, 7, us);
		SpawnWaypointNum('394.4 1192.3  72.0', -1, 5, us);
		SpawnWaypointNum('85.2 1741.4  72.0', -1, 1, us);
		SpawnWaypointNum('95.8 1390.0  72.0', -1, 2, us);
		SpawnWaypointNum('415.1 1297.7  72.0', -1, 6, us);
		SpawnWaypointNum('267.5 1176.8  72.0', -1, 4, us);
		SpawnWaypointNum('1042.9 2463.2  24.0', -1, 2, us);
		SpawnWaypointNum('1204.3 1116.3 -24.0', -1, 9, us);
		SpawnWaypointNum('1274.9 1354.6 176.0', -1, 1, us);
		SpawnWaypointNum('1038.8 2172.6  24.0', -1, 1, us);
		SpawnWaypointNum('1264.0 1274.2 176.0', -1, 2, us);
		SpawnWaypointNum('902.7 2536.3  24.0', -1, 1, us);
		SpawnWaypointNum('1022.9 2027.0  24.0', -1, 0, us);
		SpawnWaypointNum('1143.5 2191.9  24.0', -1, 2, us);
		return TRUE;
	}//////////////////////
//do not alter this file
//////////////////////
	
	return FALSE;
};
//=============================================================
//=============================================================
float(string mname)SpawnWaypointsForMap2 = 
{
local float us;

	us = FALSE;

	if (mname == "___foo___")
	{
		return FALSE;
	}	else if (mname == "e2m5")
	{
		SpawnWaypointNum('452.5 429.8 -56', 5, 7, us);
		SpawnWaypointNum('-48.1 -220.8 8', 5, 4, us);
		SpawnWaypointNum('690.5 1407.7 -8', 5, 12, us);
		SpawnWaypointNum('54.6 3001.5 -16', 14, 3, us);
		SpawnWaypointNum('-400.9 -539.7 -152', 5, 3, us);
		SpawnWaypointNum('-703.4 -549.7 -152', 5, 2, us);
		SpawnWaypointNum('304.2 2068.8 72', 5, 16, us);
		SpawnWaypointNum('-726.8 2940.9 -32', 14, 1, us);
		SpawnWaypointNum('430.5 119.5 -8', 5, 6, us);
		SpawnWaypointNum('503.9 1722.4 72', 5, 14, us);
		SpawnWaypointNum('-769 -1186.4 -216', 5, 0, us);
		SpawnWaypointNum('-709.2 -787.8 -152', 5, 1, us);
		SpawnWaypointNum('481.3 1423.1 -8', 5, 13, us);
		SpawnWaypointNum('28.1 129.7 40', 5, 5, us);
		SpawnWaypointNum('214 440 -72', 5, 8, us);
		SpawnWaypointNum('-51.3 2171.6 -208', 14, 7, us);
		SpawnWaypointNum('73.8 2616.7 128', 14, 4, us);
		SpawnWaypointNum('263.8 1095.1 -56', 5, 9, us);
		SpawnWaypointNum('533.3 1116.5 40', 5, 10, us);
		SpawnWaypointNum('806.9 1132.1 -8', 5, 11, us);
		SpawnWaypointNum('524.4 2033.2 72', 5, 15, us);
		SpawnWaypointNum('-255.6 2800.9 -208', 14, 3, us);
		SpawnWaypointNum('-474.3 3021.1 -96', 14, 2, us);
		SpawnWaypointNum('-267.8 2601.2 240', 14, 5, us);
		SpawnWaypointNum('-254.1 2291.4 240', 14, 6, us);
		SpawnWaypointNum('-1135.5 2957.7 -48', 14, 0, us);
		SpawnWaypointNum('-250.3 2310 -208', 14, 6, us);
		SpawnWaypointNum('-56.3 2252.8 248', 14, 7, us);
		SpawnWaypointNum('-429.4 402.4 -56.0', -1, 2, us);
		SpawnWaypointNum('189.3 859.6 -72.0', -1, 0, us);
		SpawnWaypointNum('-351.5  64.0  -8.0', -1, 0, us);
		SpawnWaypointNum('-423.5 199.9  -8.0', -1, 1, us);
		SpawnWaypointNum('-264.2 2980.3 -96.0', -1, 0, us);
		SpawnWaypointNum('-199.6 446.6 -56.0', -1, 3, us);
		SpawnWaypointNum('191.8 547.5 -72.0', -1, 0, us);
		SpawnWaypointNum('170.3 1864.4 200.0', -1, 0, us);
		SpawnWaypointNum('103.9 1444.0  40.0', -1, 0, us);
		return TRUE;
	}	else if (mname == "e2m6")
	{
		SpawnWaypointNum('583.2 468 -488', 14, 9, us);
		SpawnWaypointNum('2943.2 -68.1 -600', -1, 0, us);
		SpawnWaypointNum('606.2 1300.3 -736', -1, 0, us);
		SpawnWaypointNum('951.4 1145.2 -728', -1, 2, us);
		SpawnWaypointNum('1190.4 1145.4 -984', 14, 0, us);
		SpawnWaypointNum('140.6 1283.4 -960', 14, 4, us);
		SpawnWaypointNum('2099.7 -221.1 -392', 5, 4, us);
		SpawnWaypointNum('2778.9 -137.9 -456', 5, 1, us);
		SpawnWaypointNum('2953.9 490 -376', -1, 4, us);
		SpawnWaypointNum('142.5 1309.7 -600', 14, 5, us);
		SpawnWaypointNum('2936 624 -340.4', -1, 3, us);
		SpawnWaypointNum('990.6 796.3 -472', 14, 11, us);
		SpawnWaypointNum('-205.6 496.1 -1032.0', -1, 3, us);
		SpawnWaypointNum('1071.9 486.6 -472', 14, 10, us);
		SpawnWaypointNum('400.0 -32.9 -472.0', -1, 1, us);
		SpawnWaypointNum('271.3 946.8 -536', 14, 7, us);
		SpawnWaypointNum('590.2 946.8 -472', 14, 8, us);
		SpawnWaypointNum('1099.6 813.2 -472.0', 14, 12, us);
		SpawnWaypointNum('2780.6 343.1 -664', -1, 2, us);
		SpawnWaypointNum('795.2 1313.2 -744', -1, 4, us);
		SpawnWaypointNum('814.8 1472.1 -744', -1, 5, us);
		SpawnWaypointNum('2982.7 226.1 -664', -1, 1, us);
		SpawnWaypointNum('973.7 1326.4 -736', -1, 3, us);
		SpawnWaypointNum('586 1134.7 -736', -1, 1, us);
		SpawnWaypointNum('602.9 1274.1 -536', -1, 0, us);
		SpawnWaypointNum('368 1140.4 -952', 14, 2, us);
		SpawnWaypointNum('345.4 1292.1 -952', 14, 3, us);
		SpawnWaypointNum('109.5 1128.9 -600', 14, 6, us);
		SpawnWaypointNum('2777.8 -368 -456', 5, 2, us);
		SpawnWaypointNum('610.6 1139.2 -928', 14, 1, us);
		SpawnWaypointNum('2241.9 -315.9 -424', 5, 3, us);
		SpawnWaypointNum('2637.7 104.6 -264', 5, 0, us);
		SpawnWaypointNum('1948.8 4 -340.8', 5, 5, us);
		SpawnWaypointNum('-901.1 503.2 -968.0', -1, 2, us);
		SpawnWaypointNum('1947.8 496.8 -576.0', 14, 14, us);
		SpawnWaypointNum('569.3  53.1 -472.0', -1, 0, us);
		SpawnWaypointNum('1630.7 288.0 -536.7', 14, 13, us);
		return TRUE;
	}
	else if (mname == "e2m7")
	{
		SpawnWaypointNum('1679.3 1210.7 -204', -1, 1, us);
		SpawnWaypointNum('989.9 1360.2 -152', -1, 1, us);
		SpawnWaypointNum('1242.2 2180.9 -152', 5, 2, us);
		SpawnWaypointNum('2224.9 1433.3 -188', 14, 2, us);
		SpawnWaypointNum('2578.6 1596.5 -188', 14, 4, us);
		SpawnWaypointNum('615 370.4 -192', -1, 4, us);
		SpawnWaypointNum('2156.9 1846.8 -188', 14, 6, us);
		SpawnWaypointNum('2558.3 1417 -188', 14, 3, us);
		SpawnWaypointNum('1215.6 1390.2 -152', -1, 2, us);
		SpawnWaypointNum('1815.9 1789.2 -312', 5, 6, us);
		SpawnWaypointNum('2209.3 1597.9 -188', 14, 5, us);
		SpawnWaypointNum('2149.1 2278.7 -316', 14, 7, us);
		SpawnWaypointNum('1801.2 2289.1 -316', 14, 8, us);
		SpawnWaypointNum('606.4 209.6 72', -1, 7, us);
		SpawnWaypointNum('2370.1 914.2 3', 14, 0, us);
		SpawnWaypointNum('227.2 189 -16', -1, 6, us);
		SpawnWaypointNum('9 1447.2 -192', -1, 2, us);
		SpawnWaypointNum('897.1 216.8 72', -1, 8, us);
		SpawnWaypointNum('0.6 359.2 -192', -1, 3, us);
		SpawnWaypointNum('877.6 -129.3 72', -1, 9, us);
		SpawnWaypointNum('1675 545.5 -92', -1, 3, us);
		SpawnWaypointNum('1690.9 737.2 -92', -1, 2, us);
		SpawnWaypointNum('671.9 167.9 -192', -1, 5, us);
		SpawnWaypointNum('1166.4 -120.8 24', -1, 10, us);
		SpawnWaypointNum('935.4 1798.9 -200', 5, 0, us);
		SpawnWaypointNum('270.1 1836.6 -192', -1, 0, us);
		SpawnWaypointNum('1007.6 1616.1 -152', -1, 0, us);
		SpawnWaypointNum('1874.6 1188.7 -204', -1, 0, us);
		SpawnWaypointNum('198.3 1431 -192', -1, 1, us);
		SpawnWaypointNum('2228.3 1290.1 -188', 14, 1, us);
		SpawnWaypointNum('2252.4 821.1 7', -1, 0, us);
		SpawnWaypointNum('1426.8 2203.3 -152', 5, 3, us);
		SpawnWaypointNum('1801.7 1483 -214.1', 5, 5, us);
		SpawnWaypointNum('1415.4 1572.5 -160', 5, 4, us);
		SpawnWaypointNum('1246.2 1807.9 -152', 5, 1, us);
		SpawnWaypointNum('2268.0 693.4   7.0', -1, 0, us);
		SpawnWaypointNum('2001.5 653.0   7.0', -1, 1, us);
		SpawnWaypointNum('1240.0 -826.2 -48.0', -1, 12, us);
		SpawnWaypointNum('1128.0 -698.0 -56.0', -1, 11, us);
		SpawnWaypointNum('1962.7 504.7   7.0', -1, 2, us);
		return TRUE;
	}	else if (mname == "e3m2")
	{
		SpawnWaypointNum('1392  27.4 40', 5, 2, us);
		SpawnWaypointNum('754.6 227.9 40', 5, 4, us);
		SpawnWaypointNum('1272.4  27.4 40', 5, 1, us);
		SpawnWaypointNum('153.6 115.9 -216', 14, 0, us);
		SpawnWaypointNum('761.6 514.7 40', 5, 5, us);
		SpawnWaypointNum('549.1 123.6 -216', 14, 1, us);
		SpawnWaypointNum('-127.9 -160 -24', 14, 6, us);
		SpawnWaypointNum('523.5 -397.5 -216', 14, 2, us);
		SpawnWaypointNum('184.1 -703.7 -24', 14, 4, us);
		SpawnWaypointNum('944 41 -168', 5, 0, us);
		SpawnWaypointNum('-385.6 302 40', 5, 8, us);
		SpawnWaypointNum('-396 514.6 40', 5, 7, us);
		SpawnWaypointNum('202.6 509.2 40', 5, 6, us);
		SpawnWaypointNum('1391 214.2 40', 5, 3, us);
		SpawnWaypointNum('-575.9 -234.2 232', -1, 0, us);
		SpawnWaypointNum('213.9 -101.4 -24', 14, 5, us);
		SpawnWaypointNum('-206.5 62 -24', 14, 7, us);
		SpawnWaypointNum('192.9 645.1 40', -1, 0, us);
		SpawnWaypointNum('304.8 673.3 40', -1, 1, us);
		SpawnWaypointNum('16 692.9 40', -1, 1, us);
		SpawnWaypointNum('652.8 -728.3 -24.0', 14, 3, us);
		return TRUE;
	}
	else if (mname == "e3m3")
	{
		SpawnWaypointNum('-513.8 -678.5 264', 5, 4, us);
		SpawnWaypointNum('1070.5 -132 -216', 14, 0, us);
		SpawnWaypointNum('1238.1 346.3 -216', 14, 2, us);
		SpawnWaypointNum('38.8 -544.5 36', 14, 10, us);
		SpawnWaypointNum('49 -772.5 112', 5, 10, us);
		SpawnWaypointNum('-767.7 -957.3 184', 5, 7, us);
		SpawnWaypointNum('-518.2 -1505.9 264', 5, 5, us);
		SpawnWaypointNum('1230.4 446.8 -88', 14, 6, us);
		SpawnWaypointNum('-848.8 -711.2 184', 5, 3, us);
		SpawnWaypointNum('-343.6 -1172.3 112', 5, 8, us);
		SpawnWaypointNum('1201.1 -29 -216', 14, 3, us);
		SpawnWaypointNum('1473 118 -184', 14, 4, us);
		SpawnWaypointNum('1052.1 342.8 -216', 14, 1, us);
		SpawnWaypointNum('-808 -1498.5 184', 5, 6, us);
		SpawnWaypointNum('49 -1171.5 112', 5, 9, us);
		SpawnWaypointNum('1226.6 -271.4 40', 14, 8, us);
		SpawnWaypointNum('1467.1 355.8 -88', 14, 5, us);
		SpawnWaypointNum('1231.5 118.5 40', 14, 7, us);
		SpawnWaypointNum('585.8 -329.8 40', -1, 0, us);
		SpawnWaypointNum('269.5 -256.1 40', 14, 9, us);
		SpawnWaypointNum('573.2 -728.9 184', -1, 1, us);
		SpawnWaypointNum('-826.2 365.1 184.0', 5, 0, us);
		return TRUE;
	}
	else if (mname == "e3m4")
	{
		SpawnWaypointNum('853.2 -588.9 -350', 5, 7, us);
		SpawnWaypointNum('681.7 -1997.9 216', 5, 1, us);
		SpawnWaypointNum('881.9 -583.8 -224', 5, 6, us);
		SpawnWaypointNum('671.6 -1184.8 40', 5, 3, us);
		SpawnWaypointNum('1089.3 -573.1 -359.1', 5, 8, us);
		SpawnWaypointNum('66.9 -1974.8 216', 5, 0, us);
		SpawnWaypointNum('681.7 -1727.3 216', 5, 2, us);
		SpawnWaypointNum('665.7 -566.1 -216', 5, 5, us);
		SpawnWaypointNum('582.1 -885.4 -216', 5, 4, us);
		SpawnWaypointNum('1293.3 -920.9 -124', 5, 11, us);
		SpawnWaypointNum('1087.2 -583.8 -197.9', 5, 9, us);
		SpawnWaypointNum('2258 -580 -24', 14, 2, us);
		SpawnWaypointNum('1524 -45.5 -24', -1, 0, us);
		SpawnWaypointNum('666.8 -57.1 -80.0', 5, 4, us);
		SpawnWaypointNum('1159.5 -795.2 -216', 5, 10, us);
		SpawnWaypointNum('2037.5 -1206 40', 14, 0, us);
		SpawnWaypointNum('877.6 -433.7 -88', -1, 0, us);
		SpawnWaypointNum('-181.8 -1017.4 -216.0', -1, 2, us);
		SpawnWaypointNum('2260 -1218.3 40', 14, 1, us);
		SpawnWaypointNum('224.3 -585.1 304', 14, 5, us);
		SpawnWaypointNum('1460.5 -1039 -32', 5, 12, us);
		SpawnWaypointNum('448.3  18.0 -88.0', 5, 2, us);
		SpawnWaypointNum('452.1 -60.8 -88.0', 5, 3, us);
		SpawnWaypointNum('1467.7 -597.5 -24.0', 14, 3, us);
		SpawnWaypointNum('84.0 -736.3 -216.0', -1, 0, us);
		SpawnWaypointNum('336.0 -741.4 -216.0', -1, 1, us);
		return TRUE;
	}
	else if (mname == "e3m5")
	{
		SpawnWaypointNum('615.7 -2590.4 -1216.0', -1, 0, us);
		SpawnWaypointNum('-767.1 -1373.9 552', 5, 5, us);
		SpawnWaypointNum('-545.8 -2088.8 552.0', 5, 9, us);
		SpawnWaypointNum('256.0 -1988.7 -242.0', 5, 10, us);
		SpawnWaypointNum('110.3 -1561.1 552', 5, 2, us);
		SpawnWaypointNum('1104.0 -2852.8 739.1', 14, 0, us);
		SpawnWaypointNum('-176.8 -1373.8 552', 5, 4, us);
		SpawnWaypointNum('2174.4 -2259.9 232.0', 14, 3, us);
		SpawnWaypointNum('-803.6 -1856.9 552', 5, 6, us);
		SpawnWaypointNum('609.5 -2240.6 -912.0', 5, 13, us);
		SpawnWaypointNum('-186.1 -1589.8 552', 5, 3, us);
		SpawnWaypointNum('-366.2 -2107.5 552', 5, 8, us);
		SpawnWaypointNum('1349.4 -1583.6 -136.0', -1, 1, us);
		SpawnWaypointNum('-347 -1924.2 552', 5, 7, us);
		SpawnWaypointNum('1451.4 -2304.4 -257.1', 14, 6, us);
		SpawnWaypointNum('642.9 -2262.8 -547.5', 5, 12, us);
		SpawnWaypointNum('310.5 -1996.4 -382.5', 5, 11, us);
		SpawnWaypointNum('1480.9 -2959.2 232.0', 14, 1, us);
		SpawnWaypointNum('2185.3 -2981.5 232.0', 14, 2, us);
		SpawnWaypointNum('1105.9 -2263.3 -88.0', 14, 5, us);
		SpawnWaypointNum('1401.8 -2317.8 -462.3', 14, 7, us);
		SpawnWaypointNum('1380.2 -2303.6 -912.0', 14, 8, us);
		SpawnWaypointNum('1665.7 -2269.1 232.0', 14, 4, us);
		SpawnWaypointNum('-56.0 -2268.5 1471.8', -1, 1, us);
		SpawnWaypointNum('469.2 -1585.4 -256.0', 14, 9, us);
		SpawnWaypointNum('598.6 -1081.9 1288.0', -1, 2, us);
		SpawnWaypointNum('-68.6 -2420.9 552.0', -1, 0, us);
		SpawnWaypointNum('497.8 -1802.7 488.0', 5, 1, us);
		SpawnWaypointNum('1457.1 -1574.7 -280.0', -1, 0, us);
		SpawnWaypointNum('219.1 -1629.2 776.0', 5, 0, us);
		return TRUE;
	}
	else if (mname == "e3m6")
	{
		SpawnWaypointNum('-1092.5 -975.0 120.0', 5, 2, us);
		SpawnWaypointNum('-1087.0 -751.4  40.0', 5, 1, us);
		SpawnWaypointNum('-1105.6 -1557.4 120.0', 5, 3, us);
		SpawnWaypointNum('288.8 -2336.4 232.0', 14, 2, us);
		SpawnWaypointNum('417.5 -360.7  40.0', 5, 9, us);
		SpawnWaypointNum('282.9 -1272.5 -120.0', 14, 7, us);
		SpawnWaypointNum('-1078.0 -384.8  40.0', 5, 0, us);
		SpawnWaypointNum('307.2 -2292.9 -142.6', 14, 4, us);
		SpawnWaypointNum('13.2 -2312.9 -184.0', 14, 3, us);
		SpawnWaypointNum('-589.5 -674.5  40.0', 5, 6, us);
		SpawnWaypointNum('304.1 -731.7  40.0', 5, 11, us);
		SpawnWaypointNum('18.5 -1633.1 -184.0', 14, 5, us);
		SpawnWaypointNum('-429.6 -363.9  40.0', 5, 8, us);
		SpawnWaypointNum('-419.3 -663.2  40.0', 5, 7, us);
		SpawnWaypointNum('-589.5 -1546.9 120.0', 5, 4, us);
		SpawnWaypointNum('-589.5 -1286.7 120.0', 5, 5, us);
		SpawnWaypointNum('293.5 -3033.4 184.0', 14, 1, us);
		SpawnWaypointNum('288.1 -1662.1 -184.0', 14, 6, us);
		SpawnWaypointNum('423.6 -663.9  40.0', 5, 10, us);
		SpawnWaypointNum('249.9 -3489.8 168.0', 14, 0, us);
		return TRUE;
	}              
	else if (mname == "e3m7")
	{
		SpawnWaypointNum('-1132.2 1354.5 -24', 14, 2, us);
		SpawnWaypointNum('205.6 291.1 40', 14, 10, us);
		SpawnWaypointNum('-493.3 -567.4 -88', 5, 7, us);
		SpawnWaypointNum('-720.7 648.4 56', 14, 8, us);
		SpawnWaypointNum('-1360.9 832.9 -24', 14, 4, us);
		SpawnWaypointNum('-1129.7 -100.9 -488', 5, 0, us);
		SpawnWaypointNum('-860.9 -276.3 -488', 5, 2, us);
		SpawnWaypointNum('-856.8 -108.6 -488', 5, 1, us);
		SpawnWaypointNum('-942.3 627.5 56', 14, 7, us);
		SpawnWaypointNum('-1177.8 842.7 -24', 14, 5, us);
		SpawnWaypointNum('-162.1 -232.4 40', 14, 12, us);
		SpawnWaypointNum('-722 279.3 40', 14, 9, us);
		SpawnWaypointNum('-1132 1644 -24', 14, 1, us);
		SpawnWaypointNum('-489.5 -176.0  -9.1', 5, 6, us);
		SpawnWaypointNum('209.5 -237.6 40', 14, 11, us);
		SpawnWaypointNum('-1195.2 633.7 -24', 14, 6, us);
		SpawnWaypointNum('-1392 1343.6 -24', 14, 3, us);
		SpawnWaypointNum('-318.1 -544.6 -88', 14, 14, us);
		SpawnWaypointNum('-162.7 -909.9 40', -1, 0, us);
		SpawnWaypointNum('-560 -471.5 -328', 5, 4, us);
		SpawnWaypointNum('-685.4 -232.2 -328', 5, 5, us);
		SpawnWaypointNum('-185.4 -688.0 136.3', 14, 13, us);
		SpawnWaypointNum('-1134.7 1323.5 240.0', 14, 0, us);
		SpawnWaypointNum('-775.1 -499.8 -256.0', 5, 3, us);
		return TRUE;
	}
	else if (mname == "e4m1")
	{
		SpawnWaypointNum('1309.6 424 312', 5, 0, us);
		SpawnWaypointNum('889.7 1442.6 460.0', -1, 9, us);
		SpawnWaypointNum('1997.6 1066.2 312.0', -1, 2, us);
		SpawnWaypointNum('2206.8 -291.4 216', 14, 2, us);
		SpawnWaypointNum('2168.5 -436.1 216', 14, 1, us);
		SpawnWaypointNum('1288.0 441.3 120.0', 5, 3, us);
		SpawnWaypointNum('1302.8 621.8 120.0', 5, 2, us);
		SpawnWaypointNum('1999.6 404.1 -40.7', 14, 5, us);
		SpawnWaypointNum('2031.8 -710.6 116', 14, 0, us);
		SpawnWaypointNum('1957.3 1806.9 200.0', -1, 3, us);
		SpawnWaypointNum('1384.5 1360.2 388.0', -1, 6, us);
		SpawnWaypointNum('2030.8 413.4 -125.2', 14, 6, us);
		SpawnWaypointNum('2053.7 -39.5 120', 14, 3, us);
		SpawnWaypointNum('1648.2 1819.8 200.0', -1, 4, us);
		SpawnWaypointNum('1678.8 1577.6 200.0', -1, 5, us);
		SpawnWaypointNum('877.2 1894.0 424.0', -1, 8, us);
		SpawnWaypointNum('1312 710.5 725.6', -1, 0, us);
		SpawnWaypointNum('1517.9 742 312', -1, 0, us);
		SpawnWaypointNum('1998.2 756.0 312.0', -1, 1, us);
		SpawnWaypointNum('1249.9 1853.5 388.0', -1, 7, us);
		SpawnWaypointNum('1708.1 431.3 124.1', 5, 4, us);
		SpawnWaypointNum('1633.4 423.0 -108.8', 5, 6, us);
		SpawnWaypointNum('1684.2 429.5  33.8', 5, 5, us);
		SpawnWaypointNum('1295.1 933.1 312.0', 5, 1, us);
		SpawnWaypointNum('2087.6 300.2  79.4', 14, 4, us);
		return TRUE;
	}
	else if (mname == "e4m2")
	{
		SpawnWaypointNum('-350.4 -516.8 392', 14, 7, us);
		SpawnWaypointNum('-180.1 -2308.6 552', 14, 0, us);
		SpawnWaypointNum('-109 -1896.6 477.8', 14, 1, us);
		SpawnWaypointNum('-401.0  -5.8 808.0', 5, 7, us);
		SpawnWaypointNum('-332.6 890.1 808.0', 5, 6, us);
		SpawnWaypointNum('219.8 -1934.5 408', 14, 2, us);
		SpawnWaypointNum('-163.7 694.2 808.0', 5, 3, us);
		SpawnWaypointNum('-45.7 -1585.5 392', 14, 4, us);
		SpawnWaypointNum('230 -1604.3 392', 14, 3, us);
		SpawnWaypointNum('-713 -498.7 392', 14, 8, us);
		SpawnWaypointNum('6.1 -1118.4 392', 14, 5, us);
		SpawnWaypointNum('-360.6 -1103.7 392', 14, 6, us);
		SpawnWaypointNum('-627.7 197.8 392', 14, 9, us);
		SpawnWaypointNum('-539.8 383.7 392', 14, 10, us);
		SpawnWaypointNum('-1514.9 -251.9 168', -1, 0, us);
		SpawnWaypointNum('442 -2357.6 552', -1, 0, us);
		SpawnWaypointNum('-113.3 -2416 852', -1, 0, us);
		SpawnWaypointNum('-510.3 -1554.5 392', -1, 0, us);
		SpawnWaypointNum('-352.6 -2756.3 552', -1, 0, us);
		SpawnWaypointNum('-385.6 -340.6 808', -1, 0, us);
		SpawnWaypointNum('-120.1 -2743.3 677.1', -1, 0, us);
		SpawnWaypointNum('10 115.9 1192', -1, 0, us);
		SpawnWaypointNum('10.2 375.6 808', 5, 1, us);
		SpawnWaypointNum('-15.7  23.8 808', 5, 0, us);
		SpawnWaypointNum('-430.7 -777.8 392.0', -1, 0, us);
		SpawnWaypointNum('83.0 876.1 808.0', 5, 5, us);
		SpawnWaypointNum('116.2 670.5 808.0', 5, 4, us);
		SpawnWaypointNum('-201.6 351.3 808.0', 5, 2, us);
		return TRUE;
	}
	else if (mname == "e4m3")
	{
		SpawnWaypointNum('1205.4 -1368.9 168.0', 5, 0, us);
		SpawnWaypointNum('105.6 -1312.1 172.0', 5, 1, us);
		SpawnWaypointNum('118.2 -523.4 168.0', 5, 2, us);
		SpawnWaypointNum('392.5 -519.4 168.0', 5, 3, us);
		SpawnWaypointNum('386.6 -768.8 168.0', 5, 4, us);
		SpawnWaypointNum('506.4 300.0  40.0', 5, 10, us);
		SpawnWaypointNum('758.9 247.0  40.0', 5, 11, us);
		SpawnWaypointNum('829.5 -647.3 168.0', 5, 6, us);
		SpawnWaypointNum('634.6 -776.5 168.0', 5, 5, us);
		SpawnWaypointNum('832.4 -330.2 168.0', 5, 7, us);
		SpawnWaypointNum('2361.4 572.2 -75.8', 14, 0, us);
		SpawnWaypointNum('2351.3  16.1 -88.0', 14, 1, us);
		SpawnWaypointNum('1005.0 -330.2 168.0', 5, 8, us);
		SpawnWaypointNum('1244.1 -24.0  24.0', 5, 10, us);
		SpawnWaypointNum('618.3 -583.0 168.0', 5, 6, us);
		SpawnWaypointNum('615.2 -287.0  40.0', 5, 7, us);
		SpawnWaypointNum('486.1 -19.2  40.0', 5, 9, us);
		SpawnWaypointNum('768.8 651.9  40.0', 5, 12, us);
		SpawnWaypointNum('785.0 1080.2 168.0', 5, 13, us);
		SpawnWaypointNum('2121.6  10.4 -72.0', 14, 2, us);
		SpawnWaypointNum('509.4 -160.7  40.0', 5, 8, us);
		SpawnWaypointNum('1984.2   6.0 -166.1', 14, 3, us);
		SpawnWaypointNum('1208.1 -529.7 168.0', 5, 9, us);
		SpawnWaypointNum('1674.4  -1.6 -160.4', 14, 4, us);
		SpawnWaypointNum('1856.1 -506.2 168.0', 5, 10, us);
		SpawnWaypointNum('1848.4  75.0 264.0', 5, 11, us);
		SpawnWaypointNum('1867.3 620.1 168.0', 5, 12, us);
		SpawnWaypointNum('1860.9 1033.9 168.0', 5, 13, us);
		SpawnWaypointNum('-263.5 254.5  72.0', 14, 9, us);
		SpawnWaypointNum('-265.2  54.8 168.0', 14, 10, us);
		SpawnWaypointNum('-245.0 -356.3 168.0', 14, 11, us);
		SpawnWaypointNum('1601.8  -6.9 -72.0', 14, 5, us);
		SpawnWaypointNum('1226.5 -28.7  24.0', 14, 6, us);
		SpawnWaypointNum('499.2 -10.7  40.0', 14, 7, us);
		SpawnWaypointNum('499.2 263.1  40.0', 14, 8, us);
		SpawnWaypointNum('-929.9 235.0 168.0', -1, 0, us);
		SpawnWaypointNum('-1209.8 261.1 168.0', -1, 1, us);
		SpawnWaypointNum('-563.0 -730.6 168.0', 14, 13, us);
		SpawnWaypointNum('-515.0 -317.2 168.0', 14, 12, us);
		SpawnWaypointNum('-938.2 -311.4 168.0', 14, 13, us);
		SpawnWaypointNum('-930.6 1084.1 168.0', 14, 14, us);
		SpawnWaypointNum('558.5 1046.0 168.0', 14, 15, us);
		SpawnWaypointNum('-286.8 407.6 168.0', 14, 10, us);
		SpawnWaypointNum('-261.2 1090.2 168.0', 14, 11, us);
		SpawnWaypointNum('-916.8 1484.1 168.0', -1, 0, us);
		SpawnWaypointNum('-1348.1 1460.7 168.0', -1, 1, us);
		SpawnWaypointNum('-1739.1 1446.3 168.0', -1, 2, us);
		SpawnWaypointNum('120.6 -744.3 168.0', 14, 14, us);
		SpawnWaypointNum('-1299.5 -749.3 168.0', -1, 0, us);
		SpawnWaypointNum('-1300.7 -330.5 168.0', -1, 1, us);
		SpawnWaypointNum('-1760.9 1963.7 168.0', -1, 3, us);
		SpawnWaypointNum('-1311.5 1958.9 168.0', -1, 4, us);
		return TRUE;
	}
	else if (mname == "e4m4")
	{
		SpawnWaypointNum('128.0 -911.7  40.0', 5, 12, us);
		SpawnWaypointNum('-856.9 -196.3 -88', 14, 9, us);
		SpawnWaypointNum('304 -1518.7 40', 14, 3, us);
		SpawnWaypointNum('537.8 -1696 40', 14, 2, us);
		SpawnWaypointNum('-106.7 132.9 152.0', 5, 8, us);
		SpawnWaypointNum('588.2 659.9  40.0', 5, 6, us);
		SpawnWaypointNum('432.1 -487.7  40.0', 5, 13, us);
		SpawnWaypointNum('900.5 -1495.3 40', 14, 0, us);
		SpawnWaypointNum('979.9 1076.7 56', 5, 0, us);
		SpawnWaypointNum('-95.5 -694.4  40.0', 5, 11, us);
		SpawnWaypointNum('845 1625.6 80', 5, 1, us);
		SpawnWaypointNum('-379.1 -289.5  40.0', 5, 10, us);
		SpawnWaypointNum('-1598.3 1102.4 176.0', -1, 3, us);
		SpawnWaypointNum('412.6 -195.7  40.0', 14, 13, us);
		SpawnWaypointNum('505 -1489.3 40', 14, 1, us);
		SpawnWaypointNum('-112.6 -226.9 -88', 14, 10, us);
		SpawnWaypointNum('-1270.1 -1498.6 40', 14, 6, us);
		SpawnWaypointNum('-1297 -1005.6 40', 14, 7, us);
		SpawnWaypointNum('-677.4 -1542.3 40', 14, 5, us);
		SpawnWaypointNum('-88.4 -1581.8 40', 14, 4, us);
		SpawnWaypointNum('-1334.7 -200.8 40', 14, 8, us);
		SpawnWaypointNum('-787.6 1493.6 192.0', -1, 1, us);
		SpawnWaypointNum('-110.2 238.6 -88', 14, 11, us);
		SpawnWaypointNum('-388 1485.2 244', -1, 0, us);
		SpawnWaypointNum('1469.8 -513.7 -88', -1, 1, us);
		SpawnWaypointNum('-806.1 1078.8 176', -1, 2, us);
		SpawnWaypointNum('-93.1 687.0 152.0', 5, 7, us);
		SpawnWaypointNum('-110.7 -1503.5 192', -1, 0, us);
		SpawnWaypointNum('-1589.2 -53.8 176.0', -1, 4, us);
		SpawnWaypointNum('766.6 -499.9 40', -1, 0, us);
		SpawnWaypointNum('225.6 235.6  40.0', 14, 12, us);
		SpawnWaypointNum('408.0 1053.6  56.0', 5, 5, us);
		SpawnWaypointNum('1481.6 259.5 -216.0', -1, 2, us);
		SpawnWaypointNum('-100.8 -274.7  40.0', 5, 9, us);
		SpawnWaypointNum('388.4 1483.3  56.0', 5, 3, us);
		SpawnWaypointNum('430.1 2042.7  88.0', 5, 2, us);
		SpawnWaypointNum('634.6 1281.2  56.0', 5, 4, us);
		return TRUE;
	}
	else if (mname == "e4m5")
	{
		SpawnWaypointNum('1230 -1156.4 104', -1, 1, us);
		SpawnWaypointNum('1250.4 369.4 136', 5, 9, us);
		SpawnWaypointNum('-2829.7 -1764.3 -248', 14, 0, us);
		SpawnWaypointNum('-1798.4 -1619.2 -360', 14, 5, us);
		SpawnWaypointNum('-2425.8 -1934.2 -248', 14, 2, us);
		SpawnWaypointNum('-930.6 -1873.7 -136', 14, 9, us);
		SpawnWaypointNum('1421.8 1585.8 136', 5, 2, us);
		SpawnWaypointNum('1528.3 561.1 136', 5, 7, us);
		SpawnWaypointNum('1218.1 1383.6 136', 5, 4, us);
		SpawnWaypointNum('1245.7 2199.4 136', 5, 0, us);
		SpawnWaypointNum('1249.8 1583.6 136', 5, 1, us);
		SpawnWaypointNum('-202.7 -1457.8  72.0', 5, 18, us);
		SpawnWaypointNum('1422.7 1387.7 136', 5, 3, us);
		SpawnWaypointNum('874.5 334.6 136', 5, 10, us);
		SpawnWaypointNum('1244.4 896.9 136', 5, 5, us);
		SpawnWaypointNum('1552.9 904.4 136', 5, 6, us);
		SpawnWaypointNum('809  91.3 40', 5, 12, us);
		SpawnWaypointNum('1275.7 557.5 136', 5, 8, us);
		SpawnWaypointNum('-211.4 -912.5 104.0', 5, 17, us);
		SpawnWaypointNum('859 206.8 136', 5, 11, us);
		SpawnWaypointNum('-26.3 -324.7  40.0', 5, 15, us);
		SpawnWaypointNum('576.6 106.8 40', 5, 13, us);
		SpawnWaypointNum('-2192.2 -1601.3 -248', 14, 4, us);
		SpawnWaypointNum('-1475 -1011 -248', 14, 7, us);
		SpawnWaypointNum('-921.6 -977.9 -248', 14, 8, us);
		SpawnWaypointNum('-439.7 -1428.0 -56.0', 5, 20, us);
		SpawnWaypointNum('-2436.5 -1764.3 -248', 14, 1, us);
		SpawnWaypointNum('-2449.8 -1313.2 -232', -1, 0, us);
		SpawnWaypointNum('-2185.6 -1940 -248', 14, 3, us);
		SpawnWaypointNum('-421 -1885.9 -56', 14, 10, us);
		SpawnWaypointNum('-1420.4 -1621.5 -360', 14, 6, us);
		SpawnWaypointNum('-1455.9 -2145.6 -248', -1, 0, us);
		SpawnWaypointNum('-94.6 -1424.7 184', -1, 0, us);
		SpawnWaypointNum('1920 -560 40', -1, 1, us);
		SpawnWaypointNum('1231.9 -687.6 104', -1, 0, us);
		SpawnWaypointNum('1904 -222.1 40', -1, 2, us);
		SpawnWaypointNum('552.5 -237.4  40.0', 5, 14, us);
		SpawnWaypointNum('-69.2 -905.5 104.0', 5, 16, us);
		SpawnWaypointNum('-482.3 -1439.8  64.0', 5, 19, us);
		return TRUE;
	}
	else if (mname == "e4m6")
	{
		SpawnWaypointNum('765.2 1295.5 216.0', 5, 3, us);
		SpawnWaypointNum('918.1 -559.2 -88.0', 14, 15, us);
		SpawnWaypointNum('634.3 -1125.9  56.0', 14, 10, us);
		SpawnWaypointNum('-766.6 -1428.1 -88.0', 14, 0, us);
		SpawnWaypointNum('610.8 -229.6  40.0', -1, 1, us);
		SpawnWaypointNum('164.2 -1835.8 224.0', -1, 4, us);
		SpawnWaypointNum('906.1 -239.8 -232.0', 14, 16, us);
		SpawnWaypointNum('322.7 -942.6 256.0', -1, 3, us);
		SpawnWaypointNum('833.8 310.8 296.0', -1, 0, us);
		SpawnWaypointNum('685.8  25.1 -232.0', 14, 17, us);
		SpawnWaypointNum('-764.5 -572.4  24.0', 14, 2, us);
		SpawnWaypointNum('1279.1 292.2  40.0', -1, 5, us);
		SpawnWaypointNum('644.4 -871.6  40.0', 14, 12, us);
		SpawnWaypointNum('1040.0 330.3 -88.0', -1, 3, us);
		SpawnWaypointNum('-336.1 -560.6  24.0', 14, 5, us);
		SpawnWaypointNum('-8.6 1632.1  40.0', 5, 1, us);
		SpawnWaypointNum('776.2 1072.1 360.0', 5, 4, us);
		SpawnWaypointNum('466.7 1686.9  40.0', 5, 0, us);
		SpawnWaypointNum('-305.1 603.4 -56.0', 5, 3, us);
		SpawnWaypointNum('-298.0 864.3  40.0', 5, 2, us);
		SpawnWaypointNum('550.5 1831.0 216.0', 5, 1, us);
		SpawnWaypointNum('738.0 1897.8 216.0', 5, 2, us);
		SpawnWaypointNum('1026.0 319.5 296.0', -1, 1, us);
		SpawnWaypointNum('-56.3 501.6 168.0', 5, 6, us);
		SpawnWaypointNum('774.1 631.0 364.0', 5, 5, us);
		SpawnWaypointNum('-321.4 531.2 -39.2', 5, 4, us);
		SpawnWaypointNum('2445.2 433.6 139.1', -1, 8, us);
		SpawnWaypointNum('1131.6 329.6 242.0', -1, 2, us);
		SpawnWaypointNum('-322.9 486.2 126.7', 5, 5, us);
		SpawnWaypointNum('2183.6 338.5 160.0', -1, 6, us);
		SpawnWaypointNum('606.5 -567.1  40.0', -1, 0, us);
		SpawnWaypointNum('-571.7 -579.2 138.4', 14, 3, us);
		SpawnWaypointNum('-771.0 -1011.3  24.0', 14, 1, us);
		SpawnWaypointNum('-380.4 -399.3  24.0', 14, 4, us);
		SpawnWaypointNum('1256.6 297.5 -65.4', -1, 4, us);
		SpawnWaypointNum('-16.3 -892.9  56.0', 14, 7, us);
		SpawnWaypointNum('2476.6 330.1 144.0', -1, 7, us);
		SpawnWaypointNum('208.0 -304.5 184.0', -1, 2, us);
		SpawnWaypointNum('2242.3 525.6 128.0', -1, 9, us);
		SpawnWaypointNum('750.2 -685.2 -88.0', 14, 14, us);
		SpawnWaypointNum('-205.9 -1158.1  56.0', 14, 9, us);
		SpawnWaypointNum('-9.4 -611.6  40.0', 14, 6, us);
		SpawnWaypointNum('689.9 -782.5  40.0', 14, 13, us);
		SpawnWaypointNum('-192.5 -857.0  56.0', 14, 8, us);
		SpawnWaypointNum('3.9  76.9  72.0', 14, 8, us);
		SpawnWaypointNum('629.0 -1015.1  56.0', 14, 11, us);
		SpawnWaypointNum('-415.1 -272.0 -88.0', 14, 5, us);
		SpawnWaypointNum('699.2 299.1 -232.0', 14, 18, us);
		SpawnWaypointNum('745.1 368.2 -100.1', 14, 19, us);
		SpawnWaypointNum('-430.3  97.6 -87.9', 14, 6, us);
		SpawnWaypointNum('-315.5  57.4  72.0', 14, 7, us);
		SpawnWaypointNum('592.0 369.9   4.0', 14, 20, us);
		return TRUE;
	}	else if (mname == "e4m7")
	{
		SpawnWaypointNum('-1052.9 -279.6 -96', 5, 0, us);
		SpawnWaypointNum('-37.4 -1853.5 40', 14, 2, us);
		SpawnWaypointNum('-1004.4 -1474 42', 14, 6, us);
		SpawnWaypointNum('-381.7 -999.1 40', 14, 4, us);
		SpawnWaypointNum('-2045.9 -337.4 -40', 5, 5, us);
		SpawnWaypointNum('-1487.5 187.8 -136', 5, 3, us);
		SpawnWaypointNum('813.9 -1880.9 232', 14, 0, us);
		SpawnWaypointNum('-1034.6 200.1 -136', 5, 2, us);
		SpawnWaypointNum('-2341.4 -793.7 42', 5, 7, us);
		SpawnWaypointNum('-1462.1 -329.4 -40', 5, 4, us);
		SpawnWaypointNum('-2331.7 -1138.5 104', 5, 8, us);
		SpawnWaypointNum('-2013.2 -786.8 42', 5, 6, us);
		SpawnWaypointNum('349.6 -1882 40', 14, 1, us);
		SpawnWaypointNum('-37.4 -956.2 40', 14, 3, us);
		SpawnWaypointNum('-2332.4 -1517 40', 14, 10, us);
		SpawnWaypointNum('-2371.7 -2002.2 42', 14, 9, us);
		SpawnWaypointNum('-985.4 -1008.1 40', 14, 5, us);
		SpawnWaypointNum('-996.3 -2045 -48', 14, 7, us);
		SpawnWaypointNum('-1517.3 -2030.8 42', 14, 8, us);
		SpawnWaypointNum('-221.9 1130.2 -72.0', -1, 3, us);
		SpawnWaypointNum('193.9 -626.6 -72.0', -1, 3, us);
		SpawnWaypointNum('-123.2 -617.9  42.0', -1, 1, us);
		SpawnWaypointNum('-1045.6  59.9 -88', 5, 1, us);
		SpawnWaypointNum('609.5 -399.4  40.0', -1, 6, us);
		SpawnWaypointNum('-1048.6 672.4 -232', -1, 0, us);
		SpawnWaypointNum('-342.3 -629.8 42', -1, 0, us);
		SpawnWaypointNum('321.2   0.4  66.8', -1, 5, us);
		SpawnWaypointNum('-700.2 1122.6 -152.0', -1, 2, us);
		SpawnWaypointNum('60.0 -621.5 -24.0', -1, 2, us);
		SpawnWaypointNum('196.3 -342.9 -148.0', -1, 4, us);
		SpawnWaypointNum('-682.3 640.2 -232.0', -1, 1, us);
		return TRUE;
	}
	else if (mname == "e4m8")
	{
		SpawnWaypointNum('2951.8 549.5 208.0', -1, 0, us);
		SpawnWaypointNum('1336.3 931.1  40.0', 5, 5, us);
		SpawnWaypointNum('1335.0 1589.2 -88.0', 5, 6, us);
		SpawnWaypointNum('2462.2 1570.3 -88.0', 5, 8, us);
		SpawnWaypointNum('1398.6 457.6 144.0', -1, 2, us);
		SpawnWaypointNum('2446.4 923.5  40.0', 5, 10, us);
		SpawnWaypointNum('1661.9 162.8  40.0', -1, 3, us);
		SpawnWaypointNum('1554.1 -353.1 -408.0', -1, 5, us);
		SpawnWaypointNum('878.7 422.9 302.3', -1, 3, us);
		SpawnWaypointNum('1462.9 1094.6 168.0', -1, 0, us);
		SpawnWaypointNum('1368.8  -5.1  40.0', -1, 5, us);
		SpawnWaypointNum('1888.8 1576.1 -88.0', 5, 7, us);
		SpawnWaypointNum('1607.2 -819.8 120.0', 14, 3, us);
		SpawnWaypointNum('2278.5   2.5  40.0', 14, 6, us);
		SpawnWaypointNum('2036.1 917.7  40.0', 14, 11, us);
		SpawnWaypointNum('1860.9  -1.6  40.0', 14, 5, us);
		SpawnWaypointNum('1475.7 -2294.7  40.0', 14, 1, us);
		SpawnWaypointNum('1853.8 -205.7  40.0', 14, 4, us);
		SpawnWaypointNum('1656.3 -1886.6  40.0', 14, 0, us);
		SpawnWaypointNum('1937.5 -1011.5 120.0', 14, 2, us);
		SpawnWaypointNum('2291.7 -882.1 120.0', 14, 3, us);
		SpawnWaypointNum('-252.7 201.6 -88.0', 5, 1, us);
		SpawnWaypointNum('1960.6 166.1  40.0', 14, 8, us);
		SpawnWaypointNum('365.0 946.7  40.0', 5, 4, us);
		SpawnWaypointNum('1452.1 857.3  40.0', -1, 0, us);
		SpawnWaypointNum('1577.7 -28.0  40.0', -1, 4, us);
		SpawnWaypointNum('1097.3 -743.8 -152.0', -1, 3, us);
		SpawnWaypointNum('2246.2 149.9  40.0', 14, 7, us);
		SpawnWaypointNum('1844.4 674.0  40.0', 14, 9, us);
		SpawnWaypointNum('-488.3 378.3 -88.0', 5, 0, us);
		SpawnWaypointNum('2047.7 682.2  40.0', 14, 10, us);
		SpawnWaypointNum('1398.9 927.9 168.0', -1, 0, us);
		SpawnWaypointNum('265.4 138.0 -88.0', 5, 2, us);
		SpawnWaypointNum('314.2 654.0  40.0', 5, 3, us);
		SpawnWaypointNum('2456.0 1154.7  40.0', 5, 9, us);
		SpawnWaypointNum('1487.1 218.1  40.0', -1, 2, us);
		SpawnWaypointNum('2983.2 274.3 120.0', -1, 1, us);
		SpawnWaypointNum('1284.9 332.5 376.0', -1, 7, us);
		SpawnWaypointNum('1465.5 504.3  40.0', -1, 1, us);
		SpawnWaypointNum('1255.8   9.0 360.0', -1, 6, us);
		SpawnWaypointNum('1201.0 -1030.4 304.0', -1, 2, us);
		SpawnWaypointNum('2496.0 311.8  40.0', -1, 2, us);
		SpawnWaypointNum('1253.7 634.2 136.0', -1, 3, us);
		SpawnWaypointNum('1050.0 464.0  40.0', -1, 2, us);
		SpawnWaypointNum('1729.0 -1032.3 296.0', -1, 1, us);
		SpawnWaypointNum('681.2 414.5 -344.0', -1, 4, us);
		SpawnWaypointNum('1040.0 602.4  40.0', -1, 4, us);
		SpawnWaypointNum('665.4 609.5 136.0', -1, 3, us);
		SpawnWaypointNum('883.3 414.3 -664.0', -1, 5, us);
		SpawnWaypointNum('1946.1 -855.6 276.0', -1, 0, us);
		SpawnWaypointNum('1788.5 462.9 200.0', -1, 0, us);
		SpawnWaypointNum('1559.6 413.4 -664.0', -1, 7, us);
		SpawnWaypointNum('1628.9 533.3 200.0', -1, 2, us);
		SpawnWaypointNum('1719.2 152.2 200.0', -1, 1, us);
		SpawnWaypointNum('1488.8 707.2 168.0', -1, 1, us);
		SpawnWaypointNum('1107.3 -329.4 -280.0', -1, 4, us);
		SpawnWaypointNum('1184.5 240.6 -664.0', -1, 8, us);
		SpawnWaypointNum('1153.0 845.2 -864.0', -1, 6, us);
		SpawnWaypointNum('1571.3   8.2 -536.0', -1, 6, us);
		SpawnWaypointNum('938.9 979.6 -864.0', -1, 5, us);
		SpawnWaypointNum('1344.2 1339.3 152.0', -1, 2, us);
		SpawnWaypointNum('1616.5 183.5 200.0', -1, 2, us);
		SpawnWaypointNum('1513.0 1337.3 152.0', -1, 1, us);
		SpawnWaypointNum('852.7 1204.6 -864.0', -1, 4, us);
		SpawnWaypointNum('1202.8 1144.6 168.0', -1, 3, us);
		SpawnWaypointNum('1190.0 606.0 -872.0', -1, 7, us);
		return TRUE;
	}	else if (mname == "dm1")
	{
		SpawnWaypointNum('113.9 1440.2 -104.0', 5, 4, us);
		SpawnWaypointNum('216.7 1606.2  40.0', 5, 7, us);
		SpawnWaypointNum('433.8 1327.4  36.0', 5, 9, us);
		SpawnWaypointNum('34.0 583.4  40.0', -1, 2, us);
		SpawnWaypointNum('602.4 592.7  40.0', -1, 1, us);
		SpawnWaypointNum('437.5 1391.4 -104.0', 5, 0, us);
		SpawnWaypointNum('-680.8 994.8  40.0', -1, 6, us);
		SpawnWaypointNum('102.0 1175.5 -104.0', 5, 3, us);
		SpawnWaypointNum('416.6 1167.0 -104.0', 5, 1, us);
		SpawnWaypointNum('-149.3 1596.4 -104.0', 5, 6, us);
		SpawnWaypointNum('475.5 1562.6  40.0', 5, 8, us);
		SpawnWaypointNum('1114.2 1320.6  88.0', 14, 1, us);
		SpawnWaypointNum('-181.9 1447.2 -104.0', 5, 5, us);
		SpawnWaypointNum('-549.9 757.7  40.0', -1, 4, us);
		SpawnWaypointNum('53.5 760.3  40.0', -1, 3, us);
		SpawnWaypointNum('1094.0 806.3  88.0', 14, 0, us);
		SpawnWaypointNum('604.6 748.5  40.0', -1, 0, us);
		SpawnWaypointNum('-510.3 1018.6  40.0', -1, 5, us);
		SpawnWaypointNum('-674.7 1617.1  40.0', -1, 7, us);
		return TRUE;
	}
	else if (mname == "dm2")
	{
		SpawnWaypointNum('2627.1 -29.3 136', -1, 2, us);
		SpawnWaypointNum('1686.8 -1698.7  40.0', 5, 3, us);
		SpawnWaypointNum('2441.5 -2465.8 136', 14, 2, us);
		SpawnWaypointNum('2441.2 -2292.9 136', 14, 1, us);
		SpawnWaypointNum('2724.3 -2279.2 136', 14, 0, us);
		SpawnWaypointNum('2522.9 -1891.8  40.0', 5, 5, us);
		SpawnWaypointNum('2180.3 -2422.4 216', 14, 3, us);
		SpawnWaypointNum('2614.9 -838.2 136', -1, 1, us);
		SpawnWaypointNum('2132 -282.5 40', -1, 5, us);
		SpawnWaypointNum('2548.4 317 -56', -1, 7, us);
		SpawnWaypointNum('2510.5 -853.7 136', -1, 0, us);
		SpawnWaypointNum('2498.8 -1696.1  40.0', 5, 4, us);
		SpawnWaypointNum('2494 -28.6 136', -1, 3, us);
		SpawnWaypointNum('2285.2 5 40', -1, 4, us);
		SpawnWaypointNum('2159.9 262.9 40', -1, 6, us);
		SpawnWaypointNum('2643.1 -47.3 -56', -1, 8, us);
		SpawnWaypointNum('1892.3 -1036.4 360.0', 5, 0, us);
		SpawnWaypointNum('2184.4 -1856.5  40.0', 5, 6, us);
		SpawnWaypointNum('1725.6 -991.2  36.0', 5, 2, us);
		SpawnWaypointNum('1424.0 -1005.4  36.0', 5, 1, us);
		return TRUE;
	}
	else if (mname == "dm3")	// new
	{
		// CTF Bot 1.1 waypoints by Karl Was <karlw@tic.ab.ca>

		SpawnWaypointNum('-627.1 624 200', 5, 0, us);
		SpawnWaypointNum('-631.5 713.5 200', 5, 1, us);
		SpawnWaypointNum('-792 713.5 200', 5, 2, us);
		SpawnWaypointNum('-925 708.2 136', 5, 3, us);
		SpawnWaypointNum('-940.3 397 136', 5, 4, us);
		SpawnWaypointNum('-925.1  42.7 0', 5, 5, us);
		SpawnWaypointNum('-904.1 -261.3 0', 5, 6, us);
		SpawnWaypointNum('-120.3 -547.8 0', 5, 11, us);
		SpawnWaypointNum('-140.8 -874.3 0', 5, 12, us);
		SpawnWaypointNum('487.1 -874 72', 5, 13, us);
		SpawnWaypointNum('-642.8 -245.1 0', 5, 7, us);
		SpawnWaypointNum('-643.3 -688.1 0', 5, 8, us);
		SpawnWaypointNum('-314.1 -705.7 0', 5, 9, us);
		SpawnWaypointNum('-305.2 -529.6 0', 5, 10, us);
		SpawnWaypointNum('-422 531.9 136', 5, 0, us);
		SpawnWaypointNum('-347.3 519.2 136', 5, 1, us);
		SpawnWaypointNum('-21.7 535.2 56', 5, 2, us);
		SpawnWaypointNum('489.8 -320.5 72', 5, 14, us);
		SpawnWaypointNum('1787.1 -710 -8', 14, 0, us);
		SpawnWaypointNum('1806.6 -884.6 -8', 14, 1, us);
		SpawnWaypointNum('1542.4 -893.8 104', 14, 2, us);
		SpawnWaypointNum('484.9 635 72', 5, 3, us);
		SpawnWaypointNum('539.1 320.1 72', 5, 4, us);
		SpawnWaypointNum('225.6 233.3 72', 5, 5, us);
		SpawnWaypointNum('-489.9 502.9 136', 5, 0, us);
		SpawnWaypointNum('-796.8 484.2 200', 5, 1, us);
		SpawnWaypointNum('-890.6 484.2 200', 5, 2, us);
		SpawnWaypointNum('-965.1 483.8 136', 5, 3, us);
		SpawnWaypointNum('-950 361.7 136', 5, 4, us);
		SpawnWaypointNum('-894.3  81.6 24', 5, 5, us);
		SpawnWaypointNum('-857.7 -272 0', 5, 6, us);
		SpawnWaypointNum('-644.9 -298.2 0', 5, 7, us);
		SpawnWaypointNum('-669 -714.3 0', 5, 8, us);
		SpawnWaypointNum('-288.4 -688.2 0', 5, 9, us);
		SpawnWaypointNum('-299.9 -570.8 0', 5, 10, us);
		SpawnWaypointNum('-124.7 -583.7 0', 5, 11, us);
		SpawnWaypointNum('-88.8 -880 0', 5, 12, us);
		SpawnWaypointNum('496 -841.2 72', 5, 13, us);
		SpawnWaypointNum('1041.8 -881.5 104', 14, 3, us);
		SpawnWaypointNum('1372.5 122 -8', 14, 4, us);
		SpawnWaypointNum('1357.5 310.8 72', 14, 5, us);
		SpawnWaypointNum('877.7 -637.1 104', 14, 4, us);
		SpawnWaypointNum('633.1 -649.1 104', 14, 5, us);
		SpawnWaypointNum('652.6 -385.2 72', 14, 6, us);
		SpawnWaypointNum('928.5 -279.8 72', 14, 7, us);
		SpawnWaypointNum('928.3 139.2 72', 14, 8, us);
		SpawnWaypointNum('1820.7 -705.1 -8', 14, 0, us);
		SpawnWaypointNum('1196 -744.8 -8', 14, 1, us);
		SpawnWaypointNum('1218.1 -541.3 -8', 14, 2, us);
		SpawnWaypointNum('1349.5 -360.9 -8', 14, 3, us);
		SpawnWaypointNum('597.3   3.7 -152', 14, 9, us);
		SpawnWaypointNum('-545.9 470.1 136', 5, 0, us);
		SpawnWaypointNum('1351.6 432.1 72', 14, 6, us);
		SpawnWaypointNum('639.9 432.1 72', 14, 7, us);
		SpawnWaypointNum('611.5 289.6 72', 14, 8, us);
		SpawnWaypointNum('947.5 14 72', 14, 9, us);
		SpawnWaypointNum('1857.6 -714.6 -8', 14, 0, us);
		SpawnWaypointNum('1182.8 -708.2 -8', 14, 1, us);
		SpawnWaypointNum('1262.1 -424.2 -8', 14, 2, us);
		SpawnWaypointNum('2002.8 -441.4 -8', 14, 3, us);
		SpawnWaypointNum('2021.4 -63.9 -152', 14, 4, us);
		SpawnWaypointNum('885.1 -10.5 -168', 14, 5, us);
		SpawnWaypointNum('930.1 -222.7 -168', 14, 6, us);
		SpawnWaypointNum('602.4 -246.8 -184', 14, 7, us);
		SpawnWaypointNum('592.6  11.3 -152', 14, 8, us);
		SpawnWaypointNum('67.3 -408.6 -16', 5, 11, us);
		SpawnWaypointNum('-196.8 -438.8 -96', 5, 12, us);
		SpawnWaypointNum('-752 370.1 200', 5, 1, us);
		SpawnWaypointNum('-953.8 318.3 136', 5, 3, us);
		SpawnWaypointNum('-926.3  58.1 8', 5, 4, us);
		SpawnWaypointNum('-922.4 -294.7 0', 5, 5, us);
		SpawnWaypointNum('-632.1 -294.7 0', 5, 6, us);
		SpawnWaypointNum('-952 282.5 253.5', 5, 2, us);
		SpawnWaypointNum('-662.6 -686.2 0', 5, 7, us);
		SpawnWaypointNum('-311.7 -662.2 0', 5, 8, us);
		SpawnWaypointNum('-300 -567.4 0', 5, 9, us);
		SpawnWaypointNum('62.3 -613.4 0', 5, 10, us);
		SpawnWaypointNum('-183.4 -177.4 -160', 5, 13, us);
		SpawnWaypointNum('228.6 -197.6 -160', 5, 14, us);
		SpawnWaypointNum('209.9 -31.8 -160', 5, 15, us);
		SpawnWaypointNum('558.3 -42.7 -152', 5, 16, us);
		SpawnWaypointNum('1592.0  19.0 -126.9', 14, 5, us);
		SpawnWaypointNum('649.7 1047.0  40.0', 14, 14, us);
		SpawnWaypointNum('493.1 1048.0  56.0', 14, 15, us);
		SpawnWaypointNum('495.7 896.0  56.0', 14, 16, us);
		SpawnWaypointNum('1586.9  96.1 -164.9', 14, 6, us);
		SpawnWaypointNum('1597.2 214.4 -376.0', 14, 0, us);
		SpawnWaypointNum('1595.1 242.0 -376.0', 14, 7, us);
		SpawnWaypointNum('1613.7  36.1 -376.0', 14, 8, us);
		SpawnWaypointNum('1413.3  57.5 -376.0', 14, 9, us);
		SpawnWaypointNum('1378.7 617.0 -376.0', 14, 10, us);
		SpawnWaypointNum('1364.2 833.5 -280.0', 14, 11, us);
		SpawnWaypointNum('942.5 875.0 -280.0', 14, 12, us);
		SpawnWaypointNum('643.3 919.1  40.0', 14, 13, us);
		SpawnWaypointNum('469.9 271.2  72.0', 14, 20, us);
		SpawnWaypointNum('497.1 867.9 232.0', 14, 17, us);
 		SpawnWaypointNum('514.3 643.6 232.0', 14, 18, us);
		SpawnWaypointNum('501.2 592.0  72.0', 14, 19, us);
		return TRUE;
	}
	else if (mname == "dm4")
	{
		SpawnWaypointNum('-95.5 493.2 -280', 5, 0, us);
		SpawnWaypointNum('348.5 -450.7 -88', -1, 0, us);
		SpawnWaypointNum('-63.6 -233.2 -280', 5, 1, us);
		SpawnWaypointNum('1040 -502.4 -88', 14, 0, us);
		SpawnWaypointNum('869.5 -416.7 40', 14, 1, us);
		SpawnWaypointNum('330.7 -799.1 -88', -1, 1, us);
		SpawnWaypointNum('331 -473.9 40', -1, 0, us);
		SpawnWaypointNum('778.7 -889.6 -216', -1, 0, us);
		SpawnWaypointNum('848.3 -160.8 40', 14, 2, us);
		SpawnWaypointNum('647.3 -158.7 112.0', 14, 3, us);
		SpawnWaypointNum('198.0 -237.1 -280.0', 5, 2, us);
		return TRUE;
	}

	else if (mname == "dm5")
	{
		SpawnWaypointNum('305.1 698.8 136', 5, 1, us);
		SpawnWaypointNum('260.3 -812.6 136', 14, 4, us);
		SpawnWaypointNum('-47 593 88', 5, 3, us);
		SpawnWaypointNum('-96.4 -781.8 56', 14, 5, us);
		SpawnWaypointNum('294.8 208 136', 5, 0, us);
		SpawnWaypointNum('97 685.8 136', 5, 2, us);
		SpawnWaypointNum('865.4 -758.7 232', 14, 1, us);
		SpawnWaypointNum('906.4 -415.3 232', 14, 2, us);
		SpawnWaypointNum('-107.8 -68.9 56', 5, 4, us);
		SpawnWaypointNum('287.1 -431.2 136', 14, 3, us);
		SpawnWaypointNum('777.9 -205.2 232', -1, 0, us);
		SpawnWaypointNum('324.8 368 232', -1, 0, us);
		return TRUE;
	}
	else if (mname == "dm6")
	{
		SpawnWaypointNum('1833.6 -147.7 184', 14, 0, us);
		SpawnWaypointNum('1626 -158.3 184', 14, 1, us);
		SpawnWaypointNum('1629.5 -279.9 184', 14, 2, us);
		SpawnWaypointNum('1649.3 -703.8 56', 14, 3, us);
		SpawnWaypointNum('1673.6 -1078.9 56', 14, 4, us);
		SpawnWaypointNum('1201.8 -1083.5 -24', 14, 5, us);
		SpawnWaypointNum('1135.8 -926.1 -24', 14, 6, us);
		SpawnWaypointNum('150 -1290 128', 5, 0, us);
		SpawnWaypointNum('168 -1094.3 128', 5, 1, us);
		SpawnWaypointNum('480.7 -1102.7 142.4', 5, 2, us);
		SpawnWaypointNum('674.5 -1088.3  87.4', 5, 3, us);
		SpawnWaypointNum('953 -950.8 -24', 5, 4, us);
		SpawnWaypointNum('1048.0 -1475.4 272.0', -1, 1, us);
		SpawnWaypointNum('202.4 -1775.9  72.0', -1, 0, us);
		SpawnWaypointNum('832.3 -1082.4 272.0', -1, 0, us);
		SpawnWaypointNum('1673.3 -429.4  56.0', -1, 0, us);
		SpawnWaypointNum('405.1 -1066.3 272.0', -1, 1, us);
		SpawnWaypointNum('72.0 -1488.0  56.0', -1, 1, us);
		return TRUE;
	}//////////////////////
//do not alter this file
//////////////////////



};

//=============================================================
//=============================================================
void(string mname)SpawnWaypointsForMap = 
{	
	local float found;
	found = SpawnWaypointsForMap1(mname);
	if (!found)
		found = SpawnWaypointsForMap2(mname);
};


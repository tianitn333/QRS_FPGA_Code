// Exact official Logo pixels: common colors plus tagged sparse read-only data.
// 官方Logo无损像素：常用色组合译码，其余颜色使用带标签的只读ERAM。
// One-clock read; the caller must present the previous pixel-stage address.
module anlogic_logo_palette (
    input wire clk,
    input wire rst_n,
    input wire [14:0] I_addr,
    output reg [24:0] O_pixel
);
    reg [11:0] displacement;
    wire [11:0] memory_address;
    wire [143:0] memory_data;
    wire [35:0] selected_data;
    reg [1:0] read_bank;
    reg [14:0] read_address;
    reg read_valid;
    reg [1:0] base_color;

    // The bucket and displacement retain all original address information.
    always @(*) begin
        displacement = 12'd0;
        case (I_addr[8:0])
            9'd0: displacement = 12'd335;
            9'd1: displacement = 12'd804;
            9'd2: displacement = 12'd832;
            9'd3: displacement = 12'd288;
            9'd4: displacement = 12'd834;
            9'd5: displacement = 12'd806;
            9'd6: displacement = 12'd840;
            9'd7: displacement = 12'd612;
            9'd8: displacement = 12'd851;
            9'd9: displacement = 12'd161;
            9'd10: displacement = 12'd842;
            9'd11: displacement = 12'd1361;
            9'd12: displacement = 12'd1648;
            9'd13: displacement = 12'd294;
            9'd14: displacement = 12'd620;
            9'd15: displacement = 12'd1664;
            9'd16: displacement = 12'd872;
            9'd17: displacement = 12'd866;
            9'd18: displacement = 12'd1442;
            9'd19: displacement = 12'd2209;
            9'd20: displacement = 12'd2364;
            9'd21: displacement = 12'd1665;
            9'd22: displacement = 12'd1342;
            9'd23: displacement = 12'd1336;
            9'd24: displacement = 12'd1317;
            9'd25: displacement = 12'd1666;
            9'd26: displacement = 12'd987;
            9'd27: displacement = 12'd785;
            9'd28: displacement = 12'd1586;
            9'd29: displacement = 12'd1672;
            9'd30: displacement = 12'd246;
            9'd31: displacement = 12'd1193;
            9'd32: displacement = 12'd932;
            9'd33: displacement = 12'd2067;
            9'd34: displacement = 12'd2368;
            9'd35: displacement = 12'd2369;
            9'd36: displacement = 12'd1572;
            9'd37: displacement = 12'd1717;
            9'd38: displacement = 12'd2370;
            9'd39: displacement = 12'd1667;
            9'd40: displacement = 12'd1142;
            9'd41: displacement = 12'd1043;
            9'd42: displacement = 12'd1201;
            9'd43: displacement = 12'd1255;
            9'd44: displacement = 12'd1697;
            9'd45: displacement = 12'd2371;
            9'd46: displacement = 12'd2036;
            9'd47: displacement = 12'd1398;
            9'd48: displacement = 12'd510;
            9'd49: displacement = 12'd2204;
            9'd50: displacement = 12'd2380;
            9'd51: displacement = 12'd1658;
            9'd52: displacement = 12'd1698;
            9'd53: displacement = 12'd1728;
            9'd54: displacement = 12'd896;
            9'd55: displacement = 12'd417;
            9'd56: displacement = 12'd751;
            9'd57: displacement = 12'd897;
            9'd58: displacement = 12'd2382;
            9'd59: displacement = 12'd1729;
            9'd60: displacement = 12'd308;
            9'd61: displacement = 12'd1534;
            9'd62: displacement = 12'd1713;
            9'd63: displacement = 12'd1730;
            9'd64: displacement = 12'd904;
            9'd65: displacement = 12'd928;
            9'd66: displacement = 12'd1678;
            9'd67: displacement = 12'd929;
            9'd68: displacement = 12'd320;
            9'd69: displacement = 12'd66;
            9'd70: displacement = 12'd938;
            9'd71: displacement = 12'd1731;
            9'd72: displacement = 12'd821;
            9'd73: displacement = 12'd34;
            9'd74: displacement = 12'd323;
            9'd75: displacement = 12'd917;
            9'd76: displacement = 12'd322;
            9'd77: displacement = 12'd352;
            9'd78: displacement = 12'd960;
            9'd79: displacement = 12'd1736;
            9'd80: displacement = 12'd961;
            9'd81: displacement = 12'd1737;
            9'd82: displacement = 12'd968;
            9'd83: displacement = 12'd969;
            9'd84: displacement = 12'd1761;
            9'd85: displacement = 12'd992;
            9'd86: displacement = 12'd993;
            9'd87: displacement = 12'd1980;
            9'd88: displacement = 12'd924;
            9'd89: displacement = 12'd2722;
            9'd90: displacement = 12'd2400;
            9'd91: displacement = 12'd263;
            9'd92: displacement = 12'd2348;
            9'd93: displacement = 12'd2287;
            9'd94: displacement = 12'd1625;
            9'd95: displacement = 12'd1833;
            9'd96: displacement = 12'd2158;
            9'd97: displacement = 12'd230;
            9'd98: displacement = 12'd1024;
            9'd99: displacement = 12'd353;
            9'd100: displacement = 12'd1765;
            9'd101: displacement = 12'd2351;
            9'd102: displacement = 12'd80;
            9'd103: displacement = 12'd1027;
            9'd104: displacement = 12'd1162;
            9'd105: displacement = 12'd2383;
            9'd106: displacement = 12'd1792;
            9'd107: displacement = 12'd46;
            9'd108: displacement = 12'd1032;
            9'd109: displacement = 12'd2425;
            9'd110: displacement = 12'd1794;
            9'd111: displacement = 12'd1795;
            9'd112: displacement = 12'd1800;
            9'd113: displacement = 12'd1801;
            9'd114: displacement = 12'd2403;
            9'd115: displacement = 12'd1033;
            9'd116: displacement = 12'd1796;
            9'd117: displacement = 12'd1807;
            9'd118: displacement = 12'd2690;
            9'd119: displacement = 12'd2703;
            9'd120: displacement = 12'd178;
            9'd121: displacement = 12'd382;
            9'd122: displacement = 12'd938;
            9'd123: displacement = 12'd1778;
            9'd124: displacement = 12'd1826;
            9'd125: displacement = 12'd2231;
            9'd126: displacement = 12'd2249;
            9'd127: displacement = 12'd2720;
            9'd128: displacement = 12'd1827;
            9'd129: displacement = 12'd1006;
            9'd130: displacement = 12'd1020;
            9'd131: displacement = 12'd1856;
            9'd132: displacement = 12'd1857;
            9'd133: displacement = 12'd1697;
            9'd134: displacement = 12'd2041;
            9'd135: displacement = 12'd1038;
            9'd136: displacement = 12'd1088;
            9'd137: displacement = 12'd1858;
            9'd138: displacement = 12'd1859;
            9'd139: displacement = 12'd1058;
            9'd140: displacement = 12'd1895;
            9'd141: displacement = 12'd2432;
            9'd142: displacement = 12'd1876;
            9'd143: displacement = 12'd1888;
            9'd144: displacement = 12'd1830;
            9'd145: displacement = 12'd1273;
            9'd146: displacement = 12'd2426;
            9'd147: displacement = 12'd1835;
            9'd148: displacement = 12'd2124;
            9'd149: displacement = 12'd11;
            9'd150: displacement = 12'd2412;
            9'd151: displacement = 12'd2434;
            9'd152: displacement = 12'd1879;
            9'd153: displacement = 12'd1892;
            9'd154: displacement = 12'd1890;
            9'd155: displacement = 12'd1067;
            9'd156: displacement = 12'd2439;
            9'd157: displacement = 12'd2442;
            9'd158: displacement = 12'd121;
            9'd159: displacement = 12'd1920;
            9'd160: displacement = 12'd1092;
            9'd161: displacement = 12'd1921;
            9'd162: displacement = 12'd1924;
            9'd163: displacement = 12'd1925;
            9'd164: displacement = 12'd1928;
            9'd165: displacement = 12'd1091;
            9'd166: displacement = 12'd1952;
            9'd167: displacement = 12'd1929;
            9'd168: displacement = 12'd470;
            9'd169: displacement = 12'd384;
            9'd170: displacement = 12'd1120;
            9'd171: displacement = 12'd1933;
            9'd172: displacement = 12'd1984;
            9'd173: displacement = 12'd1109;
            9'd174: displacement = 12'd289;
            9'd175: displacement = 12'd1980;
            9'd176: displacement = 12'd1985;
            9'd177: displacement = 12'd546;
            9'd178: displacement = 12'd427;
            9'd179: displacement = 12'd1969;
            9'd180: displacement = 12'd409;
            9'd181: displacement = 12'd2436;
            9'd182: displacement = 12'd1992;
            9'd183: displacement = 12'd1997;
            9'd184: displacement = 12'd2454;
            9'd185: displacement = 12'd2459;
            9'd186: displacement = 12'd1769;
            9'd187: displacement = 12'd2466;
            9'd188: displacement = 12'd2465;
            9'd189: displacement = 12'd1993;
            9'd190: displacement = 12'd1106;
            9'd191: displacement = 12'd2467;
            9'd192: displacement = 12'd2632;
            9'd193: displacement = 12'd2726;
            9'd194: displacement = 12'd2496;
            9'd195: displacement = 12'd463;
            9'd196: displacement = 12'd2732;
            9'd197: displacement = 12'd2757;
            9'd198: displacement = 12'd809;
            9'd199: displacement = 12'd2413;
            9'd200: displacement = 12'd2468;
            9'd201: displacement = 12'd2720;
            9'd202: displacement = 12'd1362;
            9'd203: displacement = 12'd1152;
            9'd204: displacement = 12'd1064;
            9'd205: displacement = 12'd2497;
            9'd206: displacement = 12'd2016;
            9'd207: displacement = 12'd1153;
            9'd208: displacement = 12'd1161;
            9'd209: displacement = 12'd2012;
            9'd210: displacement = 12'd2046;
            9'd211: displacement = 12'd2048;
            9'd212: displacement = 12'd2037;
            9'd213: displacement = 12'd2049;
            9'd214: displacement = 12'd2052;
            9'd215: displacement = 12'd2053;
            9'd216: displacement = 12'd109;
            9'd217: displacement = 12'd1174;
            9'd218: displacement = 12'd2500;
            9'd219: displacement = 12'd2056;
            9'd220: displacement = 12'd1185;
            9'd221: displacement = 12'd223;
            9'd222: displacement = 12'd864;
            9'd223: displacement = 12'd663;
            9'd224: displacement = 12'd392;
            9'd225: displacement = 12'd405;
            9'd226: displacement = 12'd407;
            9'd227: displacement = 12'd1184;
            9'd228: displacement = 12'd93;
            9'd229: displacement = 12'd8;
            9'd230: displacement = 12'd15;
            9'd231: displacement = 12'd438;
            9'd232: displacement = 12'd79;
            9'd234: displacement = 12'd29;
            9'd235: displacement = 12'd448;
            9'd236: displacement = 12'd99;
            9'd237: displacement = 12'd64;
            9'd238: displacement = 12'd128;
            9'd239: displacement = 12'd449;
            9'd240: displacement = 12'd456;
            9'd241: displacement = 12'd132;
            9'd242: displacement = 12'd137;
            9'd243: displacement = 12'd139;
            9'd244: displacement = 12'd462;
            9'd245: displacement = 12'd192;
            9'd246: displacement = 12'd194;
            9'd247: displacement = 12'd1216;
            9'd248: displacement = 12'd2067;
            9'd249: displacement = 12'd2082;
            9'd250: displacement = 12'd2085;
            9'd251: displacement = 12'd2112;
            9'd252: displacement = 12'd2352;
            9'd253: displacement = 12'd2504;
            9'd254: displacement = 12'd2505;
            9'd255: displacement = 12'd196;
            9'd256: displacement = 12'd2501;
            9'd257: displacement = 12'd2115;
            9'd258: displacement = 12'd1183;
            9'd259: displacement = 12'd1218;
            9'd260: displacement = 12'd2476;
            9'd261: displacement = 12'd2496;
            9'd262: displacement = 12'd2508;
            9'd263: displacement = 12'd1351;
            9'd264: displacement = 12'd2752;
            9'd265: displacement = 12'd295;
            9'd266: displacement = 12'd2546;
            9'd267: displacement = 12'd1278;
            9'd268: displacement = 12'd2559;
            9'd269: displacement = 12'd2534;
            9'd270: displacement = 12'd61;
            9'd271: displacement = 12'd2754;
            9'd272: displacement = 12'd2560;
            9'd273: displacement = 12'd351;
            9'd274: displacement = 12'd2116;
            9'd275: displacement = 12'd2120;
            9'd276: displacement = 12'd1023;
            9'd277: displacement = 12'd1126;
            9'd278: displacement = 12'd1226;
            9'd279: displacement = 12'd1726;
            9'd280: displacement = 12'd2507;
            9'd281: displacement = 12'd2122;
            9'd282: displacement = 12'd1220;
            9'd283: displacement = 12'd501;
            9'd284: displacement = 12'd512;
            9'd285: displacement = 12'd514;
            9'd286: displacement = 12'd1248;
            9'd287: displacement = 12'd2148;
            9'd288: displacement = 12'd1255;
            9'd289: displacement = 12'd358;
            9'd290: displacement = 12'd494;
            9'd291: displacement = 12'd516;
            9'd292: displacement = 12'd774;
            9'd293: displacement = 12'd2159;
            9'd294: displacement = 12'd2176;
            9'd295: displacement = 12'd538;
            9'd296: displacement = 12'd1280;
            9'd297: displacement = 12'd1282;
            9'd298: displacement = 12'd1284;
            9'd299: displacement = 12'd1286;
            9'd300: displacement = 12'd1312;
            9'd301: displacement = 12'd2087;
            9'd302: displacement = 12'd2109;
            9'd303: displacement = 12'd1306;
            9'd304: displacement = 12'd1328;
            9'd305: displacement = 12'd2562;
            9'd306: displacement = 12'd2424;
            9'd307: displacement = 12'd2080;
            9'd308: displacement = 12'd1060;
            9'd309: displacement = 12'd885;
            9'd310: displacement = 12'd1492;
            9'd311: displacement = 12'd2538;
            9'd312: displacement = 12'd2146;
            9'd313: displacement = 12'd927;
            9'd314: displacement = 12'd2564;
            9'd315: displacement = 12'd634;
            9'd316: displacement = 12'd561;
            9'd317: displacement = 12'd2568;
            9'd318: displacement = 12'd174;
            9'd319: displacement = 12'd367;
            9'd320: displacement = 12'd2565;
            9'd321: displacement = 12'd742;
            9'd322: displacement = 12'd2284;
            9'd323: displacement = 12'd72;
            9'd324: displacement = 12'd2517;
            9'd325: displacement = 12'd2230;
            9'd326: displacement = 12'd1409;
            9'd327: displacement = 12'd2757;
            9'd328: displacement = 12'd2151;
            9'd329: displacement = 12'd2179;
            9'd330: displacement = 12'd2567;
            9'd331: displacement = 12'd2758;
            9'd332: displacement = 12'd1745;
            9'd333: displacement = 12'd1125;
            9'd334: displacement = 12'd2181;
            9'd335: displacement = 12'd2273;
            9'd336: displacement = 12'd1452;
            9'd337: displacement = 12'd2208;
            9'd338: displacement = 12'd1967;
            9'd339: displacement = 12'd24;
            9'd340: displacement = 12'd1781;
            9'd341: displacement = 12'd2728;
            9'd342: displacement = 12'd1442;
            9'd343: displacement = 12'd2487;
            9'd344: displacement = 12'd2750;
            9'd345: displacement = 12'd2756;
            9'd346: displacement = 12'd1646;
            9'd347: displacement = 12'd1443;
            9'd348: displacement = 12'd1401;
            9'd349: displacement = 12'd2760;
            9'd350: displacement = 12'd1344;
            9'd351: displacement = 12'd1250;
            9'd352: displacement = 12'd2537;
            9'd353: displacement = 12'd1565;
            9'd354: displacement = 12'd2577;
            9'd355: displacement = 12'd2593;
            9'd356: displacement = 12'd2595;
            9'd357: displacement = 12'd2759;
            9'd358: displacement = 12'd2616;
            9'd359: displacement = 12'd741;
            9'd360: displacement = 12'd2191;
            9'd361: displacement = 12'd2624;
            9'd362: displacement = 12'd2194;
            9'd363: displacement = 12'd535;
            9'd364: displacement = 12'd548;
            9'd365: displacement = 12'd2192;
            9'd366: displacement = 12'd1345;
            9'd367: displacement = 12'd152;
            9'd368: displacement = 12'd1353;
            9'd369: displacement = 12'd2625;
            9'd370: displacement = 12'd2240;
            9'd371: displacement = 12'd2241;
            9'd372: displacement = 12'd2626;
            9'd373: displacement = 12'd2627;
            9'd374: displacement = 12'd2580;
            9'd375: displacement = 12'd1959;
            9'd376: displacement = 12'd2028;
            9'd377: displacement = 12'd2640;
            9'd378: displacement = 12'd2641;
            9'd379: displacement = 12'd2620;
            9'd380: displacement = 12'd1360;
            9'd381: displacement = 12'd576;
            9'd382: displacement = 12'd1354;
            9'd383: displacement = 12'd567;
            9'd384: displacement = 12'd577;
            9'd385: displacement = 12'd1376;
            9'd386: displacement = 12'd1408;
            9'd387: displacement = 12'd1389;
            9'd388: displacement = 12'd579;
            9'd389: displacement = 12'd224;
            9'd390: displacement = 12'd588;
            9'd391: displacement = 12'd225;
            9'd392: displacement = 12'd608;
            9'd393: displacement = 12'd587;
            9'd394: displacement = 12'd146;
            9'd395: displacement = 12'd230;
            9'd396: displacement = 12'd640;
            9'd397: displacement = 12'd1410;
            9'd398: displacement = 12'd1411;
            9'd399: displacement = 12'd643;
            9'd400: displacement = 12'd1416;
            9'd401: displacement = 12'd1418;
            9'd402: displacement = 12'd1472;
            9'd403: displacement = 12'd641;
            9'd404: displacement = 12'd650;
            9'd405: displacement = 12'd1419;
            9'd406: displacement = 12'd649;
            9'd407: displacement = 12'd256;
            9'd408: displacement = 12'd1409;
            9'd409: displacement = 12'd1473;
            9'd410: displacement = 12'd1474;
            9'd411: displacement = 12'd2175;
            9'd412: displacement = 12'd1480;
            9'd413: displacement = 12'd1597;
            9'd414: displacement = 12'd2250;
            9'd415: displacement = 12'd1482;
            9'd416: displacement = 12'd2242;
            9'd417: displacement = 12'd704;
            9'd418: displacement = 12'd1536;
            9'd419: displacement = 12'd1498;
            9'd420: displacement = 12'd1538;
            9'd421: displacement = 12'd2184;
            9'd422: displacement = 12'd2251;
            9'd423: displacement = 12'd2646;
            9'd424: displacement = 12'd2642;
            9'd425: displacement = 12'd2273;
            9'd426: displacement = 12'd2221;
            9'd427: displacement = 12'd2610;
            9'd428: displacement = 12'd2304;
            9'd429: displacement = 12'd2306;
            9'd430: displacement = 12'd2656;
            9'd431: displacement = 12'd2657;
            9'd432: displacement = 12'd2662;
            9'd433: displacement = 12'd1120;
            9'd434: displacement = 12'd710;
            9'd435: displacement = 12'd1546;
            9'd436: displacement = 12'd672;
            9'd437: displacement = 12'd675;
            9'd438: displacement = 12'd715;
            9'd439: displacement = 12'd1548;
            9'd440: displacement = 12'd2244;
            9'd441: displacement = 12'd2312;
            9'd442: displacement = 12'd736;
            9'd443: displacement = 12'd740;
            9'd444: displacement = 12'd1571;
            9'd445: displacement = 12'd1594;
            9'd446: displacement = 12'd1600;
            9'd447: displacement = 12'd1602;
            9'd448: displacement = 12'd2314;
            9'd449: displacement = 12'd2316;
            9'd450: displacement = 12'd258;
            9'd451: displacement = 12'd706;
            9'd452: displacement = 12'd2318;
            9'd453: displacement = 12'd2345;
            9'd454: displacement = 12'd1598;
            9'd455: displacement = 12'd1608;
            9'd456: displacement = 12'd1615;
            9'd457: displacement = 12'd879;
            9'd458: displacement = 12'd260;
            9'd459: displacement = 12'd420;
            9'd460: displacement = 12'd768;
            9'd461: displacement = 12'd1625;
            9'd462: displacement = 12'd1643;
            9'd463: displacement = 12'd769;
            9'd464: displacement = 12'd1486;
            9'd465: displacement = 12'd2688;
            9'd466: displacement = 12'd2689;
            9'd467: displacement = 12'd1218;
            9'd468: displacement = 12'd1508;
            9'd469: displacement = 12'd2608;
            9'd470: displacement = 12'd1208;
            9'd471: displacement = 12'd2760;
            9'd472: displacement = 12'd2690;
            9'd473: displacement = 12'd2457;
            9'd474: displacement = 12'd2784;
            9'd475: displacement = 12'd1314;
            9'd476: displacement = 12'd1913;
            9'd477: displacement = 12'd442;
            9'd478: displacement = 12'd945;
            9'd479: displacement = 12'd1443;
            9'd480: displacement = 12'd2770;
            9'd481: displacement = 12'd1872;
            9'd482: displacement = 12'd1506;
            9'd483: displacement = 12'd343;
            9'd484: displacement = 12'd1222;
            9'd485: displacement = 12'd2761;
            9'd486: displacement = 12'd1140;
            9'd487: displacement = 12'd672;
            9'd488: displacement = 12'd708;
            9'd489: displacement = 12'd2272;
            9'd490: displacement = 12'd2652;
            9'd491: displacement = 12'd2773;
            9'd492: displacement = 12'd1796;
            9'd493: displacement = 12'd2284;
            9'd494: displacement = 12'd2692;
            9'd495: displacement = 12'd1027;
            9'd496: displacement = 12'd2734;
            9'd497: displacement = 12'd2342;
            9'd498: displacement = 12'd686;
            9'd499: displacement = 12'd1581;
            9'd500: displacement = 12'd2772;
            9'd501: displacement = 12'd2659;
            9'd502: displacement = 12'd2788;
            9'd503: displacement = 12'd2708;
            9'd504: displacement = 12'd2720;
            9'd505: displacement = 12'd2694;
            9'd506: displacement = 12'd2345;
            9'd507: displacement = 12'd485;
            9'd508: displacement = 12'd1509;
            9'd509: displacement = 12'd1763;
            9'd510: displacement = 12'd781;
            9'd511: displacement = 12'd800;
            default: displacement = 12'd0;
        endcase
    end
    assign memory_address = displacement ^ {6'd0, I_addr[14:9]};
    assign selected_data = memory_data[read_bank*36 +: 36];

    // Match the synchronous ERAM port with its bucket tag and bank selection.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_bank <= 2'd0;
            read_address <= 15'd0;
            read_valid <= 1'b0;
        end else begin
            read_bank <= memory_address[11:10];
            read_address <= I_addr;
            read_valid <= 1'b1;
        end
    end

    // Initialized 18x1024 word bank, read-only during video operation.
    PH1P_LOGIC_ERAM #(
        .DATA_WIDTH_A(18), .DATA_WIDTH_B(18), .ADDR_WIDTH_A(10), .ADDR_WIDTH_B(10),
        .DATA_DEPTH_A(1024), .DATA_DEPTH_B(1024), .MODE("DP"),
        .REGMODE_A("NOREG"), .REGMODE_B("NOREG"), .WRITEMODE_A("NORMAL"), .WRITEMODE_B("NORMAL"),
        .IMPLEMENT("20K(FAST)"), .ECC_ENCODE("DISABLE"), .ECC_DECODE("DISABLE"),
        .CLKMODE("ASYNC"), .SSROVERCE("DISABLE"), .OREGSET_A("RESET"), .OREGSET_B("RESET"),
        .RESETMODE_A("ASYNC"), .RESETMODE_B("ASYNC"),
        .ASYNC_RESET_RELEASE_A("ASYNC"), .ASYNC_RESET_RELEASE_B("ASYNC"),
        .INIT_FILE("logo_palette_data/bank_0_lane_0.dath"), .FILL_ALL("NONE")
    ) PH1P_LOGIC_ERAM_Inst_first_low (
        .dia(18'd0), .addra(10'd0), .cea(1'b0), .clka(clk), .wea(1'b0), .bea(1'b0), .rsta(1'b0), .ocea(1'b0),
        .dib(18'd0), .addrb(memory_address[9:0]), .ceb(1'b1), .clkb(clk), .web(1'b0), .beb(1'b0), .rstb(1'b0), .oceb(1'b0),
        .doa(), .dob(memory_data[17:0]),
        .ecc_sbiterr(), .ecc_dbiterr(), .ecc_sbiterrinj(1'b0), .ecc_dbiterrinj(1'b0)
    );

    // Initialized 18x1024 word bank, read-only during video operation.
    PH1P_LOGIC_ERAM #(
        .DATA_WIDTH_A(18), .DATA_WIDTH_B(18), .ADDR_WIDTH_A(10), .ADDR_WIDTH_B(10),
        .DATA_DEPTH_A(1024), .DATA_DEPTH_B(1024), .MODE("DP"),
        .REGMODE_A("NOREG"), .REGMODE_B("NOREG"), .WRITEMODE_A("NORMAL"), .WRITEMODE_B("NORMAL"),
        .IMPLEMENT("20K(FAST)"), .ECC_ENCODE("DISABLE"), .ECC_DECODE("DISABLE"),
        .CLKMODE("ASYNC"), .SSROVERCE("DISABLE"), .OREGSET_A("RESET"), .OREGSET_B("RESET"),
        .RESETMODE_A("ASYNC"), .RESETMODE_B("ASYNC"),
        .ASYNC_RESET_RELEASE_A("ASYNC"), .ASYNC_RESET_RELEASE_B("ASYNC"),
        .INIT_FILE("logo_palette_data/bank_0_lane_1.dath"), .FILL_ALL("NONE")
    ) PH1P_LOGIC_ERAM_Inst_first_high (
        .dia(18'd0), .addra(10'd0), .cea(1'b0), .clka(clk), .wea(1'b0), .bea(1'b0), .rsta(1'b0), .ocea(1'b0),
        .dib(18'd0), .addrb(memory_address[9:0]), .ceb(1'b1), .clkb(clk), .web(1'b0), .beb(1'b0), .rstb(1'b0), .oceb(1'b0),
        .doa(), .dob(memory_data[35:18]),
        .ecc_sbiterr(), .ecc_dbiterr(), .ecc_sbiterrinj(1'b0), .ecc_dbiterrinj(1'b0)
    );

    // Initialized 18x1024 word bank, read-only during video operation.
    PH1P_LOGIC_ERAM #(
        .DATA_WIDTH_A(18), .DATA_WIDTH_B(18), .ADDR_WIDTH_A(10), .ADDR_WIDTH_B(10),
        .DATA_DEPTH_A(1024), .DATA_DEPTH_B(1024), .MODE("DP"),
        .REGMODE_A("NOREG"), .REGMODE_B("NOREG"), .WRITEMODE_A("NORMAL"), .WRITEMODE_B("NORMAL"),
        .IMPLEMENT("20K(FAST)"), .ECC_ENCODE("DISABLE"), .ECC_DECODE("DISABLE"),
        .CLKMODE("ASYNC"), .SSROVERCE("DISABLE"), .OREGSET_A("RESET"), .OREGSET_B("RESET"),
        .RESETMODE_A("ASYNC"), .RESETMODE_B("ASYNC"),
        .ASYNC_RESET_RELEASE_A("ASYNC"), .ASYNC_RESET_RELEASE_B("ASYNC"),
        .INIT_FILE("logo_palette_data/bank_1_lane_0.dath"), .FILL_ALL("NONE")
    ) PH1P_LOGIC_ERAM_Inst_second_low (
        .dia(18'd0), .addra(10'd0), .cea(1'b0), .clka(clk), .wea(1'b0), .bea(1'b0), .rsta(1'b0), .ocea(1'b0),
        .dib(18'd0), .addrb(memory_address[9:0]), .ceb(1'b1), .clkb(clk), .web(1'b0), .beb(1'b0), .rstb(1'b0), .oceb(1'b0),
        .doa(), .dob(memory_data[53:36]),
        .ecc_sbiterr(), .ecc_dbiterr(), .ecc_sbiterrinj(1'b0), .ecc_dbiterrinj(1'b0)
    );

    // Initialized 18x1024 word bank, read-only during video operation.
    PH1P_LOGIC_ERAM #(
        .DATA_WIDTH_A(18), .DATA_WIDTH_B(18), .ADDR_WIDTH_A(10), .ADDR_WIDTH_B(10),
        .DATA_DEPTH_A(1024), .DATA_DEPTH_B(1024), .MODE("DP"),
        .REGMODE_A("NOREG"), .REGMODE_B("NOREG"), .WRITEMODE_A("NORMAL"), .WRITEMODE_B("NORMAL"),
        .IMPLEMENT("20K(FAST)"), .ECC_ENCODE("DISABLE"), .ECC_DECODE("DISABLE"),
        .CLKMODE("ASYNC"), .SSROVERCE("DISABLE"), .OREGSET_A("RESET"), .OREGSET_B("RESET"),
        .RESETMODE_A("ASYNC"), .RESETMODE_B("ASYNC"),
        .ASYNC_RESET_RELEASE_A("ASYNC"), .ASYNC_RESET_RELEASE_B("ASYNC"),
        .INIT_FILE("logo_palette_data/bank_1_lane_1.dath"), .FILL_ALL("NONE")
    ) PH1P_LOGIC_ERAM_Inst_second_high (
        .dia(18'd0), .addra(10'd0), .cea(1'b0), .clka(clk), .wea(1'b0), .bea(1'b0), .rsta(1'b0), .ocea(1'b0),
        .dib(18'd0), .addrb(memory_address[9:0]), .ceb(1'b1), .clkb(clk), .web(1'b0), .beb(1'b0), .rstb(1'b0), .oceb(1'b0),
        .doa(), .dob(memory_data[71:54]),
        .ecc_sbiterr(), .ecc_dbiterr(), .ecc_sbiterrinj(1'b0), .ecc_dbiterrinj(1'b0)
    );

    // Initialized 18x1024 word bank, read-only during video operation.
    PH1P_LOGIC_ERAM #(
        .DATA_WIDTH_A(18), .DATA_WIDTH_B(18), .ADDR_WIDTH_A(10), .ADDR_WIDTH_B(10),
        .DATA_DEPTH_A(1024), .DATA_DEPTH_B(1024), .MODE("DP"),
        .REGMODE_A("NOREG"), .REGMODE_B("NOREG"), .WRITEMODE_A("NORMAL"), .WRITEMODE_B("NORMAL"),
        .IMPLEMENT("20K(FAST)"), .ECC_ENCODE("DISABLE"), .ECC_DECODE("DISABLE"),
        .CLKMODE("ASYNC"), .SSROVERCE("DISABLE"), .OREGSET_A("RESET"), .OREGSET_B("RESET"),
        .RESETMODE_A("ASYNC"), .RESETMODE_B("ASYNC"),
        .ASYNC_RESET_RELEASE_A("ASYNC"), .ASYNC_RESET_RELEASE_B("ASYNC"),
        .INIT_FILE("logo_palette_data/bank_2_lane_0.dath"), .FILL_ALL("NONE")
    ) PH1P_LOGIC_ERAM_Inst_third_low (
        .dia(18'd0), .addra(10'd0), .cea(1'b0), .clka(clk), .wea(1'b0), .bea(1'b0), .rsta(1'b0), .ocea(1'b0),
        .dib(18'd0), .addrb(memory_address[9:0]), .ceb(1'b1), .clkb(clk), .web(1'b0), .beb(1'b0), .rstb(1'b0), .oceb(1'b0),
        .doa(), .dob(memory_data[89:72]),
        .ecc_sbiterr(), .ecc_dbiterr(), .ecc_sbiterrinj(1'b0), .ecc_dbiterrinj(1'b0)
    );

    // Initialized 18x1024 word bank, read-only during video operation.
    PH1P_LOGIC_ERAM #(
        .DATA_WIDTH_A(18), .DATA_WIDTH_B(18), .ADDR_WIDTH_A(10), .ADDR_WIDTH_B(10),
        .DATA_DEPTH_A(1024), .DATA_DEPTH_B(1024), .MODE("DP"),
        .REGMODE_A("NOREG"), .REGMODE_B("NOREG"), .WRITEMODE_A("NORMAL"), .WRITEMODE_B("NORMAL"),
        .IMPLEMENT("20K(FAST)"), .ECC_ENCODE("DISABLE"), .ECC_DECODE("DISABLE"),
        .CLKMODE("ASYNC"), .SSROVERCE("DISABLE"), .OREGSET_A("RESET"), .OREGSET_B("RESET"),
        .RESETMODE_A("ASYNC"), .RESETMODE_B("ASYNC"),
        .ASYNC_RESET_RELEASE_A("ASYNC"), .ASYNC_RESET_RELEASE_B("ASYNC"),
        .INIT_FILE("logo_palette_data/bank_2_lane_1.dath"), .FILL_ALL("NONE")
    ) PH1P_LOGIC_ERAM_Inst_third_high (
        .dia(18'd0), .addra(10'd0), .cea(1'b0), .clka(clk), .wea(1'b0), .bea(1'b0), .rsta(1'b0), .ocea(1'b0),
        .dib(18'd0), .addrb(memory_address[9:0]), .ceb(1'b1), .clkb(clk), .web(1'b0), .beb(1'b0), .rstb(1'b0), .oceb(1'b0),
        .doa(), .dob(memory_data[107:90]),
        .ecc_sbiterr(), .ecc_dbiterr(), .ecc_sbiterrinj(1'b0), .ecc_dbiterrinj(1'b0)
    );

    // The fourth logical bank is entirely zero in the immutable pixel model.
    // Keep its logical capacity and value without allocating physical ERAM.
    assign memory_data[143:108] = 36'd0;

    // Two frequent colors use a small exact address decoder.
    always @(*) begin
        base_color = 2'd0;
        case (read_address)
            15'd5974, 15'd6134, 15'd6293, 15'd6294, 15'd6295, 15'd6453, 15'd6454, 15'd6455, 15'd6612, 15'd6613, 15'd6614, 15'd6615, 15'd6616, 15'd6772, 15'd6773, 15'd6774, 15'd6775, 15'd6776, 15'd6931, 15'd6932, 15'd6933, 15'd6934, 15'd6935, 15'd6936, 15'd6937, 15'd7091, 15'd7092, 15'd7093, 15'd7094, 15'd7095, 15'd7096, 15'd7097, 15'd7250, 15'd7251, 15'd7252, 15'd7253, 15'd7254, 15'd7255, 15'd7256, 15'd7257, 15'd7258, 15'd7410, 15'd7411, 15'd7412, 15'd7413, 15'd7414, 15'd7415, 15'd7416, 15'd7417, 15'd7418, 15'd7569, 15'd7570, 15'd7571, 15'd7572, 15'd7573, 15'd7574, 15'd7575, 15'd7576, 15'd7577, 15'd7578, 15'd7579, 15'd7729, 15'd7730, 15'd7731, 15'd7732, 15'd7733, 15'd7734, 15'd7735, 15'd7736, 15'd7737, 15'd7738, 15'd7739, 15'd7888, 15'd7889, 15'd7890, 15'd7891, 15'd7892, 15'd7893, 15'd7894, 15'd7895, 15'd7896, 15'd7897, 15'd7898, 15'd7899, 15'd7900, 15'd8048, 15'd8049, 15'd8050, 15'd8051, 15'd8052, 15'd8053, 15'd8054, 15'd8055, 15'd8056, 15'd8057, 15'd8058, 15'd8059, 15'd8060, 15'd8207, 15'd8208, 15'd8209, 15'd8210, 15'd8211, 15'd8212, 15'd8213, 15'd8214, 15'd8215, 15'd8216, 15'd8217, 15'd8218, 15'd8219, 15'd8220, 15'd8221, 15'd8367, 15'd8368, 15'd8369, 15'd8370, 15'd8371, 15'd8372, 15'd8373, 15'd8374, 15'd8375, 15'd8376, 15'd8377, 15'd8378, 15'd8379, 15'd8380, 15'd8381, 15'd8526, 15'd8527, 15'd8528, 15'd8529, 15'd8530, 15'd8531, 15'd8532, 15'd8533, 15'd8534, 15'd8535, 15'd8536, 15'd8537, 15'd8538, 15'd8539, 15'd8540, 15'd8541, 15'd8542, 15'd8686, 15'd8687, 15'd8688, 15'd8689, 15'd8690, 15'd8691, 15'd8692, 15'd8693, 15'd8694, 15'd8695, 15'd8696, 15'd8697, 15'd8698, 15'd8699, 15'd8700, 15'd8701, 15'd8702, 15'd8845, 15'd8846, 15'd8847, 15'd8848, 15'd8849, 15'd8850, 15'd8851, 15'd8852, 15'd8853, 15'd8854, 15'd8855, 15'd8856, 15'd8857, 15'd8858, 15'd8859, 15'd8860, 15'd8861, 15'd8862, 15'd8863, 15'd9005, 15'd9006, 15'd9007, 15'd9008, 15'd9009, 15'd9010, 15'd9011, 15'd9012, 15'd9013, 15'd9014, 15'd9015, 15'd9016, 15'd9017, 15'd9018, 15'd9019, 15'd9020, 15'd9021, 15'd9022, 15'd9023, 15'd9164, 15'd9165, 15'd9166, 15'd9167, 15'd9168, 15'd9169, 15'd9170, 15'd9171, 15'd9172, 15'd9173, 15'd9174, 15'd9175, 15'd9176, 15'd9177, 15'd9178, 15'd9179, 15'd9180, 15'd9181, 15'd9182, 15'd9183, 15'd9184, 15'd9324, 15'd9325, 15'd9326, 15'd9327, 15'd9328, 15'd9329, 15'd9330, 15'd9331, 15'd9332, 15'd9333, 15'd9334, 15'd9335, 15'd9336, 15'd9337, 15'd9338, 15'd9339, 15'd9340, 15'd9341, 15'd9342, 15'd9343, 15'd9344, 15'd9483, 15'd9484, 15'd9485, 15'd9486, 15'd9487, 15'd9488, 15'd9489, 15'd9490, 15'd9491, 15'd9492, 15'd9493, 15'd9494, 15'd9495, 15'd9496, 15'd9497, 15'd9498, 15'd9499, 15'd9500, 15'd9501, 15'd9502, 15'd9503, 15'd9504, 15'd9505, 15'd9643, 15'd9644, 15'd9645, 15'd9646, 15'd9647, 15'd9648, 15'd9649, 15'd9650, 15'd9651, 15'd9652, 15'd9653, 15'd9654, 15'd9655, 15'd9656, 15'd9657, 15'd9658, 15'd9659, 15'd9660, 15'd9661, 15'd9662, 15'd9663, 15'd9664, 15'd9665, 15'd9802, 15'd9803, 15'd9804, 15'd9805, 15'd9806, 15'd9807, 15'd9808, 15'd9809, 15'd9810, 15'd9811, 15'd9812, 15'd9813, 15'd9814, 15'd9815, 15'd9816, 15'd9817, 15'd9818, 15'd9819, 15'd9820, 15'd9821, 15'd9822, 15'd9823, 15'd9824, 15'd9825, 15'd9826, 15'd9962, 15'd9963, 15'd9964, 15'd9965, 15'd9966, 15'd9967, 15'd9968, 15'd9969, 15'd9970, 15'd9971, 15'd9972, 15'd9973, 15'd9974, 15'd9975, 15'd9976, 15'd9977, 15'd9978, 15'd9979, 15'd9980, 15'd9981, 15'd9982, 15'd9983, 15'd9984, 15'd9985, 15'd9986, 15'd10121, 15'd10122, 15'd10123, 15'd10124, 15'd10125, 15'd10126, 15'd10127, 15'd10128, 15'd10129, 15'd10130, 15'd10131, 15'd10132, 15'd10133, 15'd10134, 15'd10135, 15'd10136, 15'd10137, 15'd10138, 15'd10139, 15'd10140, 15'd10141, 15'd10142, 15'd10143, 15'd10144, 15'd10145, 15'd10146, 15'd10147, 15'd10281, 15'd10282, 15'd10283, 15'd10284, 15'd10285, 15'd10286, 15'd10287, 15'd10288, 15'd10289, 15'd10290, 15'd10291, 15'd10292, 15'd10293, 15'd10294, 15'd10295, 15'd10296, 15'd10297, 15'd10298, 15'd10299, 15'd10300, 15'd10301, 15'd10302, 15'd10303, 15'd10304, 15'd10305, 15'd10306, 15'd10307, 15'd10440, 15'd10441, 15'd10442, 15'd10443, 15'd10444, 15'd10445, 15'd10446, 15'd10447, 15'd10448, 15'd10449, 15'd10450, 15'd10451, 15'd10452, 15'd10453, 15'd10454, 15'd10455, 15'd10456, 15'd10457, 15'd10458, 15'd10459, 15'd10460, 15'd10461, 15'd10462, 15'd10463, 15'd10464, 15'd10465, 15'd10466, 15'd10467, 15'd10468, 15'd10600, 15'd10601, 15'd10602, 15'd10603, 15'd10604, 15'd10605, 15'd10606, 15'd10607, 15'd10608, 15'd10609, 15'd10610, 15'd10611, 15'd10612, 15'd10613, 15'd10614, 15'd10615, 15'd10616, 15'd10617, 15'd10618, 15'd10619, 15'd10620, 15'd10621, 15'd10622, 15'd10623, 15'd10624, 15'd10625, 15'd10626, 15'd10627, 15'd10628, 15'd10759, 15'd10760, 15'd10761, 15'd10762, 15'd10763, 15'd10764, 15'd10765, 15'd10766, 15'd10767, 15'd10768, 15'd10769, 15'd10770, 15'd10771, 15'd10772, 15'd10773, 15'd10774, 15'd10775, 15'd10776, 15'd10777, 15'd10778, 15'd10779, 15'd10780, 15'd10781, 15'd10782, 15'd10783, 15'd10784, 15'd10785, 15'd10786, 15'd10787, 15'd10788, 15'd10789, 15'd10919, 15'd10920, 15'd10921, 15'd10922, 15'd10923, 15'd10924, 15'd10925, 15'd10926, 15'd10927, 15'd10928, 15'd10929, 15'd10930, 15'd10931, 15'd10932, 15'd10933, 15'd10934, 15'd10935, 15'd10936, 15'd10937, 15'd10938, 15'd10939, 15'd10940, 15'd10941, 15'd10942, 15'd10943, 15'd10944, 15'd10945, 15'd10946, 15'd10947, 15'd10948, 15'd10949, 15'd11078, 15'd11079, 15'd11080, 15'd11081, 15'd11082, 15'd11083, 15'd11084, 15'd11085, 15'd11086, 15'd11087, 15'd11088, 15'd11089, 15'd11090, 15'd11091, 15'd11092, 15'd11093, 15'd11094, 15'd11095, 15'd11096, 15'd11097, 15'd11098, 15'd11099, 15'd11100, 15'd11101, 15'd11102, 15'd11103, 15'd11104, 15'd11105, 15'd11106, 15'd11107, 15'd11108, 15'd11109, 15'd11110, 15'd11238, 15'd11239, 15'd11240, 15'd11241, 15'd11242, 15'd11243, 15'd11244, 15'd11245, 15'd11246, 15'd11247, 15'd11248, 15'd11249, 15'd11250, 15'd11251, 15'd11252, 15'd11253, 15'd11254, 15'd11255, 15'd11256, 15'd11257, 15'd11258, 15'd11259, 15'd11260, 15'd11261, 15'd11262, 15'd11263, 15'd11264, 15'd11265, 15'd11266, 15'd11267, 15'd11268, 15'd11269, 15'd11270, 15'd11397, 15'd11398, 15'd11399, 15'd11400, 15'd11401, 15'd11402, 15'd11403, 15'd11404, 15'd11405, 15'd11406, 15'd11407, 15'd11408, 15'd11409, 15'd11410, 15'd11411, 15'd11412, 15'd11413, 15'd11414, 15'd11415, 15'd11416, 15'd11417, 15'd11418, 15'd11419, 15'd11420, 15'd11421, 15'd11422, 15'd11423, 15'd11424, 15'd11425, 15'd11426, 15'd11427, 15'd11428, 15'd11429, 15'd11430, 15'd11431, 15'd11557, 15'd11558, 15'd11559, 15'd11560, 15'd11561, 15'd11562, 15'd11563, 15'd11564, 15'd11565, 15'd11566, 15'd11567, 15'd11568, 15'd11569, 15'd11570, 15'd11571, 15'd11572, 15'd11573, 15'd11574, 15'd11575, 15'd11576, 15'd11577, 15'd11578, 15'd11579, 15'd11580, 15'd11581, 15'd11582, 15'd11583, 15'd11584, 15'd11585, 15'd11586, 15'd11587, 15'd11588, 15'd11589, 15'd11590, 15'd11591, 15'd11716, 15'd11717, 15'd11718, 15'd11719, 15'd11720, 15'd11721, 15'd11722, 15'd11723, 15'd11724, 15'd11725, 15'd11726, 15'd11727, 15'd11728, 15'd11729, 15'd11730, 15'd11731, 15'd11732, 15'd11733, 15'd11734, 15'd11735, 15'd11736, 15'd11737, 15'd11738, 15'd11739, 15'd11740, 15'd11741, 15'd11742, 15'd11743, 15'd11744, 15'd11745, 15'd11746, 15'd11747, 15'd11748, 15'd11749, 15'd11750, 15'd11751, 15'd11752, 15'd11876, 15'd11877, 15'd11878, 15'd11879, 15'd11880, 15'd11881, 15'd11882, 15'd11883, 15'd11884, 15'd11885, 15'd11886, 15'd11887, 15'd11888, 15'd11889, 15'd11890, 15'd11891, 15'd11892, 15'd11893, 15'd11894, 15'd11895, 15'd11896, 15'd11897, 15'd11898, 15'd11899, 15'd11900, 15'd11901, 15'd11902, 15'd11903, 15'd11904, 15'd11905, 15'd11906, 15'd11907, 15'd11908, 15'd11909, 15'd11910, 15'd11911, 15'd11912, 15'd12035, 15'd12036, 15'd12037, 15'd12038, 15'd12039, 15'd12040, 15'd12041, 15'd12042, 15'd12043, 15'd12044, 15'd12045, 15'd12046, 15'd12047, 15'd12048, 15'd12049, 15'd12050, 15'd12051, 15'd12052, 15'd12055, 15'd12056, 15'd12057, 15'd12058, 15'd12059, 15'd12060, 15'd12061, 15'd12062, 15'd12063, 15'd12064, 15'd12065, 15'd12066, 15'd12067, 15'd12068, 15'd12069, 15'd12070, 15'd12071, 15'd12072, 15'd12073, 15'd12195, 15'd12196, 15'd12197, 15'd12198, 15'd12199, 15'd12200, 15'd12201, 15'd12202, 15'd12203, 15'd12204, 15'd12205, 15'd12206, 15'd12207, 15'd12208, 15'd12209, 15'd12210, 15'd12211, 15'd12215, 15'd12216, 15'd12217, 15'd12218, 15'd12219, 15'd12220, 15'd12221, 15'd12222, 15'd12223, 15'd12224, 15'd12225, 15'd12226, 15'd12227, 15'd12228, 15'd12229, 15'd12230, 15'd12231, 15'd12232, 15'd12233, 15'd12354, 15'd12355, 15'd12356, 15'd12357, 15'd12358, 15'd12359, 15'd12360, 15'd12361, 15'd12362, 15'd12363, 15'd12364, 15'd12365, 15'd12366, 15'd12367, 15'd12368, 15'd12369, 15'd12370, 15'd12371, 15'd12376, 15'd12377, 15'd12378, 15'd12379, 15'd12380, 15'd12381, 15'd12382, 15'd12383, 15'd12384, 15'd12385, 15'd12386, 15'd12387, 15'd12388, 15'd12389, 15'd12390, 15'd12391, 15'd12392, 15'd12393, 15'd12394, 15'd12514, 15'd12515, 15'd12516, 15'd12517, 15'd12518, 15'd12519, 15'd12520, 15'd12521, 15'd12522, 15'd12523, 15'd12524, 15'd12525, 15'd12526, 15'd12527, 15'd12528, 15'd12529, 15'd12530, 15'd12537, 15'd12538, 15'd12539, 15'd12540, 15'd12541, 15'd12542, 15'd12543, 15'd12544, 15'd12545, 15'd12546, 15'd12547, 15'd12548, 15'd12549, 15'd12550, 15'd12551, 15'd12552, 15'd12553, 15'd12554, 15'd12673, 15'd12674, 15'd12675, 15'd12676, 15'd12677, 15'd12678, 15'd12679, 15'd12680, 15'd12681, 15'd12682, 15'd12683, 15'd12684, 15'd12685, 15'd12686, 15'd12687, 15'd12688, 15'd12689, 15'd12690, 15'd12697, 15'd12698, 15'd12699, 15'd12700, 15'd12701, 15'd12702, 15'd12703, 15'd12704, 15'd12705, 15'd12706, 15'd12707, 15'd12708, 15'd12709, 15'd12710, 15'd12711, 15'd12712, 15'd12713, 15'd12714, 15'd12715, 15'd12833, 15'd12834, 15'd12835, 15'd12836, 15'd12837, 15'd12838, 15'd12839, 15'd12840, 15'd12841, 15'd12842, 15'd12843, 15'd12844, 15'd12845, 15'd12846, 15'd12847, 15'd12848, 15'd12849, 15'd12858, 15'd12859, 15'd12860, 15'd12861, 15'd12862, 15'd12863, 15'd12864, 15'd12865, 15'd12866, 15'd12867, 15'd12868, 15'd12869, 15'd12870, 15'd12871, 15'd12872, 15'd12873, 15'd12874, 15'd12875, 15'd12992, 15'd12993, 15'd12994, 15'd12995, 15'd12996, 15'd12997, 15'd12998, 15'd12999, 15'd13000, 15'd13001, 15'd13002, 15'd13003, 15'd13004, 15'd13005, 15'd13006, 15'd13007, 15'd13008, 15'd13009, 15'd13018, 15'd13019, 15'd13020, 15'd13021, 15'd13022, 15'd13023, 15'd13024, 15'd13025, 15'd13026, 15'd13027, 15'd13028, 15'd13029, 15'd13030, 15'd13031, 15'd13032, 15'd13033, 15'd13034, 15'd13035, 15'd13036, 15'd13152, 15'd13153, 15'd13154, 15'd13155, 15'd13156, 15'd13157, 15'd13158, 15'd13159, 15'd13160, 15'd13161, 15'd13162, 15'd13163, 15'd13164, 15'd13165, 15'd13166, 15'd13167, 15'd13168, 15'd13169, 15'd13179, 15'd13180, 15'd13181, 15'd13182, 15'd13183, 15'd13184, 15'd13185, 15'd13186, 15'd13187, 15'd13188, 15'd13189, 15'd13190, 15'd13191, 15'd13192, 15'd13193, 15'd13194, 15'd13195, 15'd13196, 15'd13197, 15'd13311, 15'd13312, 15'd13313, 15'd13314, 15'd13315, 15'd13316, 15'd13317, 15'd13318, 15'd13319, 15'd13320, 15'd13321, 15'd13322, 15'd13323, 15'd13324, 15'd13325, 15'd13326, 15'd13327, 15'd13328, 15'd13339, 15'd13340, 15'd13341, 15'd13342, 15'd13343, 15'd13344, 15'd13345, 15'd13346, 15'd13347, 15'd13348, 15'd13349, 15'd13350, 15'd13351, 15'd13352, 15'd13353, 15'd13354, 15'd13355, 15'd13356, 15'd13357, 15'd13471, 15'd13472, 15'd13473, 15'd13474, 15'd13475, 15'd13476, 15'd13477, 15'd13478, 15'd13479, 15'd13480, 15'd13481, 15'd13482, 15'd13483, 15'd13484, 15'd13485, 15'd13486, 15'd13487, 15'd13488, 15'd13500, 15'd13501, 15'd13502, 15'd13503, 15'd13504, 15'd13505, 15'd13506, 15'd13507, 15'd13508, 15'd13509, 15'd13510, 15'd13511, 15'd13512, 15'd13513, 15'd13514, 15'd13515, 15'd13516, 15'd13517, 15'd13518, 15'd13630, 15'd13631, 15'd13632, 15'd13633, 15'd13634, 15'd13635, 15'd13636, 15'd13637, 15'd13638, 15'd13639, 15'd13640, 15'd13641, 15'd13642, 15'd13643, 15'd13644, 15'd13645, 15'd13646, 15'd13647, 15'd13660, 15'd13661, 15'd13662, 15'd13663, 15'd13664, 15'd13665, 15'd13666, 15'd13667, 15'd13668, 15'd13669, 15'd13670, 15'd13671, 15'd13672, 15'd13673, 15'd13674, 15'd13675, 15'd13676, 15'd13677, 15'd13678, 15'd13790, 15'd13791, 15'd13792, 15'd13793, 15'd13794, 15'd13795, 15'd13796, 15'd13797, 15'd13798, 15'd13799, 15'd13800, 15'd13801, 15'd13802, 15'd13803, 15'd13804, 15'd13805, 15'd13806, 15'd13821, 15'd13822, 15'd13823, 15'd13824, 15'd13825, 15'd13826, 15'd13827, 15'd13828, 15'd13829, 15'd13830, 15'd13831, 15'd13832, 15'd13833, 15'd13834, 15'd13835, 15'd13836, 15'd13837, 15'd13838, 15'd13839, 15'd13949, 15'd13950, 15'd13951, 15'd13952, 15'd13953, 15'd13954, 15'd13955, 15'd13956, 15'd13957, 15'd13958, 15'd13959, 15'd13960, 15'd13961, 15'd13962, 15'd13963, 15'd13964, 15'd13965, 15'd13966, 15'd13981, 15'd13982, 15'd13983, 15'd13984, 15'd13985, 15'd13986, 15'd13987, 15'd13988, 15'd13989, 15'd13990, 15'd13991, 15'd13992, 15'd13993, 15'd13994, 15'd13995, 15'd13996, 15'd13997, 15'd13998, 15'd13999, 15'd14109, 15'd14110, 15'd14111, 15'd14112, 15'd14113, 15'd14114, 15'd14115, 15'd14116, 15'd14117, 15'd14118, 15'd14119, 15'd14120, 15'd14121, 15'd14122, 15'd14123, 15'd14124, 15'd14125, 15'd14126, 15'd14142, 15'd14143, 15'd14144, 15'd14145, 15'd14146, 15'd14147, 15'd14148, 15'd14149, 15'd14150, 15'd14151, 15'd14152, 15'd14153, 15'd14154, 15'd14155, 15'd14156, 15'd14157, 15'd14158, 15'd14159, 15'd14268, 15'd14269, 15'd14270, 15'd14271, 15'd14272, 15'd14273, 15'd14274, 15'd14275, 15'd14276, 15'd14277, 15'd14278, 15'd14279, 15'd14280, 15'd14281, 15'd14282, 15'd14283, 15'd14284, 15'd14285, 15'd14302, 15'd14303, 15'd14304, 15'd14305, 15'd14306, 15'd14307, 15'd14308, 15'd14309, 15'd14310, 15'd14311, 15'd14312, 15'd14313, 15'd14314, 15'd14315, 15'd14316, 15'd14317, 15'd14318, 15'd14319, 15'd14320, 15'd14428, 15'd14429, 15'd14430, 15'd14431, 15'd14432, 15'd14433, 15'd14434, 15'd14435, 15'd14436, 15'd14437, 15'd14438, 15'd14439, 15'd14440, 15'd14441, 15'd14442, 15'd14443, 15'd14444, 15'd14445, 15'd14463, 15'd14464, 15'd14465, 15'd14466, 15'd14467, 15'd14468, 15'd14469, 15'd14470, 15'd14471, 15'd14472, 15'd14473, 15'd14474, 15'd14475, 15'd14476, 15'd14477, 15'd14478, 15'd14479, 15'd14480, 15'd14481, 15'd14587, 15'd14588, 15'd14589, 15'd14590, 15'd14591, 15'd14592, 15'd14593, 15'd14594, 15'd14595, 15'd14596, 15'd14597, 15'd14598, 15'd14599, 15'd14600, 15'd14601, 15'd14602, 15'd14603, 15'd14604, 15'd14623, 15'd14624, 15'd14625, 15'd14626, 15'd14627, 15'd14628, 15'd14629, 15'd14630, 15'd14631, 15'd14632, 15'd14633, 15'd14634, 15'd14635, 15'd14636, 15'd14637, 15'd14638, 15'd14639, 15'd14640, 15'd14641, 15'd14747, 15'd14748, 15'd14749, 15'd14750, 15'd14751, 15'd14752, 15'd14753, 15'd14754, 15'd14755, 15'd14756, 15'd14757, 15'd14758, 15'd14759, 15'd14760, 15'd14761, 15'd14762, 15'd14763, 15'd14784, 15'd14785, 15'd14786, 15'd14787, 15'd14788, 15'd14789, 15'd14790, 15'd14791, 15'd14792, 15'd14793, 15'd14794, 15'd14795, 15'd14796, 15'd14797, 15'd14798, 15'd14799, 15'd14800, 15'd14801, 15'd14802, 15'd14906, 15'd14907, 15'd14908, 15'd14909, 15'd14910, 15'd14911, 15'd14912, 15'd14913, 15'd14914, 15'd14915, 15'd14916, 15'd14917, 15'd14918, 15'd14919, 15'd14920, 15'd14921, 15'd14922, 15'd14923, 15'd14945, 15'd14946, 15'd14947, 15'd14948, 15'd14949, 15'd14950, 15'd14951, 15'd14952, 15'd14953, 15'd14954, 15'd14955, 15'd14956, 15'd14957, 15'd14958, 15'd14959, 15'd14960, 15'd14961, 15'd14962, 15'd15066, 15'd15067, 15'd15068, 15'd15069, 15'd15070, 15'd15071, 15'd15072, 15'd15073, 15'd15074, 15'd15075, 15'd15076, 15'd15077, 15'd15078, 15'd15079, 15'd15080, 15'd15081, 15'd15082, 15'd15083, 15'd15105, 15'd15106, 15'd15107, 15'd15108, 15'd15109, 15'd15110, 15'd15111, 15'd15112, 15'd15113, 15'd15114, 15'd15115, 15'd15116, 15'd15117, 15'd15118, 15'd15119, 15'd15120, 15'd15121, 15'd15122, 15'd15123, 15'd15225, 15'd15226, 15'd15227, 15'd15228, 15'd15229, 15'd15230, 15'd15231, 15'd15232, 15'd15233, 15'd15234, 15'd15235, 15'd15236, 15'd15237, 15'd15238, 15'd15239, 15'd15240, 15'd15241, 15'd15242, 15'd15266, 15'd15267, 15'd15268, 15'd15269, 15'd15270, 15'd15271, 15'd15272, 15'd15273, 15'd15274, 15'd15275, 15'd15276, 15'd15277, 15'd15278, 15'd15279, 15'd15280, 15'd15281, 15'd15282, 15'd15283, 15'd15385, 15'd15386, 15'd15387, 15'd15388, 15'd15389, 15'd15390, 15'd15391, 15'd15392, 15'd15393, 15'd15394, 15'd15395, 15'd15396, 15'd15397, 15'd15398, 15'd15399, 15'd15400, 15'd15401, 15'd15402, 15'd15426, 15'd15427, 15'd15428, 15'd15429, 15'd15430, 15'd15431, 15'd15432, 15'd15433, 15'd15434, 15'd15435, 15'd15436, 15'd15437, 15'd15438, 15'd15439, 15'd15440, 15'd15441, 15'd15442, 15'd15443, 15'd15444, 15'd15544, 15'd15545, 15'd15546, 15'd15547, 15'd15548, 15'd15549, 15'd15550, 15'd15551, 15'd15552, 15'd15553, 15'd15554, 15'd15555, 15'd15556, 15'd15557, 15'd15558, 15'd15559, 15'd15560, 15'd15561, 15'd15587, 15'd15588, 15'd15589, 15'd15590, 15'd15591, 15'd15592, 15'd15593, 15'd15594, 15'd15595, 15'd15596, 15'd15597, 15'd15598, 15'd15599, 15'd15600, 15'd15601, 15'd15602, 15'd15603, 15'd15604, 15'd15704, 15'd15705, 15'd15706, 15'd15707, 15'd15708, 15'd15709, 15'd15710, 15'd15711, 15'd15712, 15'd15713, 15'd15714, 15'd15715, 15'd15716, 15'd15717, 15'd15718, 15'd15719, 15'd15720, 15'd15721, 15'd15747, 15'd15748, 15'd15749, 15'd15750, 15'd15751, 15'd15752, 15'd15753, 15'd15754, 15'd15755, 15'd15756, 15'd15757, 15'd15758, 15'd15759, 15'd15760, 15'd15761, 15'd15762, 15'd15763, 15'd15764, 15'd15765, 15'd15863, 15'd15864, 15'd15865, 15'd15866, 15'd15867, 15'd15868, 15'd15869, 15'd15870, 15'd15871, 15'd15872, 15'd15873, 15'd15874, 15'd15875, 15'd15876, 15'd15877, 15'd15878, 15'd15879, 15'd15880, 15'd15908, 15'd15909, 15'd15910, 15'd15911, 15'd15912, 15'd15913, 15'd15914, 15'd15915, 15'd15916, 15'd15917, 15'd15918, 15'd15919, 15'd15920, 15'd15921, 15'd15922, 15'd15923, 15'd15924, 15'd15925, 15'd16023, 15'd16024, 15'd16025, 15'd16026, 15'd16027, 15'd16028, 15'd16029, 15'd16030, 15'd16031, 15'd16032, 15'd16033, 15'd16034, 15'd16035, 15'd16036, 15'd16037, 15'd16038, 15'd16039, 15'd16040, 15'd16068, 15'd16069, 15'd16070, 15'd16071, 15'd16072, 15'd16073, 15'd16074, 15'd16075, 15'd16076, 15'd16077, 15'd16078, 15'd16079, 15'd16080, 15'd16081, 15'd16082, 15'd16083, 15'd16084, 15'd16085, 15'd16086, 15'd16182, 15'd16183, 15'd16184, 15'd16185, 15'd16186, 15'd16187, 15'd16188, 15'd16189, 15'd16190, 15'd16191, 15'd16192, 15'd16193, 15'd16194, 15'd16195, 15'd16196, 15'd16197, 15'd16198, 15'd16199, 15'd16229, 15'd16230, 15'd16231, 15'd16232, 15'd16233, 15'd16234, 15'd16235, 15'd16236, 15'd16237, 15'd16238, 15'd16239, 15'd16240, 15'd16241, 15'd16242, 15'd16243, 15'd16244, 15'd16245, 15'd16246, 15'd16342, 15'd16343, 15'd16344, 15'd16345, 15'd16346, 15'd16347, 15'd16348, 15'd16349, 15'd16350, 15'd16351, 15'd16352, 15'd16353, 15'd16354, 15'd16355, 15'd16356, 15'd16357, 15'd16358, 15'd16359, 15'd16389, 15'd16390, 15'd16391, 15'd16392, 15'd16393, 15'd16394, 15'd16395, 15'd16396, 15'd16397, 15'd16398, 15'd16399, 15'd16400, 15'd16401, 15'd16402, 15'd16403, 15'd16404, 15'd16405, 15'd16406, 15'd16407, 15'd16501, 15'd16502, 15'd16503, 15'd16504, 15'd16505, 15'd16506, 15'd16507, 15'd16508, 15'd16509, 15'd16510, 15'd16511, 15'd16512, 15'd16513, 15'd16514, 15'd16515, 15'd16516, 15'd16517, 15'd16518, 15'd16550, 15'd16551, 15'd16552, 15'd16553, 15'd16554, 15'd16555, 15'd16556, 15'd16557, 15'd16558, 15'd16559, 15'd16560, 15'd16561, 15'd16562, 15'd16563, 15'd16564, 15'd16565, 15'd16566, 15'd16567, 15'd16661, 15'd16662, 15'd16663, 15'd16664, 15'd16665, 15'd16666, 15'd16667, 15'd16668, 15'd16669, 15'd16670, 15'd16671, 15'd16672, 15'd16673, 15'd16674, 15'd16675, 15'd16676, 15'd16677, 15'd16678, 15'd16710, 15'd16711, 15'd16712, 15'd16713, 15'd16714, 15'd16715, 15'd16716, 15'd16717, 15'd16718, 15'd16719, 15'd16720, 15'd16721, 15'd16722, 15'd16723, 15'd16724, 15'd16725, 15'd16726, 15'd16727, 15'd16728, 15'd16820, 15'd16821, 15'd16822, 15'd16823, 15'd16824, 15'd16825, 15'd16826, 15'd16827, 15'd16828, 15'd16829, 15'd16830, 15'd16831, 15'd16832, 15'd16833, 15'd16834, 15'd16835, 15'd16836, 15'd16837, 15'd16871, 15'd16872, 15'd16873, 15'd16874, 15'd16875, 15'd16876, 15'd16877, 15'd16878, 15'd16879, 15'd16880, 15'd16881, 15'd16882, 15'd16883, 15'd16884, 15'd16885, 15'd16886, 15'd16887, 15'd16888, 15'd16980, 15'd16981, 15'd16982, 15'd16983, 15'd16984, 15'd16985, 15'd16986, 15'd16987, 15'd16988, 15'd16989, 15'd16990, 15'd16991, 15'd16992, 15'd16993, 15'd16994, 15'd16995, 15'd16996, 15'd16997, 15'd17032, 15'd17033, 15'd17034, 15'd17035, 15'd17036, 15'd17037, 15'd17038, 15'd17039, 15'd17040, 15'd17041, 15'd17042, 15'd17043, 15'd17044, 15'd17045, 15'd17046, 15'd17047, 15'd17048, 15'd17049, 15'd17139, 15'd17140, 15'd17141, 15'd17142, 15'd17143, 15'd17144, 15'd17145, 15'd17146, 15'd17147, 15'd17148, 15'd17149, 15'd17150, 15'd17151, 15'd17152, 15'd17153, 15'd17154, 15'd17155, 15'd17156, 15'd17192, 15'd17193, 15'd17194, 15'd17195, 15'd17196, 15'd17197, 15'd17198, 15'd17199, 15'd17200, 15'd17201, 15'd17202, 15'd17203, 15'd17204, 15'd17205, 15'd17206, 15'd17207, 15'd17208, 15'd17209, 15'd17299, 15'd17300, 15'd17301, 15'd17302, 15'd17303, 15'd17304, 15'd17305, 15'd17306, 15'd17307, 15'd17308, 15'd17309, 15'd17310, 15'd17311, 15'd17312, 15'd17313, 15'd17314, 15'd17315, 15'd17316, 15'd17353, 15'd17354, 15'd17355, 15'd17356, 15'd17357, 15'd17358, 15'd17359, 15'd17360, 15'd17361, 15'd17362, 15'd17363, 15'd17364, 15'd17365, 15'd17366, 15'd17367, 15'd17368, 15'd17369, 15'd17370, 15'd17458, 15'd17459, 15'd17460, 15'd17461, 15'd17462, 15'd17463, 15'd17464, 15'd17465, 15'd17466, 15'd17467, 15'd17468, 15'd17469, 15'd17470, 15'd17471, 15'd17472, 15'd17473, 15'd17474, 15'd17475, 15'd17513, 15'd17514, 15'd17515, 15'd17516, 15'd17517, 15'd17518, 15'd17519, 15'd17520, 15'd17521, 15'd17522, 15'd17523, 15'd17524, 15'd17525, 15'd17526, 15'd17527, 15'd17528, 15'd17529, 15'd17530, 15'd17618, 15'd17619, 15'd17620, 15'd17621, 15'd17622, 15'd17623, 15'd17624, 15'd17625, 15'd17626, 15'd17627, 15'd17628, 15'd17629, 15'd17630, 15'd17631, 15'd17632, 15'd17633, 15'd17634, 15'd17635, 15'd17674, 15'd17675, 15'd17676, 15'd17677, 15'd17678, 15'd17679, 15'd17680, 15'd17681, 15'd17682, 15'd17683, 15'd17684, 15'd17685, 15'd17686, 15'd17687, 15'd17688, 15'd17689, 15'd17690, 15'd17691, 15'd17777, 15'd17778, 15'd17779, 15'd17780, 15'd17781, 15'd17782, 15'd17783, 15'd17784, 15'd17785, 15'd17786, 15'd17787, 15'd17788, 15'd17789, 15'd17790, 15'd17791, 15'd17792, 15'd17793, 15'd17794, 15'd17795, 15'd17834, 15'd17835, 15'd17836, 15'd17837, 15'd17838, 15'd17839, 15'd17840, 15'd17841, 15'd17842, 15'd17843, 15'd17844, 15'd17845, 15'd17846, 15'd17847, 15'd17848, 15'd17849, 15'd17850, 15'd17851, 15'd17937, 15'd17938, 15'd17939, 15'd17940, 15'd17941, 15'd17942, 15'd17943, 15'd17944, 15'd17945, 15'd17946, 15'd17947, 15'd17948, 15'd17949, 15'd17950, 15'd17951, 15'd17952, 15'd17953, 15'd17954, 15'd17955, 15'd17956, 15'd17957, 15'd17958, 15'd17959, 15'd17960, 15'd17961, 15'd17962, 15'd17963, 15'd17964, 15'd17965, 15'd17966, 15'd17967, 15'd17968, 15'd17969, 15'd17970, 15'd17971, 15'd17972, 15'd17973, 15'd17974, 15'd17975, 15'd17976, 15'd17977, 15'd17978, 15'd17995, 15'd17996, 15'd17997, 15'd17998, 15'd17999, 15'd18000, 15'd18001, 15'd18002, 15'd18003, 15'd18004, 15'd18005, 15'd18006, 15'd18007, 15'd18008, 15'd18009, 15'd18010, 15'd18011, 15'd18012, 15'd18096, 15'd18097, 15'd18098, 15'd18099, 15'd18100, 15'd18101, 15'd18102, 15'd18103, 15'd18104, 15'd18105, 15'd18106, 15'd18107, 15'd18108, 15'd18109, 15'd18110, 15'd18111, 15'd18112, 15'd18113, 15'd18114, 15'd18115, 15'd18116, 15'd18117, 15'd18118, 15'd18119, 15'd18120, 15'd18121, 15'd18122, 15'd18123, 15'd18124, 15'd18125, 15'd18126, 15'd18127, 15'd18128, 15'd18129, 15'd18130, 15'd18131, 15'd18132, 15'd18133, 15'd18134, 15'd18135, 15'd18136, 15'd18137, 15'd18138, 15'd18155, 15'd18156, 15'd18157, 15'd18158, 15'd18159, 15'd18160, 15'd18161, 15'd18162, 15'd18163, 15'd18164, 15'd18165, 15'd18166, 15'd18167, 15'd18168, 15'd18169, 15'd18170, 15'd18171, 15'd18172, 15'd18256, 15'd18257, 15'd18258, 15'd18259, 15'd18260, 15'd18261, 15'd18262, 15'd18263, 15'd18264, 15'd18265, 15'd18266, 15'd18267, 15'd18268, 15'd18269, 15'd18270, 15'd18271, 15'd18272, 15'd18273, 15'd18274, 15'd18275, 15'd18276, 15'd18277, 15'd18278, 15'd18279, 15'd18280, 15'd18281, 15'd18282, 15'd18283, 15'd18284, 15'd18285, 15'd18286, 15'd18287, 15'd18288, 15'd18289, 15'd18290, 15'd18291, 15'd18292, 15'd18293, 15'd18294, 15'd18295, 15'd18296, 15'd18297, 15'd18298, 15'd18299, 15'd18316, 15'd18317, 15'd18318, 15'd18319, 15'd18320, 15'd18321, 15'd18322, 15'd18323, 15'd18324, 15'd18325, 15'd18326, 15'd18327, 15'd18328, 15'd18329, 15'd18330, 15'd18331, 15'd18332, 15'd18333, 15'd18415, 15'd18416, 15'd18417, 15'd18418, 15'd18419, 15'd18420, 15'd18421, 15'd18422, 15'd18423, 15'd18424, 15'd18425, 15'd18426, 15'd18427, 15'd18428, 15'd18429, 15'd18430, 15'd18431, 15'd18432, 15'd18433, 15'd18434, 15'd18435, 15'd18436, 15'd18437, 15'd18438, 15'd18439, 15'd18440, 15'd18441, 15'd18442, 15'd18443, 15'd18444, 15'd18445, 15'd18446, 15'd18447, 15'd18448, 15'd18449, 15'd18450, 15'd18451, 15'd18452, 15'd18453, 15'd18454, 15'd18455, 15'd18456, 15'd18457, 15'd18458, 15'd18459, 15'd18476, 15'd18477, 15'd18478, 15'd18479, 15'd18480, 15'd18481, 15'd18482, 15'd18483, 15'd18484, 15'd18485, 15'd18486, 15'd18487, 15'd18488, 15'd18489, 15'd18490, 15'd18491, 15'd18492, 15'd18493, 15'd18575, 15'd18576, 15'd18577, 15'd18578, 15'd18579, 15'd18580, 15'd18581, 15'd18582, 15'd18583, 15'd18584, 15'd18585, 15'd18586, 15'd18587, 15'd18588, 15'd18589, 15'd18590, 15'd18591, 15'd18592, 15'd18593, 15'd18594, 15'd18595, 15'd18596, 15'd18597, 15'd18598, 15'd18599, 15'd18600, 15'd18601, 15'd18602, 15'd18603, 15'd18604, 15'd18605, 15'd18606, 15'd18607, 15'd18608, 15'd18609, 15'd18610, 15'd18611, 15'd18612, 15'd18613, 15'd18614, 15'd18615, 15'd18616, 15'd18617, 15'd18618, 15'd18619, 15'd18620, 15'd18637, 15'd18638, 15'd18639, 15'd18640, 15'd18641, 15'd18642, 15'd18643, 15'd18644, 15'd18645, 15'd18646, 15'd18647, 15'd18648, 15'd18649, 15'd18650, 15'd18651, 15'd18652, 15'd18653, 15'd18654, 15'd18734, 15'd18735, 15'd18736, 15'd18737, 15'd18738, 15'd18739, 15'd18740, 15'd18741, 15'd18742, 15'd18743, 15'd18744, 15'd18745, 15'd18746, 15'd18747, 15'd18748, 15'd18749, 15'd18750, 15'd18751, 15'd18752, 15'd18753, 15'd18754, 15'd18755, 15'd18756, 15'd18757, 15'd18758, 15'd18759, 15'd18760, 15'd18761, 15'd18762, 15'd18763, 15'd18764, 15'd18765, 15'd18766, 15'd18767, 15'd18768, 15'd18769, 15'd18770, 15'd18771, 15'd18772, 15'd18773, 15'd18774, 15'd18775, 15'd18776, 15'd18777, 15'd18778, 15'd18779, 15'd18780, 15'd18781, 15'd18797, 15'd18798, 15'd18799, 15'd18800, 15'd18801, 15'd18802, 15'd18803, 15'd18804, 15'd18805, 15'd18806, 15'd18807, 15'd18808, 15'd18809, 15'd18810, 15'd18811, 15'd18812, 15'd18813, 15'd18814, 15'd18894, 15'd18895, 15'd18896, 15'd18897, 15'd18898, 15'd18899, 15'd18900, 15'd18901, 15'd18902, 15'd18903, 15'd18904, 15'd18905, 15'd18906, 15'd18907, 15'd18908, 15'd18909, 15'd18910, 15'd18911, 15'd18912, 15'd18913, 15'd18914, 15'd18915, 15'd18916, 15'd18917, 15'd18918, 15'd18919, 15'd18920, 15'd18921, 15'd18922, 15'd18923, 15'd18924, 15'd18925, 15'd18926, 15'd18927, 15'd18928, 15'd18929, 15'd18930, 15'd18931, 15'd18932, 15'd18933, 15'd18934, 15'd18935, 15'd18936, 15'd18937, 15'd18938, 15'd18939, 15'd18940, 15'd18941, 15'd18958, 15'd18959, 15'd18960, 15'd18961, 15'd18962, 15'd18963, 15'd18964, 15'd18965, 15'd18966, 15'd18967, 15'd18968, 15'd18969, 15'd18970, 15'd18971, 15'd18972, 15'd18973, 15'd18974, 15'd18975, 15'd19053, 15'd19054, 15'd19055, 15'd19056, 15'd19057, 15'd19058, 15'd19059, 15'd19060, 15'd19061, 15'd19062, 15'd19063, 15'd19064, 15'd19065, 15'd19066, 15'd19067, 15'd19068, 15'd19069, 15'd19070, 15'd19071, 15'd19072, 15'd19073, 15'd19074, 15'd19075, 15'd19076, 15'd19077, 15'd19078, 15'd19079, 15'd19080, 15'd19081, 15'd19082, 15'd19083, 15'd19084, 15'd19085, 15'd19086, 15'd19087, 15'd19088, 15'd19089, 15'd19090, 15'd19091, 15'd19092, 15'd19093, 15'd19094, 15'd19095, 15'd19096, 15'd19097, 15'd19098, 15'd19099, 15'd19100, 15'd19101, 15'd19102, 15'd19119, 15'd19120, 15'd19121, 15'd19122, 15'd19123, 15'd19124, 15'd19125, 15'd19126, 15'd19127, 15'd19128, 15'd19129, 15'd19130, 15'd19131, 15'd19132, 15'd19133, 15'd19134, 15'd19135, 15'd19213, 15'd19214, 15'd19215, 15'd19216, 15'd19217, 15'd19218, 15'd19219, 15'd19220, 15'd19221, 15'd19222, 15'd19223, 15'd19224, 15'd19225, 15'd19226, 15'd19227, 15'd19228, 15'd19229, 15'd19230, 15'd19231, 15'd19232, 15'd19233, 15'd19234, 15'd19235, 15'd19236, 15'd19237, 15'd19238, 15'd19239, 15'd19240, 15'd19241, 15'd19242, 15'd19243, 15'd19244, 15'd19245, 15'd19246, 15'd19247, 15'd19248, 15'd19249, 15'd19250, 15'd19251, 15'd19252, 15'd19253, 15'd19254, 15'd19255, 15'd19256, 15'd19257, 15'd19258, 15'd19259, 15'd19260, 15'd19261, 15'd19262, 15'd19279, 15'd19280, 15'd19281, 15'd19282, 15'd19283, 15'd19284, 15'd19285, 15'd19286, 15'd19287, 15'd19288, 15'd19289, 15'd19290, 15'd19291, 15'd19292, 15'd19293, 15'd19294, 15'd19295, 15'd19296, 15'd19372, 15'd19373, 15'd19374, 15'd19375, 15'd19376, 15'd19377, 15'd19378, 15'd19379, 15'd19380, 15'd19381, 15'd19382, 15'd19383, 15'd19384, 15'd19385, 15'd19386, 15'd19387, 15'd19388, 15'd19389, 15'd19390, 15'd19391, 15'd19392, 15'd19393, 15'd19394, 15'd19395, 15'd19396, 15'd19397, 15'd19398, 15'd19399, 15'd19400, 15'd19401, 15'd19402, 15'd19403, 15'd19404, 15'd19405, 15'd19406, 15'd19407, 15'd19408, 15'd19409, 15'd19410, 15'd19411, 15'd19412, 15'd19413, 15'd19414, 15'd19415, 15'd19416, 15'd19417, 15'd19418, 15'd19419, 15'd19420, 15'd19421, 15'd19422, 15'd19423, 15'd19440, 15'd19441, 15'd19442, 15'd19443, 15'd19444, 15'd19445, 15'd19446, 15'd19447, 15'd19448, 15'd19449, 15'd19450, 15'd19451, 15'd19452, 15'd19453, 15'd19454, 15'd19455, 15'd19456, 15'd19532, 15'd19533, 15'd19534, 15'd19535, 15'd19536, 15'd19537, 15'd19538, 15'd19539, 15'd19540, 15'd19541, 15'd19542, 15'd19543, 15'd19544, 15'd19545, 15'd19546, 15'd19547, 15'd19548, 15'd19549, 15'd19550, 15'd19551, 15'd19552, 15'd19553, 15'd19554, 15'd19555, 15'd19556, 15'd19557, 15'd19558, 15'd19559, 15'd19560, 15'd19561, 15'd19562, 15'd19563, 15'd19564, 15'd19565, 15'd19566, 15'd19567, 15'd19568, 15'd19569, 15'd19570, 15'd19571, 15'd19572, 15'd19573, 15'd19574, 15'd19575, 15'd19576, 15'd19577, 15'd19578, 15'd19579, 15'd19580, 15'd19581, 15'd19582, 15'd19583, 15'd19600, 15'd19601, 15'd19602, 15'd19603, 15'd19604, 15'd19605, 15'd19606, 15'd19607, 15'd19608, 15'd19609, 15'd19610, 15'd19611, 15'd19612, 15'd19613, 15'd19614, 15'd19615, 15'd19616, 15'd19617, 15'd19691, 15'd19692, 15'd19693, 15'd19694, 15'd19695, 15'd19696, 15'd19697, 15'd19698, 15'd19699, 15'd19700, 15'd19701, 15'd19702, 15'd19703, 15'd19704, 15'd19705, 15'd19706, 15'd19707, 15'd19708, 15'd19709, 15'd19710, 15'd19711, 15'd19712, 15'd19713, 15'd19714, 15'd19715, 15'd19716, 15'd19717, 15'd19718, 15'd19719, 15'd19720, 15'd19721, 15'd19722, 15'd19723, 15'd19724, 15'd19725, 15'd19726, 15'd19727, 15'd19728, 15'd19729, 15'd19730, 15'd19731, 15'd19732, 15'd19733, 15'd19734, 15'd19735, 15'd19736, 15'd19737, 15'd19738, 15'd19739, 15'd19740, 15'd19741, 15'd19742, 15'd19743, 15'd19744, 15'd19761, 15'd19762, 15'd19763, 15'd19764, 15'd19765, 15'd19766, 15'd19767, 15'd19768, 15'd19769, 15'd19770, 15'd19771, 15'd19772, 15'd19773, 15'd19774, 15'd19775, 15'd19776, 15'd19777, 15'd19851, 15'd19852, 15'd19853, 15'd19854, 15'd19855, 15'd19856, 15'd19857, 15'd19858, 15'd19859, 15'd19860, 15'd19861, 15'd19862, 15'd19863, 15'd19864, 15'd19865, 15'd19866, 15'd19867, 15'd19868, 15'd19869, 15'd19870, 15'd19871, 15'd19872, 15'd19873, 15'd19874, 15'd19875, 15'd19876, 15'd19877, 15'd19878, 15'd19879, 15'd19880, 15'd19881, 15'd19882, 15'd19883, 15'd19884, 15'd19885, 15'd19886, 15'd19887, 15'd19888, 15'd19889, 15'd19890, 15'd19891, 15'd19892, 15'd19893, 15'd19894, 15'd19895, 15'd19896, 15'd19897, 15'd19898, 15'd19899, 15'd19900, 15'd19901, 15'd19902, 15'd19903, 15'd19904, 15'd19921, 15'd19922, 15'd19923, 15'd19924, 15'd19925, 15'd19926, 15'd19927, 15'd19928, 15'd19929, 15'd19930, 15'd19931, 15'd19932, 15'd19933, 15'd19934, 15'd19935, 15'd19936, 15'd19937, 15'd19938, 15'd20010, 15'd20011, 15'd20012, 15'd20013, 15'd20014, 15'd20015, 15'd20016, 15'd20017, 15'd20018, 15'd20019, 15'd20020, 15'd20021, 15'd20022, 15'd20023, 15'd20024, 15'd20025, 15'd20026, 15'd20027, 15'd20028, 15'd20029, 15'd20030, 15'd20031, 15'd20032, 15'd20033, 15'd20034, 15'd20035, 15'd20036, 15'd20037, 15'd20038, 15'd20039, 15'd20040, 15'd20041, 15'd20042, 15'd20043, 15'd20044, 15'd20045, 15'd20046, 15'd20047, 15'd20048, 15'd20049, 15'd20050, 15'd20051, 15'd20052, 15'd20053, 15'd20054, 15'd20055, 15'd20056, 15'd20057, 15'd20058, 15'd20059, 15'd20060, 15'd20061, 15'd20062, 15'd20063, 15'd20064, 15'd20065, 15'd20082, 15'd20083, 15'd20084, 15'd20085, 15'd20086, 15'd20087, 15'd20088, 15'd20089, 15'd20090, 15'd20091, 15'd20092, 15'd20093, 15'd20094, 15'd20095, 15'd20096, 15'd20097, 15'd20098: base_color = 2'd1;
            15'd5822, 15'd5823, 15'd5824, 15'd5825, 15'd5826, 15'd5827, 15'd5828, 15'd5829, 15'd5830, 15'd5831, 15'd5832, 15'd5833, 15'd5834, 15'd5835, 15'd5836, 15'd5837, 15'd5838, 15'd5839, 15'd5840, 15'd5841, 15'd5842, 15'd5843, 15'd5844, 15'd5845, 15'd5846, 15'd5847, 15'd5848, 15'd5849, 15'd5850, 15'd5851, 15'd5852, 15'd5853, 15'd5854, 15'd5855, 15'd5856, 15'd5857, 15'd5858, 15'd5859, 15'd5860, 15'd5861, 15'd5862, 15'd5863, 15'd5864, 15'd5865, 15'd5866, 15'd5867, 15'd5868, 15'd5869, 15'd5870, 15'd5871, 15'd5872, 15'd5873, 15'd5874, 15'd5875, 15'd5876, 15'd5877, 15'd5878, 15'd5879, 15'd5880, 15'd5881, 15'd5882, 15'd5883, 15'd5884, 15'd5885, 15'd5886, 15'd5887, 15'd5888, 15'd5889, 15'd5890, 15'd5891, 15'd5892, 15'd5893, 15'd5894, 15'd5895, 15'd5896, 15'd5897, 15'd5898, 15'd5899, 15'd5900, 15'd5901, 15'd5902, 15'd5903, 15'd5904, 15'd5905, 15'd5906, 15'd5907, 15'd5908, 15'd5909, 15'd5983, 15'd5984, 15'd5985, 15'd5986, 15'd5987, 15'd5988, 15'd5989, 15'd5990, 15'd5991, 15'd5992, 15'd5993, 15'd5994, 15'd5995, 15'd5996, 15'd5997, 15'd5998, 15'd5999, 15'd6000, 15'd6001, 15'd6002, 15'd6003, 15'd6004, 15'd6005, 15'd6006, 15'd6007, 15'd6008, 15'd6009, 15'd6010, 15'd6011, 15'd6012, 15'd6013, 15'd6014, 15'd6015, 15'd6016, 15'd6017, 15'd6018, 15'd6019, 15'd6020, 15'd6021, 15'd6022, 15'd6023, 15'd6024, 15'd6025, 15'd6026, 15'd6027, 15'd6028, 15'd6029, 15'd6030, 15'd6031, 15'd6032, 15'd6033, 15'd6034, 15'd6035, 15'd6036, 15'd6037, 15'd6038, 15'd6039, 15'd6040, 15'd6041, 15'd6042, 15'd6043, 15'd6044, 15'd6045, 15'd6046, 15'd6047, 15'd6048, 15'd6049, 15'd6050, 15'd6051, 15'd6052, 15'd6053, 15'd6054, 15'd6055, 15'd6056, 15'd6057, 15'd6058, 15'd6059, 15'd6060, 15'd6061, 15'd6062, 15'd6063, 15'd6064, 15'd6065, 15'd6066, 15'd6067, 15'd6068, 15'd6069, 15'd7588, 15'd7589, 15'd7590, 15'd7591, 15'd7592, 15'd7593, 15'd7594, 15'd7595, 15'd7596, 15'd7597, 15'd7598, 15'd7599, 15'd7600, 15'd7601, 15'd7602, 15'd7603, 15'd7604, 15'd7605, 15'd7606, 15'd7607, 15'd7608, 15'd7609, 15'd7610, 15'd7611, 15'd7612, 15'd7613, 15'd7614, 15'd7615, 15'd7616, 15'd7617, 15'd7618, 15'd7619, 15'd7620, 15'd7621, 15'd7622, 15'd7623, 15'd7624, 15'd7625, 15'd7626, 15'd7627, 15'd7628, 15'd7629, 15'd7630, 15'd7631, 15'd7632, 15'd7633, 15'd7634, 15'd7635, 15'd7636, 15'd7637, 15'd7638, 15'd7639, 15'd7640, 15'd7641, 15'd7642, 15'd7643, 15'd7644, 15'd7645, 15'd7646, 15'd7647, 15'd7648, 15'd7649, 15'd7650, 15'd7651, 15'd7652, 15'd7653, 15'd7654, 15'd7655, 15'd7656, 15'd7657, 15'd7658, 15'd7659, 15'd7660, 15'd7661, 15'd7662, 15'd7663, 15'd7664, 15'd7748, 15'd7749, 15'd7750, 15'd7751, 15'd7752, 15'd7753, 15'd7754, 15'd7755, 15'd7756, 15'd7757, 15'd7758, 15'd7759, 15'd7760, 15'd7761, 15'd7762, 15'd7763, 15'd7764, 15'd7765, 15'd7766, 15'd7767, 15'd7768, 15'd7769, 15'd7770, 15'd7771, 15'd7772, 15'd7773, 15'd7774, 15'd7775, 15'd7776, 15'd7777, 15'd7778, 15'd7779, 15'd7780, 15'd7781, 15'd7782, 15'd7783, 15'd7784, 15'd7785, 15'd7786, 15'd7787, 15'd7788, 15'd7789, 15'd7790, 15'd7791, 15'd7792, 15'd7793, 15'd7794, 15'd7795, 15'd7796, 15'd7797, 15'd7798, 15'd7799, 15'd7800, 15'd7801, 15'd7802, 15'd7803, 15'd7804, 15'd7805, 15'd7806, 15'd7807, 15'd7808, 15'd7809, 15'd7810, 15'd7811, 15'd7812, 15'd7813, 15'd7814, 15'd7815, 15'd7816, 15'd7817, 15'd7818, 15'd7819, 15'd7820, 15'd7821, 15'd7822, 15'd7823, 15'd9353, 15'd9354, 15'd9355, 15'd9356, 15'd9357, 15'd9358, 15'd9359, 15'd9360, 15'd9361, 15'd9362, 15'd9363, 15'd9364, 15'd9365, 15'd9366, 15'd9367, 15'd9368, 15'd9369, 15'd9370, 15'd9371, 15'd9372, 15'd9373, 15'd9374, 15'd9375, 15'd9376, 15'd9377, 15'd9378, 15'd9379, 15'd9380, 15'd9381, 15'd9382, 15'd9383, 15'd9384, 15'd9385, 15'd9386, 15'd9387, 15'd9388, 15'd9389, 15'd9390, 15'd9391, 15'd9392, 15'd9393, 15'd9394, 15'd9395, 15'd9396, 15'd9397, 15'd9398, 15'd9399, 15'd9400, 15'd9401, 15'd9402, 15'd9403, 15'd9404, 15'd9405, 15'd9406, 15'd9407, 15'd9408, 15'd9409, 15'd9410, 15'd9411, 15'd9412, 15'd9413, 15'd9414, 15'd9415, 15'd9416, 15'd9417, 15'd9418, 15'd9514, 15'd9515, 15'd9516, 15'd9517, 15'd9518, 15'd9519, 15'd9520, 15'd9521, 15'd9522, 15'd9523, 15'd9524, 15'd9525, 15'd9526, 15'd9527, 15'd9528, 15'd9529, 15'd9530, 15'd9531, 15'd9532, 15'd9533, 15'd9534, 15'd9535, 15'd9536, 15'd9537, 15'd9538, 15'd9539, 15'd9540, 15'd9541, 15'd9542, 15'd9543, 15'd9544, 15'd9545, 15'd9546, 15'd9547, 15'd9548, 15'd9549, 15'd9550, 15'd9551, 15'd9552, 15'd9553, 15'd9554, 15'd9555, 15'd9556, 15'd9557, 15'd9558, 15'd9559, 15'd9560, 15'd9561, 15'd9562, 15'd9563, 15'd9564, 15'd9565, 15'd9566, 15'd9567, 15'd9568, 15'd9569, 15'd9570, 15'd9571, 15'd9572, 15'd9573, 15'd9574, 15'd9575, 15'd9576, 15'd9577, 15'd9578, 15'd11119, 15'd11120, 15'd11121, 15'd11122, 15'd11123, 15'd11124, 15'd11125, 15'd11126, 15'd11127, 15'd11128, 15'd11129, 15'd11130, 15'd11131, 15'd11132, 15'd11133, 15'd11134, 15'd11135, 15'd11136, 15'd11137, 15'd11138, 15'd11139, 15'd11140, 15'd11141, 15'd11142, 15'd11143, 15'd11144, 15'd11145, 15'd11146, 15'd11147, 15'd11148, 15'd11149, 15'd11150, 15'd11151, 15'd11152, 15'd11153, 15'd11154, 15'd11155, 15'd11156, 15'd11157, 15'd11158, 15'd11159, 15'd11160, 15'd11161, 15'd11162, 15'd11163, 15'd11164, 15'd11165, 15'd11166, 15'd11167, 15'd11168, 15'd11169, 15'd11170, 15'd11171, 15'd11172, 15'd11173, 15'd11279, 15'd11280, 15'd11281, 15'd11282, 15'd11283, 15'd11284, 15'd11285, 15'd11286, 15'd11287, 15'd11288, 15'd11289, 15'd11290, 15'd11291, 15'd11292, 15'd11293, 15'd11294, 15'd11295, 15'd11296, 15'd11297, 15'd11298, 15'd11299, 15'd11300, 15'd11301, 15'd11302, 15'd11303, 15'd11304, 15'd11305, 15'd11306, 15'd11307, 15'd11308, 15'd11309, 15'd11310, 15'd11311, 15'd11312, 15'd11313, 15'd11314, 15'd11315, 15'd11316, 15'd11317, 15'd11318, 15'd11319, 15'd11320, 15'd11321, 15'd11322, 15'd11323, 15'd11324, 15'd11325, 15'd11326, 15'd11327, 15'd11328, 15'd11329, 15'd11330, 15'd11331, 15'd11332, 15'd12884, 15'd12885, 15'd12886, 15'd12887, 15'd12888, 15'd12889, 15'd12890, 15'd12891, 15'd12892, 15'd12893, 15'd12894, 15'd12895, 15'd12896, 15'd12897, 15'd12898, 15'd12899, 15'd12900, 15'd12901, 15'd12902, 15'd12903, 15'd12904, 15'd12905, 15'd12906, 15'd12907, 15'd12908, 15'd12909, 15'd12910, 15'd12911, 15'd12912, 15'd12913, 15'd12914, 15'd12915, 15'd12916, 15'd12917, 15'd12918, 15'd12919, 15'd12920, 15'd12921, 15'd12922, 15'd12923, 15'd12924, 15'd12925, 15'd12926, 15'd12927, 15'd13044, 15'd13045, 15'd13046, 15'd13047, 15'd13048, 15'd13049, 15'd13050, 15'd13051, 15'd13052, 15'd13053, 15'd13054, 15'd13055, 15'd13056, 15'd13057, 15'd13058, 15'd13059, 15'd13060, 15'd13061, 15'd13062, 15'd13063, 15'd13064, 15'd13065, 15'd13066, 15'd13067, 15'd13068, 15'd13069, 15'd13070, 15'd13071, 15'd13072, 15'd13073, 15'd13074, 15'd13075, 15'd13076, 15'd13077, 15'd13078, 15'd13079, 15'd13080, 15'd13081, 15'd13082, 15'd13083, 15'd13084, 15'd13085, 15'd13086, 15'd13087, 15'd14649, 15'd14650, 15'd14651, 15'd14652, 15'd14653, 15'd14654, 15'd14655, 15'd14656, 15'd14657, 15'd14658, 15'd14659, 15'd14660, 15'd14661, 15'd14662, 15'd14663, 15'd14664, 15'd14665, 15'd14666, 15'd14667, 15'd14668, 15'd14669, 15'd14670, 15'd14671, 15'd14672, 15'd14673, 15'd14674, 15'd14675, 15'd14676, 15'd14677, 15'd14678, 15'd14679, 15'd14680, 15'd14681, 15'd14810, 15'd14811, 15'd14812, 15'd14813, 15'd14814, 15'd14815, 15'd14816, 15'd14817, 15'd14818, 15'd14819, 15'd14820, 15'd14821, 15'd14822, 15'd14823, 15'd14824, 15'd14825, 15'd14826, 15'd14827, 15'd14828, 15'd14829, 15'd14830, 15'd14831, 15'd14832, 15'd14833, 15'd14834, 15'd14835, 15'd14836, 15'd14837, 15'd14838, 15'd14839, 15'd14840, 15'd14841, 15'd16415, 15'd16416, 15'd16417, 15'd16418, 15'd16419, 15'd16420, 15'd16421, 15'd16422, 15'd16423, 15'd16424, 15'd16425, 15'd16426, 15'd16427, 15'd16428, 15'd16429, 15'd16430, 15'd16431, 15'd16432, 15'd16433, 15'd16434, 15'd16435, 15'd16436, 15'd16575, 15'd16576, 15'd16577, 15'd16578, 15'd16579, 15'd16580, 15'd16581, 15'd16582, 15'd16583, 15'd16584, 15'd16585, 15'd16586, 15'd16587, 15'd16588, 15'd16589, 15'd16590, 15'd16591, 15'd16592, 15'd16593, 15'd16594, 15'd16595, 15'd18180, 15'd18181, 15'd18182, 15'd18183, 15'd18184, 15'd18185, 15'd18186, 15'd18187, 15'd18188, 15'd18189, 15'd18190, 15'd18341, 15'd18342, 15'd18343, 15'd18344, 15'd18345, 15'd18346, 15'd18347, 15'd18348, 15'd18349, 15'd18350: base_color = 2'd2;
            default: base_color = 2'd0;
        endcase
    end

    // A valid tag prevents a sparse-table hit from changing any other pixel.
    always @(*) begin
        O_pixel = 25'd0;
        case (base_color)
            2'd1: O_pixel = 25'h11c2d4e;
            2'd2: O_pixel = 25'h1ed1c24;
            default: O_pixel = 25'd0;
        endcase
        if (selected_data[33] && selected_data[32:24] == read_address[8:0]) begin
            O_pixel = {1'b1, selected_data[23:0]};
        end
        if (!read_valid) begin
            O_pixel = 25'd0;
        end
    end
endmodule

#property copyright "lv.haiyang"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


class CandlestickCharts
	{
public:
		//最后一次发送消息的时间
		string lastSendTime;
		string symbol;
		int timeframe;
		string label;
		//定义K线及组合的名字
		string DA_YANG_XIAN;
        string ZHONG_YANG_XIAN;
        string XIAO_YANG_XIAN;
        string DA_YIN_XIAN;
        string ZHONG_YIN_XIAN;
        string XIAO_YIN_XIAN;
        string SHI_ZI_XING;
        string DAO_CHUI_XIAN;
        string CHUI_ZI_XIAN;
        string FANG_CHUI_XIAN;
        string CHANG_SHANG_YING_XIAN;
        string CHANG_XIA_YING_XIAN;
        string WU_SHANG_YING_XIAN;
        string WU_XIA_YING_XIAN;
		/*
		Description: 初始化
		*/
		void CandlestickChartsInit(string p_symbol, int p_timeframe, string p_label)
			{
				lastSendTime = "";
				symbol = p_symbol;
				timeframe = p_timeframe;
				label = p_label;
				DA_YANG_XIAN = "大阳线";
                ZHONG_YANG_XIAN = "中阳线";
                XIAO_YANG_XIAN = "小阳线";
                DA_YIN_XIAN = "大阴线";
                ZHONG_YIN_XIAN = "中阴线";
                XIAO_YIN_XIAN = "小阴线";
                SHI_ZI_XING = "十字星";
                DAO_CHUI_XIAN = "倒锤线";
                CHUI_ZI_XIAN = "锤子线";
                FANG_CHUI_XIAN = "纺锤线";
                CHANG_SHANG_YING_XIAN = "长上影线";
                CHANG_XIA_YING_XIAN = "长下影线";
                WU_SHANG_YING_XIAN = "无上影线";
                WU_XIA_YING_XIAN = "无下影线";
			}
		/*
		Description: 发送消息到移动端并且打印到日志
		Input: information: 需要发送的消息内容
		Return: 无
		*/
		void SendInformation(string information)
		    {
                SendNotification(information);
                Print(information);
		    }

		/*
		Description: 分析单一K线的形态
		Input: K线的开盘价 open， 最高价 high， 收盘价 close， 最低价 low
		Return: string 返回当前K线的形态说明
		*/
		string SingleCandle(double open, double high, double low, double close)
			{
				string resultFirst = "";
				string resultEnd = "";
				string result = "";
				double total = 0;
				//计算200日均线的柱体平均值
				for(int i=1;i<201;i++)
					{
						double b = MathAbs(iOpen(symbol, timeframe, i) - iClose(symbol, timeframe, i));
						total += b;
					}
				double avg = total / 200;
				if(close > open)//k线为阳线
					{
						//上影线长度
						double upperShadow = high - close;
						//下影线长度
						double lowerShadow = open - low;
						//实体长度
						double body = close - open;

						//大阳线 最近200跟K线均值2倍以上
						if(body >= avg * 2) resultEnd += DA_YANG_XIAN;
						//中阳线 最近200跟K线均值1倍以上
						else if(body >= avg * 1) resultEnd += ZHONG_YANG_XIAN;
						//小阳线 最近200跟K线均值0.1倍以上
						else if(body >= avg * 0.1) resultEnd += XIAO_YANG_XIAN;
						//小阳星 最近200跟K线均值0.1倍以下
						else resultEnd += SHI_ZI_XING;
						//长上影线
						if(upperShadow >= avg * 2) resultFirst += CHANG_SHANG_YING_XIAN;
						else if(upperShadow <= avg * 0.5) resultFirst += WU_SHANG_YING_XIAN;
						//长下影线
						if(lowerShadow >= avg * 2) resultFirst += CHANG_XIA_YING_XIAN;
						else if(lowerShadow <= avg * 0.5) resultFirst += WU_XIA_YING_XIAN;
						result = resultFirst + resultEnd;
						if(resultEnd == DA_YANG_XIAN) result = DA_YANG_XIAN;
						else if(resultEnd == ZHONG_YANG_XIAN) result = ZHONG_YANG_XIAN;
						else if(resultEnd == SHI_ZI_XING) result = SHI_ZI_XING;
						else if(result == CHANG_SHANG_YING_XIAN + WU_XIA_YING_XIAN + XIAO_YANG_XIAN) result = DAO_CHUI_XIAN;
						else if(result == WU_SHANG_YING_XIAN + CHANG_XIA_YING_XIAN + XIAO_YANG_XIAN) result = CHUI_ZI_XIAN;
						else result = FANG_CHUI_XIAN;
						return result;
					}
				else if(close < open)//k线为阴线
					{
						//上影线长度
						double upperShadow = high - open;
						//下影线长度
						double lowerShadow = close - low;
						//实体长度
						double body = open - close;

						//大阴线 最近200跟K线均值2倍以上
						if(body >= avg * 2) resultEnd += DA_YIN_XIAN;
						//中阴线 最近200跟K线均值1倍以上
						else if(body >= avg * 1) resultEnd += ZHONG_YIN_XIAN;
						//小阴线 最近200跟K线均值0.1倍以上
						else if(body >= avg * 0.1) resultEnd += XIAO_YIN_XIAN;
						//小阴星 最近200跟K线均值0.1倍以下
						else resultEnd += SHI_ZI_XING;
						//长上影线
						if(upperShadow >= avg * 2) resultFirst += CHANG_SHANG_YING_XIAN;
						else if(upperShadow <= avg * 0.5) resultFirst += WU_SHANG_YING_XIAN;
						//长下影线
						if(lowerShadow >= avg * 2) resultFirst += CHANG_XIA_YING_XIAN;
						else if(lowerShadow <= avg * 0.5) resultFirst += WU_XIA_YING_XIAN;
						result = resultFirst + resultEnd;
						if(resultEnd == DA_YIN_XIAN) result = DA_YIN_XIAN;
						else if(resultEnd == ZHONG_YIN_XIAN) result = ZHONG_YIN_XIAN;
						else if(resultEnd == SHI_ZI_XING) result = SHI_ZI_XING;
						else if(result == CHANG_SHANG_YING_XIAN + WU_XIA_YING_XIAN + XIAO_YIN_XIAN) result = DAO_CHUI_XIAN;
						else if(result == WU_SHANG_YING_XIAN + CHANG_XIA_YING_XIAN + XIAO_YIN_XIAN) result = CHUI_ZI_XIAN;
						else result = FANG_CHUI_XIAN;
						return result;
					}
				else//k线为十字星
					{
						//上影线长度
						double upperShadow = high - open;
						//下影线长度
						double lowerShadow = close - low;
						//实体长度
						double body = open - close;

						resultEnd += SHI_ZI_XING;
						return resultFirst + resultEnd;
					}
			}

		/*
		Description: 分析K线组合的形态
		Input: 无
		Return: string 返回当前K线组合的形态说明
		*/
		string CandleCombine()
			{
				string result = "";
				//存放10个K线的 open high low close
				double candleInfo[30][4];
				string candleType[30];
				for(int i=0;i<10;i++)
					{
						double open = iOpen(symbol, timeframe, i);
		                double high = iHigh(symbol, timeframe, i);
		                double low = iLow(symbol, timeframe, i);
		                double close = iClose(symbol, timeframe, i);
		                candleInfo[i][0] = open;
		                candleInfo[i][1] = high;
		                candleInfo[i][2] = low;
		                candleInfo[i][3] = close;
		                candleType[i] = SingleCandle(open, high, low, close);
					}

				for(int i=0;i<5;i++)
				    {
				        //todo 判断最近两根K线的组合
				        if(candleInfo[i+1][1] < candleInfo[i][0] && candleInfo[i+1][2] > candleInfo[i][3] && candleType[i] == DA_YIN_XIAN) result += "长阴吞没线;";
				        if(candleInfo[i+1][1] < candleInfo[i][3] && candleInfo[i+1][2] > candleInfo[i][0] && candleType[i] == DA_YANG_XIAN) result +=  "长阳吞没线;";
				        if(candleInfo[i+1][0] > candleInfo[i][1] && candleInfo[i+1][3] < candleInfo[i][2] && candleType[i+1] == DA_YIN_XIAN) result +=  "长阴孕育线;";
				        if(candleInfo[i+1][3] > candleInfo[i][1] && candleInfo[i+1][0] < candleInfo[i][2] && candleType[i+1] == DA_YANG_XIAN) result += "长阳孕育线;";
				        if(candleInfo[i+1][0] <= candleInfo[i][3] && candleType[i+1] == DA_YANG_XIAN && candleType[i] == DA_YIN_XIAN) result +=  "乌云盖顶;";
				        if(candleInfo[i+1][0] > candleInfo[i][3] && candleType[i+1] == DA_YANG_XIAN && candleType[i] == DA_YIN_XIAN) result +=  "倾盆大雨;";
				        if(candleInfo[i+1][0] >= candleInfo[i][3] && candleType[i+1] == DA_YIN_XIAN && candleType[i] == DA_YANG_XIAN) result +=  "曙光初现;";
				        if(candleInfo[i+1][0] < candleInfo[i][3] && candleType[i+1] == DA_YIN_XIAN && candleType[i] == DA_YANG_XIAN) result +=  "旭日东升;";


				        //todo 判断最近三根K线的组合
				        if(candleType[i+2] == DA_YIN_XIAN && candleType[i+1] == SHI_ZI_XING && candleType[i] == DA_YANG_XIAN) result += "早晨十字星;";
				        if(candleType[i+2] == DA_YANG_XIAN && candleType[i+1] == SHI_ZI_XING && candleType[i] == DA_YIN_XIAN) result += "黄昏十字星;";
				        if((candleType[i+2] == DA_YANG_XIAN || candleType[i+2] == ZHONG_YANG_XIAN) && (candleType[i+1] == DA_YANG_XIAN || candleType[i+1] == ZHONG_YANG_XIAN) && (candleType[i] == DA_YANG_XIAN || candleType[i] == ZHONG_YANG_XIAN)) result += "红三兵;";
				        if((candleType[i+2] == DA_YIN_XIAN || candleType[i+2] == ZHONG_YIN_XIAN) && (candleType[i+1] == DA_YIN_XIAN || candleType[i+1] == ZHONG_YIN_XIAN) && (candleType[i] == DA_YIN_XIAN || candleType[i] == ZHONG_YIN_XIAN))  result += "三只乌鸦;";
				        if((candleType[i+2] == DA_YANG_XIAN) && (candleType[i+1] == SHI_ZI_XING || candleType[i+1] == XIAO_YANG_XIAN) && (candleType[i] == SHI_ZI_XING || candleType[i] == XIAO_YANG_XIAN)) result += "上涨两颗星;";
				        if((candleType[i+2] == DA_YIN_XIAN) && (candleType[i+1] == SHI_ZI_XING || candleType[i+1] == ZHONG_YIN_XIAN) && (candleType[i] == SHI_ZI_XING || candleType[i] == ZHONG_YIN_XIAN))  result += "下跌两颗星;";
				        if(candleType[i+2] == DA_YANG_XIAN && (candleInfo[i+1][0] >= candleInfo[i+1][3]) && candleType[i] == DA_YANG_XIAN)  result += "多方炮;";
				        if(candleType[i+2] == DA_YIN_XIAN && (candleInfo[i+1][0] <= candleInfo[i+1][3]) && candleType[i] == DA_YIN_XIAN)  result += "空方炮;";


				        //todo 判断最近四根K线的组合
				    }

				return result;
			}

		/*
		Description: 运行
		Input: 无
		Return: 无
		*/
		void run()
			{
				//每小时执行一次发送消息
				string currentTime = string(Year()) + string(Month()) + string(Day()) + string(Hour());
		        if(currentTime == lastSendTime) return;
		        lastSendTime = currentTime;
		        //发送消息内容
		        string currentClose = DoubleToStr(iClose(symbol, timeframe, 0), Digits);
		        double open = iOpen(symbol, timeframe, 1);
		        double high = iHigh(symbol, timeframe, 1);
		        double low = iLow(symbol, timeframe, 1);
		        double close = iClose(symbol, timeframe, 1);
		        string info = "";
		        string single = "K线形态: " + SingleCandle(open, high, low, close);
		        string combine = "K线组合形态: " + CandleCombine();
		        if(CandleCombine() == "") info = single;
		        else info = combine;
				SendInformation(Symbol() + label + ": " + currentClose + "; " + info);
			}

	};

input string input_symbol = "OILUSD";//交易品种
input int input_timeframe = 60;//K线周期(单位:分)
input string input_label = "1小时图";//标签

CandlestickCharts cc;

int OnInit()
    {
		cc.CandlestickChartsInit(input_symbol, input_timeframe, input_label);
        return(INIT_SUCCEEDED);
    }

void OnTick()
    {
		cc.run();
	}
#property copyright "lv.haiyang"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


class CandlestickCharts
	{
public:
		//最后一次发送消息的时间
        int lastSendTime;
		string symbol;
		int timeframe;
		string label;
        int maLongPeriod;
        int maMiddelPeriod;
        int maShortPeriod;
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
		void CandlestickChartsInit(string p_symbol, int p_timeframe, string p_label, int p_maShortPeriod, int p_maMiddelPeriod, int p_maLongPeriod)
			{
				lastSendTime = 0;
				symbol = p_symbol;
				timeframe = p_timeframe;
				label = p_label;
				maShortPeriod = p_maShortPeriod;
				maMiddelPeriod = p_maMiddelPeriod;
				maLongPeriod = p_maLongPeriod;
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
		Description: 分析均线系统
		Input: 无
		Return: string 返回当前均线系统说明
		*/
		string MovingAverageSystem()
			{
				string result = "";
				//存放10个K线的 open high low close
				double candleInfo[30][4];
				string candleType[30];
				double maLong[30];
				double maMiddel[30];
				double maShort[30];
				for(int i=1;i<31;i++)
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
		                maLong[i] = iMA(symbol,timeframe,maLongPeriod,0,MODE_SMA,PRICE_CLOSE,i);
		                maMiddel[i] = iMA(symbol,timeframe,maMiddelPeriod,0,MODE_SMA,PRICE_CLOSE,i);
		                maShort[i] = iMA(symbol,timeframe,maShortPeriod,0,MODE_SMA,PRICE_CLOSE,i);
					}

				for(int i=1;i<29;i++)
				    {
				        string result_i = "";
				        //短期均线上穿中期均线
                        if(maShort[i+1] <= maMiddel[i+1] && maShort[i] > maMiddel[i])
                            {
                                //中期均线在长期均线上方
                                if(maMiddel[i] > maLong[i]) result_i = "梅开二度";
                                else result_i = "生根发芽";
                            }
                        //中期均线上穿长期均线
                        if(maMiddel[i+1] <= maLong[i+1] && maMiddel[i] > maLong[i]) result_i = "红杏出墙";
                        //均线空头排列
                        if(maShort[i] <= maMiddel[i] && maMiddel[i] <= maLong[i])
                            {
                                result_i = "空头排列";
                                //K线开盘价小于短期均线，收盘价大于长期均线
                                if(candleInfo[i][0] <= maShort[i] && candleInfo[i][3] >= maLong[i]) result_i = "火箭炮";
                            }


				        //短期均线下穿中期均线
                        if(maShort[i+1] >= maMiddel[i+1] && maShort[i] < maMiddel[i])
                            {
                                //中期均线在长期均线下方
                                if(maMiddel[i] < maLong[i]) result_i = "雪上加霜";
                                else result_i = "上树拔梯";
                            }
                        //中期均线下穿长期均线
                        if(maMiddel[i+1] >= maLong[i+1] && maMiddel[i] < maLong[i]) result_i = "落井下石";
                        //均线多头排列
                        if(maShort[i] >= maMiddel[i] && maMiddel[i] >= maLong[i])
                            {
                                result_i = "多头排列";
                                //K线开盘价大于短期均线，收盘价小于长期均线
                                if(candleInfo[i][0] >= maShort[i] && candleInfo[i][3] <= maLong[i]) result_i = "流星锤";
                            }


                        if(result_i != "") result = candleType[i] + "-" + result_i;

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
		        int currentTime = (int(TimeGMT()) / 60) / timeframe;
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
		        string maSystem = "均线系统: " + MovingAverageSystem();
		        if(MovingAverageSystem() == "") info = single;
		        else info = maSystem;
				SendInformation(Symbol() + label + ": " + currentClose + "; " + info);
			}

	};

input string input_symbol = "OILUSD";//交易品种
input int input_timeframe = 60;//K线周期(单位:分)
string input_label = "";//标签
input int input_maShortPeriod;//短期均线
input int input_maMiddelPeriod;//中期均线
input int input_maLongPeriod;//长期均线

CandlestickCharts cc;

int OnInit()
    {
        if(input_timeframe == 1) input_label = "1分钟图";
        else if(input_timeframe == 3) input_label = "3分钟图";
        else if(input_timeframe == 5) input_label = "5分钟图";
        else if(input_timeframe == 10) input_label = "10分钟图";
        else if(input_timeframe == 15) input_label = "15分钟图";
        else if(input_timeframe == 30) input_label = "30分钟图";
        else if(input_timeframe == 60) input_label = "1小时图";
        else if(input_timeframe == 240) input_label = "4小时图";
        else if(input_timeframe == 1440) input_label = "日线图";
		cc.CandlestickChartsInit(input_symbol, input_timeframe, input_label, input_maShortPeriod, input_maMiddelPeriod, input_maLongPeriod);
        return(INIT_SUCCEEDED);
    }

void OnTick()
    {
		cc.run();
	}
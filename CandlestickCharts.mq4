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
		/*
		Description: 初始化
		*/
		void CandlestickChartsInit(string p_symbol, int p_timeframe, string p_label)
			{
				lastSendTime = "";
				symbol = p_symbol;
				timeframe = p_timeframe;
				label = p_label;
			}
		/*
		Description: 每小时发送一次消息到移动端并且打印到日志
		Input: type: 消息类型(all 发送移动端同时打印日志， print 仅打印日志)
			   information: 需要发送的消息内容
		Return: 无
		*/
		void SendInformation(string type, string information)
		    {
		        string currentTime = string(Year()) + string(Month()) + string(Day()) + string(Hour());
		        if(currentTime != lastSendTime)
		            {
		                if(type=="print") Print(information);
		                else
		                    {
		                        SendNotification(information);
		                        Print(information);
		                    }
		                lastSendTime = currentTime;
		            }
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
						if(body >= avg * 2) resultEnd += "大阳线";
						//中阳线 最近200跟K线均值1倍以上
						else if(body >= avg * 1) resultEnd += "中阳线";
						//小阳线 最近200跟K线均值0.1倍以上
						else if(body >= avg * 0.1) resultEnd += "小阳线";
						//小阳星 最近200跟K线均值0.1倍以下
						else resultEnd += "十字星";
						//长上影线
						if(upperShadow >= avg * 2) resultFirst += "长上影";
						else if(upperShadow <= avg * 0.5) resultFirst += "无上影";
						//长下影线
						if(lowerShadow >= avg * 2) resultFirst += "长下影";
						else if(lowerShadow <= avg * 0.5) resultFirst += "无下影";
						result = resultFirst + resultEnd;
						if(resultEnd == "大阳线") result = "大阳线";
						else if(resultEnd == "中阳线") result = "中阳线";
						else if(resultEnd == "十字星") result = "十字星";
						else if(result == "长上影无下影小阳线") result = "倒锤线";
						else if(result == "无上影长下影小阳线") result = "锤子线";
						else result = "纺锤线";
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
						if(body >= avg * 2) resultEnd += "大阴线";
						//中阴线 最近200跟K线均值1倍以上
						else if(body >= avg * 1) resultEnd += "中阴线";
						//小阴线 最近200跟K线均值0.1倍以上
						else if(body >= avg * 0.1) resultEnd += "小阴线";
						//小阴星 最近200跟K线均值0.1倍以下
						else resultEnd += "十字星";
						//长上影线
						if(upperShadow >= avg * 2) resultFirst += "长上影";
						else if(upperShadow <= avg * 0.5) resultFirst += "无上影";
						//长下影线
						if(lowerShadow >= avg * 2) resultFirst += "长下影";
						else if(lowerShadow <= avg * 0.5) resultFirst += "无下影";
						result = resultFirst + resultEnd;
						if(resultEnd == "大阴线") result = "大阴线";
						else if(resultEnd == "中阴线") result = "中阴线";
						else if(resultEnd == "十字星") result = "十字星";
						else if(result == "长上影无下影小阴线") result = "倒锤线";
						else if(result == "无上影长下影小阴线") result = "锤子线";
						else result = "纺锤线";
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

						resultEnd += "十字星";
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
				string result = "K线无组合形态";
				double c1_open = iOpen(symbol, timeframe, 1);
				double c2_open = iOpen(symbol, timeframe, 2);
				double c3_open = iOpen(symbol, timeframe, 3);

                double c1_close = iClose(symbol, timeframe, 1);
                double c2_close = iClose(symbol, timeframe, 2);
                double c3_close = iClose(symbol, timeframe, 3);

                double c1_high = iHigh(symbol, timeframe, 1);
                double c2_high = iHigh(symbol, timeframe, 2);
                double c3_high = iHigh(symbol, timeframe, 3);

                double c1_low = iLow(symbol, timeframe, 1);
                double c2_low = iLow(symbol, timeframe, 2);
                double c3_low = iLow(symbol, timeframe, 3);

                string c1 = SingleCandle(c1_open, c1_high, c1_low, c1_close);
                string c2 = SingleCandle(c2_open, c2_high, c2_low, c2_close);
                string c3 = SingleCandle(c3_open, c3_high, c3_low, c3_close);

				//todo 判断最近两根K线的组合
				if(c2_close < c1_open && c2_open > c1_close && c1 == "大阴线") result = "长阴怀抱线";
				else if(c2_close > c1_open && c2_open < c1_close && c1 == "大阳线") result = "长阳怀抱线";
                else if(c2_close < c1_open && c2_open > c1_close && c2 == "大阴线") result = "长阴孕育线";
                else if(c2_close > c1_open && c2_open < c1_close && c2 == "大阳线") result = "长阳孕育线";
                else if(c1_close > c2_open && c2 == "大阳线" && c1 == "大阴线") result = "乌云盖顶";
                else if(c1_close < c2_open && c2 == "大阴线" && c1 == "大阳线") result = "曙光初现";
                else if(c1_close < c2_open && c2 == "大阳线" && c1 == "大阴线") result = "倾盆大雨";
                else if(c1_close > c2_open && c2 == "大阴线" && c1 == "大阳线") result = "旭日东升";



				//todo 判断最近三根K线的组合
				if(c1 == "大阴线" && c2 == "十字星" && c3 == "大阳线") result = "早晨十字星";
                else if(c1 == "大阳线" && c2 == "十字星" && c3 == "大阴线") result = "黄昏十字星";
                else if((c1 == "大阳线" || c1 == "中阳线") && (c2 == "大阳线" || c2 == "中阳线") && (c3 == "大阳线" || c3 == "中阳线")) result = "红三兵";
                else if((c1 == "大阴线" || c1 == "中阴线") && (c2 == "大阴线" || c2 == "中阴线") && (c3 == "大阴线" || c3 == "中阴线")) result = "三只乌鸦";
                else if((c1 == "大阳线") && (c2 == "小阳线" || c2 == "小阴线" || c2 == "十字星") && (c3 == "小阳线" || c3 == "小阴线" || c3 == "十字星")) result = "上涨两颗星";
                else if((c1 == "大阴线") && (c2 == "小阳线" || c2 == "小阴线" || c2 == "十字星") && (c3 == "小阳线" || c3 == "小阴线" || c3 == "十字星")) result = "下跌两颗星";

				return result;
			}

		/*
		Description: 运行
		Input: 无
		Return: 无
		*/
		void run()
			{
		        string currentClose = DoubleToStr(iClose(symbol, timeframe, 0), Digits);
		        double open = iOpen(symbol, timeframe, 1);
		        double high = iHigh(symbol, timeframe, 1);
		        double low = iLow(symbol, timeframe, 1);
		        double close = iClose(symbol, timeframe, 1);
		        string info = "";
		        string single = "K线形态: " + SingleCandle(open, high, low, close);
		        string combine = "K线组合形态: " + CandleCombine();
		        if(CandleCombine() == "K线无组合形态") info = single;
		        else info = combine;
				SendInformation("all", Symbol() + label + ": " + currentClose + "; " + info);
			}

	};

input string input_symbol = "OILUSD";
//input int input_timeframe = 60;

CandlestickCharts ch1;
CandlestickCharts ch4;
CandlestickCharts cd1;

int OnInit()
    {
		ch1.CandlestickChartsInit(input_symbol, 60, "1小时图");
		ch4.CandlestickChartsInit(input_symbol, 240, "4小时图");
		cd1.CandlestickChartsInit(input_symbol, 1440, "日线图");
        return(INIT_SUCCEEDED);
    }

void OnTick()
    {
		ch1.run();
		ch4.run();
		cd1.run();
	}
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

		/*
		Description: 初始化
		*/
		void CandlestickChartsInit(string p_symbol, int p_timeframe)
			{
				lastSendTime = "";
				symbol = p_symbol;
				timeframe = p_timeframe;
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

						//大阳线 最近14跟K线均值3倍以上
						if(body >= avg * 3) resultEnd += "大阳线";
						//中阳线 最近14跟K线均值2倍以上
						else if(body >= avg * 1.5) resultEnd += "中阳线";
						//小阳线 最近14跟K线均值1倍以上
						//else if(body >= avg * 1) resultEnd += "小阳线";
						//小阳星 最近14跟K线均值1倍以下
						else if(body >= avg * 0.1) resultEnd += "小阳线";
						else resultEnd += "十字星";
						//长上影线
						if(upperShadow >= avg * 3) resultFirst += "长上影";
						else if(upperShadow <= avg * 0.5) resultFirst += "无上影";
						//长下影线
						if(lowerShadow >= avg * 3) resultFirst += "长下影";
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

						//大阴线 最近14跟K线均值3倍以上
						if(body >= avg * 3) resultEnd += "大阴线";
						//中阴线 最近14跟K线均值2倍以上
						else if(body >= avg * 1.5) resultEnd += "中阴线";
						//小阴线 最近14跟K线均值1倍以上
						//else if(body >= avg * 1) resultEnd += "小阴线";
						//小阴线 最近14跟K线均值1倍以下
						else if(body >= avg * 0.1) resultEnd += "小阴线";
						else resultEnd += "十字星";
						//长上影线
						if(upperShadow >= avg * 3) resultFirst += "长上影";
						else if(upperShadow <= avg * 0.5) resultFirst += "无上影";
						//长下影线
						if(lowerShadow >= avg * 3) resultFirst += "长下影";
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
						//长上影线
						//if(upperShadow >= avg * 3) resultFirst += "长上影";
						//长下影线
						//if(lowerShadow >= avg * 3) resultFirst += "长下影";
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
				string candle1 = "";
				string candle2 = "";
				string candle3 = "";
				string candle4 = "";
				string candle5 = "";
				for(int i=1;i<6;i++)
					{
						double open = iOpen(symbol, timeframe, i);
						double high = iHigh(symbol, timeframe, i);
						double low = iLow(symbol, timeframe, i);
						double close = iClose(symbol, timeframe, i);
						if(i == 1) candle1 = SingleCandle(open, high, low, close);
						else if(i == 2) candle2 = SingleCandle(open, high, low, close);
						else if(i == 3) candle3 = SingleCandle(open, high, low, close);
						else if(i == 4) candle4 = SingleCandle(open, high, low, close);
						else if(i == 5) candle5 = SingleCandle(open, high, low, close);
					}

				//判断最近两根K线
				string r2 = candle2 + candle1;
				if(r2 == "大阳线大阴线") result = "吞没形态-看跌";
				else if(r2 == "大阴线大阳线") result = "吞没形态-看涨";

				//判断最近三根K线
				string r3 = candle3 + candle2 + candle1;
				if(r3 == "大阳线十字星大阴线")  result = "黄昏之星-看跌";
				else if(r3 == "大阴线十字星大阳线")  result = "启明星-看涨";

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
				SendInformation("all", Symbol() + string(timeframe) + ": " + currentClose + "; " + info);
			}

	};

input string input_symbol = "OILUSD";
//input int input_timeframe = 60;

CandlestickCharts ch1;
CandlestickCharts ch4;
CandlestickCharts cd1;

int OnInit()
    {
		ch1.CandlestickChartsInit(input_symbol, 60);
		ch4.CandlestickChartsInit(input_symbol, 240);
		cd1.CandlestickChartsInit(input_symbol, 1440);
        return(INIT_SUCCEEDED);
    }

void OnTick()
    {
		ch1.run();
		ch4.run();
		cd1.run();
	}
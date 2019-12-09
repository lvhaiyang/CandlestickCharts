#property copyright "lv.haiyang"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//最后一次发送消息的时间
string lastSendTime = "";

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
string SingleCandle(double open, double high, double close, double low)
	{
		string resultFirst = "";
		string resultEnd = "";
		double total = 0;
		for(int i=0;i<14;i++)
			{
				double b = MathAbs(iOpen(NULL, 60, i) - iClose(NULL, 60, i));
				total += b;
			}
		double avg = total / 14;
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
				else if(body >= avg * 2) resultEnd += "中阳线";
				//小阳线 最近14跟K线均值1倍以上
				else if(body >= avg * 1) resultEnd += "小阳线";
				//小阳星 最近14跟K线均值1倍以下
				else if(body >= avg * 0.3) resultEnd += "小阳星";
				else resultEnd += "十字星";
				//长上影线
				if(upperShadow >= avg * 3) resultFirst += "长上影";
				//长下影线
				if(lowerShadow >= avg * 3) resultFirst += "长下影";
				return resultFirst + resultEnd;
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
				else if(body >= avg * 2) resultEnd += "中阴线";
				//小阴线 最近14跟K线均值1倍以上
				else if(body >= avg * 1) resultEnd += "小阴线";
				//小阴线 最近14跟K线均值1倍以下
				else if(body >= avg * 0.3) resultEnd += "小阴线";
				else resultEnd += "十字星";
				//长上影线
				if(upperShadow >= avg * 3) resultFirst += "长上影";
				//长下影线
				if(lowerShadow >= avg * 3) resultFirst += "长下影";
				return resultFirst + resultEnd;
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
				if(upperShadow >= avg * 3) resultFirst += "长上影";
				//长下影线
				if(lowerShadow >= avg * 3) resultFirst += "长下影";
				return resultFirst + resultEnd;
			}
	}

void OnTick()
    {
        string currentClose = DoubleToStr(iClose(NULL, 60, 0), Digits);
        double open = iOpen(NULL, 60, 0);
        double high = iHigh(NULL, 60, 0);
        double low = iLow(NULL, 60, 0);
        double close = iClose(NULL, 60, 0);
		SendInformation("all", Symbol() + ": " + currentClose + "; K线形态: " + SingleCandle(open, high, low, close));
	}
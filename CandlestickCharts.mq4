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
		if(close > open)//k线为阳线
			{
				//上影线长度
				double upperShadow = high - close;
				//下影线长度
				double lowerShadw = open - low;
				//实体长度
				double body = close - open;

				//大阳线
				//中阳线
				//小阳线
				//小阳星
				//长上影线
				//长下影线
				//实体小上下影线长
				//其他

			}
		else if(close < open)//k线为阴线
			{
				//上影线长度
				double upperShadow = high - open;
				//下影线长度
				double lowerShadw = close - low;
				//实体长度
				double body = open - clsoe;
			}
		else//k线为十字星
			{
				//上影线长度
				double upperShadow = high - open;
				//下影线长度
				double lowerShadw = close - low;
				//实体长度
				double body = open - clsoe;
			}
	}

void OnTick()
    {
		SendInformation("all", "");
	}
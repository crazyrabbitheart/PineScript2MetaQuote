//+------------------------------------------------------------------+
//| Indicator Parameters                                              |
//+------------------------------------------------------------------+

#property  indicator_chart_window
#property  indicator_buffers 3
#property  indicator_color1  White
#property  indicator_color2  Green
#property  indicator_color3  Red

input int timeframe = 60; // 60 minutes

// Access the close price of the specified timeframe for the current symbol

input int keltnerLength = 200;
input int keltnerATRLength = 200;
input int keltnerDeviation = 8;
input bool closeOnEMATouch = false;
input bool enterOnBorderTouchFromInside = false;

// Indicator buffers
double EMABuffer[];
double topBuffer[];
double bottomBuffer[];

//+------------------------------------------------------------------+
//| Custom Indicator Initialization Function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    SetIndexBuffer(0, EMABuffer);
    SetIndexBuffer(1, topBuffer);
    SetIndexBuffer(2, bottomBuffer);

    SetIndexStyle(0, DRAW_LINE);
    SetIndexStyle(1, DRAW_LINE);
    SetIndexStyle(2, DRAW_LINE);

    SetIndexLabel(0, "EMA");
    SetIndexLabel(1, "Keltner top");
    SetIndexLabel(2, "Keltner bottom");

    IndicatorShortName("Keltner Channel");
    

    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom Indicator Calculation Function                            |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
    //ArraySetAsSeries(close, true);

    double price = iClose(NULL, timeframe, 0); // Close price of the current bar on the specified timeframe
    int limit = rates_total - prev_calculated;

    for (int i = 0; i < limit; i++)
    {
        int calculatedBar = rates_total - i - 1;
        EMABuffer[i] = iMA(NULL, 0, keltnerLength, 0, MODE_SMA, price, i);
        double ATR = iATR(NULL, 0, keltnerATRLength, i);
        topBuffer[i] = EMABuffer[i] + ATR * keltnerDeviation;
        bottomBuffer[i] = EMABuffer[i] - ATR * keltnerDeviation;
    }

    return(rates_total);
}

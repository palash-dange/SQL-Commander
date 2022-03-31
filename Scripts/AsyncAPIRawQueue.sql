SELECT * FROM AsyncAPIRawQueue WITH (NOLOCK) WHERE ReceivedDataCenterID > 0 AND CallDate > DATEADD(HH, -24, GETDATE())


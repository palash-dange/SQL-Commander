-- Run this on SXX-SystemDB

SELECT memberid, jobid,dbid from dbo.ommslot with (nolock)
 WHERE servicemachineid in ( XXX)

-- to check the demo account is created in correct DB.
select me.memberid, me.UserID,m.dbid from members m (nolock)
join memberemployee me (nolock) on m.memberid = me.memberid
where me.UserID like 'synthetictestet51168'


--- to check BR 
select * from memberbusinessrulestate (nolock) 
where memberid ='536000755' 
and (name = 'IMH_ONLY' 
or name = 'GROUP_EXPRESSION' 
or name = 'ID_VALIDATION' 
or name = 'MICROSITES')


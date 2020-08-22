-- ve_performance.sql
-- script revisado por Lilian Barroso em 15-05-2015 e em 01/07/2019 
-- Objectivo: Exibir as maiores waits do banco de dados, por sessao, no momento. 

-- teste git 

col usuario for a20
col evento_espera for a50
col sessao for a17
col program for a35 
col tempo for 999999999
col inst_id for 99
col PROCESSO_SO for a11
col machine for a25
col usuario_so for a35 
col aplicacao for a60



prompt

SELECT  '''' || s.SID ||','|| s.serial# ||  ',@' || s.inst_id ||  '''' as sessao, 
		S.username 									usuario, 
		p.spid 										processo_SO,
		substr(S.program,1,34)						aplicacao,
		s.osuser || '@'|| substr(s.machine,1,20)	usuario_so,
		s.EVENT || ' ('||S.WAIT_CLASS ||')'			evento_espera, 
		s.SECONDS_IN_WAIT 							tempo, 
		s.SQL_id									sql_id 
FROM 	GV$SESSION S, 
		  GV$PROCESS P 
WHERE S.PADDR = P.ADDR   
 AND  upper(S.EVENT) NOT IN ( 'DISPATCHER TIMER', 
                              'PIPE GET', 
                              'PMON TIMER', 
                              'PX IDLE WAIT', 
                              'PX DEQ CREDIT: NEED BUFFER', 
                              'RDBMS IPC MESSAGE', 
                              'SMON TIMER', 
                              'SQL*NET MESSAGE FROM CLIENT', 
                              'VIRTUAL CIRCUIT STATUS', 
                              'STREAMS AQ: WAITING FOR TIME MANAGEMENT OR CLEANUP TASKS', 
                              'STREAMS AQ: QMN SLAVE IDLE WAIT', 
                              'STREAMS AQ: QMN COORDINATOR IDLE WAIT') 
AND S.WAIT_CLASS != 'Idle'
 -- and S.SECONDS_IN_WAIT > 30
ORDER BY  S.SECONDS_IN_WAIT, S.SID
--  ORDER BY 3
/

prompt


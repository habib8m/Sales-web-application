
select task_name    task_name,
       id           task_id,
       parent_task  parent_task,
       start_date   task_start_date,
       end_date     task_end_date,
       decode(status,'Closed',1,'Open',0.6,'On-Hold',0.1,'Pending',0) status,
       sysdate-100   gantt_start_date,
       sysdate+100  gantt_end_date
from gantt_table
start with parent_task is null
connect by prior id = parent_task
order siblings by task_name
CREATE VIEW SCM.VW_CAPA_ORDER_ROUTING
AS
SELECT [ORDER] as [Order],
   [Oper/Act] as [Oper./Act.],
   WORK_CNTR as [Work cntr.],
   TEXT_KEY AS [Text key],
   OPERATION_SHORT_TEXT as [Opr. short text],
   NULL AS CATEGORY,
   OP_QTY as [Op. Qty],
   YIELD_QTY AS [  Yield],
   SCRAP AS [Scrap],
   [ACT/OPUOM] AS [Act/Op.UoM],
   ACT_START AS [Act. start],
   ACTFINISH as  [Act.finish],
   MOVE_TIME AS [              Move time],
   QUEUE_TIME as [             Queue time],
   SYSTEM_STATUS AS [System Status],
   YIELD AS Yield,
   BASE_QTY as [Base Qty],
   SET_UP_TIME as [set_up_time],
   CYCLE_TIME as [cycle_time],
   STD_VALUE as [ Std Value]
   ,LOAD_DT
FROM scm.TB_SCM_3_ORDER_ROUTING
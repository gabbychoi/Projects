CREATE VIEW scm.VW_CAPA_MTRL_MARGIN_GROUP
AS
SELECT 'HSS' [mtrl type], '반제품' [소재 구분], '충분' [재고유무], '28' [start_margin_day] UNION ALL
SELECT 'HSS', '반제품', '무', '56' UNION ALL
SELECT 'HSS', '반제품', '부족', '56' UNION ALL
SELECT 'HSS', '원자재', '충분', '56' UNION ALL
SELECT 'HSS', '', '', '56' UNION ALL
SELECT 'HSS', '0', '무', '28' UNION ALL
SELECT 'HSS', '재연마', '무', '28' UNION ALL
SELECT 'CAR', '원자재', '충분', '28' UNION ALL
SELECT 'CAR', '원자재', '무', '원자재 확인' UNION ALL
SELECT 'CAR', '원자재', '부족', '원자재 확인' UNION ALL
SELECT 'CAR', '반제품', '충분', '14' UNION ALL
SELECT 'CAR', '반제품', '무', '28' UNION ALL
SELECT 'CAR', '반제품', '부족', '28' UNION ALL
SELECT 'CAR', '', '', '28' UNION ALL
SELECT 'CAR', '0', '무', '14' UNION ALL
SELECT 'CAR', '재연마', '무', '14' 
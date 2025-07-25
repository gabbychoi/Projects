CREATE VIEW SCM.VW_WORKCENTER_GROUP
AS
SELECT 'RTCLCT' ARBPL, 'RTCLCT1' KTSCH, '절단[Blank1]' [Description], '절단' [그룹명], '서운공장' [공장], '1' [우선순위], 'O' [End Mill], 'O' [Drill], 'O' [CS], 'O' [RM] UNION ALL
SELECT 'DDPOGR', 'DDPOGR1', '포인트연삭[Drill2]', '포인트연삭', '서운공장', '2', '', 'O', '', '' UNION ALL
SELECT 'OTCLCG', 'OTCLCG1', '센터연삭[Blank1]', '센터연삭', '서운공장', '2', '', 'O', '', 'O' UNION ALL
SELECT 'OTCLLP', 'OTCLLP1', '센터랩핑[Blank1]', '센터랩핑', '서운공장', '2', '', 'O', '', 'O' UNION ALL
SELECT 'OTCLOH', 'OTCLOH1', '오일홀가공[Blank1]', '오일홀가공', '서운공장', '2', '', '', '', 'O' UNION ALL
SELECT 'RTCLCL', 'RTCLCL1', '센터레스[Blank1]', '센터레스', '서운공장', '2', 'O', 'O', 'O', 'O' UNION ALL
SELECT 'RTCLDH', 'RTCLDH1', '센터레스[DH]', '센터레스', '외주공정', '2', 'O', '', '', '' UNION ALL
SELECT 'RTCLIR', 'RTCLIR1', '센터레스황삭[이레산업]', '센터레스', '외주공정', '2', 'O', '', '', '' UNION ALL
SELECT 'RTCLSJ', 'RTCLSJ1', '센터레스황삭[세종기계]', '센터레스', '외주공정', '2', 'O', '', '', '' UNION ALL
SELECT 'RTCLSJ', 'RTCLSJ2', '센타레스(세종기계)', '센터레스', '외주공정', '2', '', '', '', '' UNION ALL
SELECT 'RTCLWD', 'RTCLWD1', '고주파용접[Blank1]', '고주파용접', '서운공장', '2', 'O', '', '', 'O' UNION ALL
SELECT 'OUTSOD', 'OUTSOD1', 'C2[원덴]', 'C2', '외주공정', '3', 'O', '', '', '' UNION ALL
SELECT 'RTCLC2', 'RTCLC21', 'C2[Blank2]', 'C2', '서운공장', '3', 'O', '', 'O', 'O' UNION ALL
SELECT 'RTCLC2', 'RTCLC23', '백테이퍼[Blank2]', '백테이퍼', '서운공장', '3', '', 'O', '', '' UNION ALL
SELECT 'RTCLC2', 'RTCLC25', '볼황삭[Blank2]', '볼황삭', '서운공장', '3', 'O', 'O', '', 'O' UNION ALL
SELECT 'RTCLCY', 'RTCLCY1', '원통[Blank1]', '원통', '서운공장', '3', 'O', 'O', '', 'O' UNION ALL
SELECT 'RTCLES', 'RTCLES1', '원통연삭[이에스연마]', '원통', '외주공정', '3', '', 'O', '', '' UNION ALL
SELECT 'RTCLR3', 'RTCLR31', 'INFEED[Blank1]', 'INFEED', '서운공장', '3', 'O', 'O', 'O', 'O' UNION ALL
SELECT 'RTCYJI', 'RTCYJI1', 'MQL원통연삭[제일정밀]', '원통', '외주공정', '3', '', 'O', '', '' UNION ALL
SELECT 'RTCYJI', 'RTCYJI2', 'MQL1원통연삭[제일정밀]', '원통', '외주공정', '3', '', 'O', '', '' UNION ALL
SELECT 'RTCYTM', 'RTCYTM1', '원통연삭[TM정공]', '원통', '외주공정', '3', '', 'O', '', '' UNION ALL
SELECT 'RTCYTM', 'RTCYTM2', 'MQL원통연삭[TM정공]', '원통', '외주공정', '3', '', 'O', '', '' UNION ALL
SELECT 'ZHHEKH', 'ZHHEKH1', '열처리[금형]', '열처리', '외주공정', '3', '', '', '', 'O' UNION ALL
SELECT 'DDOCTX', 'DDOCTX1', '홈연삭[TX7/REX5B]', '홈연삭', '서운공장', '4', '', 'O', '', '' UNION ALL
SELECT 'EMFLMJ', 'EMFLMJ1', '홈연삭[Flute]', '홈연삭', '서운공장', '4', 'O', '', '', '' UNION ALL
SELECT 'EMOCB1', 'EMOCB11', '홈연삭 [Insert 2]', '홈연삭', '부평공장', '4', 'O', '', '', '' UNION ALL
SELECT 'EMOCB2', 'EMOCB21', '홈연삭[Large]', '홈연삭', '서운공장', '4', 'O', '', '', '' UNION ALL
SELECT 'EMOCB2', 'EMOCB22', '홈+옆날연삭[Large]', '홈+옆날연삭', '서운공장', '4', 'O', '', '', '' UNION ALL
SELECT 'EMOCB4', 'EMOCB41', '홈연삭[Small1]', '홈연삭', '서운공장', '4', 'O', '', '', '' UNION ALL
SELECT 'EMOCB4', 'EMOCB49', '홈+옆날연삭[Small1]', '홈+옆날연삭', '서운공장', '4', 'O', '', '', '' UNION ALL
SELECT 'EMOCB5', 'EMOCB51', '홈연삭[Jumbo]', '홈연삭', '서운공장', '4', 'O', '', '', '' UNION ALL
SELECT 'EMOCB5', 'EMOCB53', '홈+옆날연삭[Jumbo]', '홈+옆날연삭', '서운공장', '4', 'O', '', '', '' UNION ALL
SELECT 'EMOCB6', 'EMOCB61', '홈연삭[Small2,3]', '홈연삭', '서운공장', '4', 'O', '', '', '' UNION ALL
SELECT 'EMOCB7', 'EMOCB71', '홈연삭 [ANCA] / [Special 1]', '홈연삭', '서운공장', '4', 'O', '', '', '' UNION ALL
SELECT 'EMOCB7', 'EMOCB79', 'TANG[Special1]', 'TANG', '서운공장', '4', 'O', '', '', '' UNION ALL
SELECT 'EMOCB9', 'EMOCB91', '홈연삭 [Small 4 (ANCA)]', '홈연삭', '서운공장', '4', 'O', '', '', '' UNION ALL
SELECT 'EMSPR5', 'EMSPR51', '홈연삭[Special1]', '홈연삭', '서운공장', '4', 'O', '', '', '' UNION ALL
SELECT 'EMSPR5', 'EMSPR56', 'PCD TIP SEAT 가공[Special1]', 'PCD TIP SEAT 가공', '서운공장', '4', 'O', '', '', '' UNION ALL
SELECT 'OTOCAN', 'OTOCAN2', 'TANG[Special2]', 'TANG', '서운공장', '4', '', 'O', '', 'O' UNION ALL
SELECT 'EMNKU4', 'EMNKU41', '라핑/NECK[Roughing]', '라핑', '서운공장', '5', 'O', '', '', '' UNION ALL
SELECT 'EMOCB4', 'EMOCB42', '라핑+밑날 [Small 1 (5C)]', '라핑+밑날', '서운공장', '5', 'O', '', '', '' UNION ALL
SELECT 'EMOCB4', 'EMOCB48', '라핑 [Small 1 (5C)]', '라핑', '서운공장', '5', 'O', '', '', '' UNION ALL
SELECT 'EMOCB5', 'EMOCB52', '옆날연삭[Jumbo]', '옆날연삭', '서운공장', '5', 'O', '', '', '' UNION ALL
SELECT 'EMOCB7', 'EMOCB72', '옆날 [ANCA] / [Special 1]', '옆날연삭', '서운공장', '5', 'O', '', '', '' UNION ALL
SELECT 'EMOCB9', 'EMOCB92', '라핑+밑날 [Small 4 (ANCA)]', '라핑+밑날', '서운공장', '5', 'O', '', '', '' UNION ALL
SELECT 'EMRLC4', 'EMRLC41', '옆날연삭[C40]/[Relieving]', '옆날연삭', '서운공장', '5', 'O', '', '', '' UNION ALL
SELECT 'EMRLO3', 'EMRLO31', '옆날연삭[OG3]/[Relieving]', '옆날연삭', '서운공장', '5', 'O', '', '', '' UNION ALL
SELECT 'EMSPR5', 'EMSPR52', '옆날 [WALTER] / [Special 1]', '옆날연삭', '서운공장', '5', 'O', '', '', '' UNION ALL
SELECT 'PCDEDM', 'PCDEDM1', 'PCDTIP절단', 'PCDTIP절단', '서운공장', '5', 'O', '', '', '' UNION ALL
SELECT 'DDOCRG', 'DDOCRG3', '원척킹[RGX]', '원척킹', '서운공장', '6', '', 'O', '', '' UNION ALL
SELECT 'DDOCRG', 'DDOCRG4', 'Rotary Burrs 원척킹[RGX/MGX] DRILL반', '원척킹', '서운공장', '6', '', 'O', '', '' UNION ALL
SELECT 'DDOCRX', 'DDOCRX3', '원척킹[RX7/FX7/600X]', '원척킹', '서운공장', '6', '', 'O', '', '' UNION ALL
SELECT 'DDOCTP', 'DDOCTP3', '원척킹[TX7P/MX7]', '원척킹', '서운공장', '6', '', 'O', '', '' UNION ALL
SELECT 'DDOCTX', 'DDOCTX3', '원척킹[TX7/REX5B]', '원척킹', '서운공장', '6', 'O', 'O', '', '' UNION ALL
SELECT 'EMOCB1', 'EMOCB14', '페이싱+원척킹[Insert2]', '페이싱+원척킹', '부평공장', '6', 'O', '', '', '' UNION ALL
SELECT 'EMOCB1', 'EMOCB16', 'i-Xmills 원척킹 [Insert 2]', '원척킹', '부평공장', '6', 'O', '', '', '' UNION ALL
SELECT 'EMOCB2', 'EMOCB24', '페이싱+원척킹[Large]', '페이싱+원척킹', '서운공장', '6', 'O', '', '', '' UNION ALL
SELECT 'EMOCB2', 'EMOCB25', '원척킹[Large]', '원척킹', '서운공장', '6', 'O', '', '', '' UNION ALL
SELECT 'EMOCB2', 'EMOCB26', 'i-Xmills 원척킹 [Large (WALTER)]', '원척킹', '서운공장', '6', 'O', '', '', '' UNION ALL
SELECT 'EMOCB3', 'EMOCB31', '원척킹[Mini]', '원척킹', '서운공장', '6', 'O', '', '', '' UNION ALL
SELECT 'EMOCB3', 'EMOCB32', '원척킹[Mini]', '원척킹', '서운공장', '6', '', '', '', '' UNION ALL
SELECT 'EMOCB4', 'EMOCB44', '페이싱+원척킹[Small1]', '페이싱+원척킹', '서운공장', '6', 'O', '', '', '' UNION ALL
SELECT 'EMOCB4', 'EMOCB45', '원척킹[Small1]', '원척킹', '서운공장', '6', 'O', '', 'O', '' UNION ALL
SELECT 'EMOCB5', 'EMOCB55', '페이싱+원척킹[Jumbo]', '페이싱+원척킹', '서운공장', '6', 'O', '', '', '' UNION ALL
SELECT 'EMOCB5', 'EMOCB56', '원척킹[Jumbo]', '원척킹', '서운공장', '6', 'O', '', 'O', '' UNION ALL
SELECT 'EMOCB6', 'EMOCB63', '페이싱+원척킹[Small2,3]', '페이싱+원척킹', '서운공장', '6', 'O', '', '', '' UNION ALL
SELECT 'EMOCB6', 'EMOCB64', '원척킹[Small2,3]', '원척킹', '서운공장', '6', 'O', 'O', '', 'O' UNION ALL
SELECT 'EMOCB7', 'EMOCB74', '페이싱+원척킹 [ANCA] / [Special 1]', '페이싱+원척킹', '서운공장', '6', 'O', '', '', '' UNION ALL
SELECT 'EMOCB7', 'EMOCB75', '원척킹[Special1]', '원척킹', '서운공장', '6', 'O', '', '', '' UNION ALL
SELECT 'EMOCB9', 'EMOCB94', '페이싱+원척킹 [Small 4 (ANCA)]', '페이싱+원척킹', '서운공장', '6', 'O', '', '', '' UNION ALL
SELECT 'EMOCB9', 'EMOCB95', '원척킹[Small4]', '원척킹', '서운공장', '6', 'O', '', '', '' UNION ALL
SELECT 'EMOCB9', 'EMOCB97', 'OTHER 원척킹 [Small 4 (ANCA)]', '원척킹', '서운공장', '6', 'O', '', '', '' UNION ALL
SELECT 'EMSPR5', 'EMSPR54', '페이싱+원척킹[Special1]', '페이싱+원척킹', '서운공장', '6', 'O', '', '', '' UNION ALL
SELECT 'EMSPR5', 'EMSPR55', 'PCD원척킹[Special1]', '원척킹', '서운공장', '6', 'O', '', '', '' UNION ALL
SELECT 'OTOCAN', 'OTOCAN1', '원척킹[Special2]', '원척킹', '서운공장', '6', '', 'O', 'O', 'O' UNION ALL
SELECT 'OUTSOD', 'OUTSOD2', '원척킹[원덴]', '원척킹', '외주공정', '6', 'O', '', '', '' UNION ALL
SELECT 'DDOCRX', 'DDOCRX2', '포인트연삭[RX7/FX7/600X]', '포인트연삭', '서운공장', '7', '', 'O', '', '' UNION ALL
SELECT 'DDOCTP', 'DDOCTP2', '포인트연삭[TX7P/MX7]', '포인트연삭', '서운공장', '7', '', 'O', '', '' UNION ALL
SELECT 'DDOCTX', 'DDOCTX2', '포인트연삭[TX7/REX5B]', '포인트연삭', '서운공장', '7', '', 'O', '', '' UNION ALL
SELECT 'EMET_L', 'EMET_L1', '밑날연삭[EndTeeth]', '밑날연삭', '서운공장', '7', 'O', '', '', '' UNION ALL
SELECT 'EMETVK', 'EMETVK1', '밑날연삭[Roughing]', '밑날연삭', '서운공장', '7', 'O', '', '', '' UNION ALL
SELECT 'EMOCB1', 'EMOCB12', '밑날연삭[Insert2]', '밑날연삭', '부평공장', '7', 'O', '', '', '' UNION ALL
SELECT 'EMOCB2', 'EMOCB23', '밑날연삭[Large]', '밑날연삭', '서운공장', '7', 'O', '', '', '' UNION ALL
SELECT 'EMOCB4', 'EMOCB43', '밑날연삭[Small1]', '밑날연삭', '서운공장', '7', 'O', '', '', '' UNION ALL
SELECT 'EMOCB5', 'EMOCB54', '밑날연삭[Jumbo]', '밑날연삭', '서운공장', '7', 'O', '', '', '' UNION ALL
SELECT 'EMOCB6', 'EMOCB62', '밑날연삭[Small2,3]', '밑날연삭', '서운공장', '7', 'O', 'O', '', 'O' UNION ALL
SELECT 'EMOCB7', 'EMOCB73', '밑날 [ANCA] / [Special 1]', '밑날연삭', '서운공장', '7', 'O', '', '', '' UNION ALL
SELECT 'EMOCB9', 'EMOCB93', '밑날연삭[Small4]', '밑날연삭', '서운공장', '7', 'O', 'O', '', '' UNION ALL
SELECT 'EMSPR5', 'EMSPR53', '밑날 [WALTER] / [Special 1]', '밑날연삭', '서운공장', '7', 'O', '', '', '' UNION ALL
SELECT 'PCDBRZ', 'PCDBRZ1', 'PCD진공브레이징', 'PCD진공브레이징', '서운공장', '7', 'O', '', '', '' UNION ALL
SELECT 'PCDBRZ', 'PCDBRZ2', 'PCBN 진공브레이징', 'PCBN 진공브레이징', '서운공장', '7', 'O', '', '', '' UNION ALL
SELECT 'PCDEDM', 'PCDEDM2', 'PCD날부가공', 'PCD날부가공', '서운공장', '7', 'O', '', '', '' UNION ALL
SELECT 'CLCNMH', 'CLCNMH1', '호닝[MANUAL]', '호닝[MANUAL]', '서운공장', '8', '', 'O', '', '' UNION ALL
SELECT 'CLCNTY', 'CLCNTY1', 'TOYO폴리싱[Cleaning]', 'TOYO폴리싱', '서운공장', '8', '', 'O', '', '' UNION ALL
SELECT 'EMFTDS', 'EMFTDS1', '평면연삭[Cleaning]', '평면연삭', '서운공장', '8', 'O', 'O', '', 'O' UNION ALL
SELECT 'EMFTDS', 'EMFTDS3', '슬롯연삭[Cleaning]', '슬롯연삭', '서운공장', '8', '', 'O', '', 'O' UNION ALL
SELECT 'EMNKJM', 'EMNKJM2', 'NECK[Blank2]', 'NECK', '서운공장', '8', 'O', 'O', '', 'O' UNION ALL
SELECT 'EMOCB2', 'EMOCB27', '칩브레이커[Large]', '칩브레이커', '서운공장', '8', 'O', '', '', '' UNION ALL
SELECT 'EMOCB6', 'EMOCB66', '칩브레이커[Small2,3]', '칩브레이커', '서운공장', '8', 'O', '', '', '' UNION ALL
SELECT 'EMOCB7', 'EMOCB77', '칩브레이커[Special1]', '칩브레이커', '서운공장', '8', 'O', '', '', '' UNION ALL
SELECT 'EMOCB7', 'EMOCB78', 'NECK[Special1]', 'NECK', '서운공장', '8', 'O', '', '', '' UNION ALL
SELECT 'OTOCAN', 'OTOCAN3', '여유면연삭[Special2]', '여유면연삭', '서운공장', '8', '', 'O', '', 'O' UNION ALL
SELECT 'OTPIHU', 'OTPIHU1', '핀삽입', '핀삽입', '서운공장', '8', '', '', '', '' UNION ALL
SELECT 'CLCNNC', 'CLCNNC1', '세척[Cleaning]', '세척', '서운공장', '9', 'O', 'O', 'O', 'O' UNION ALL
SELECT 'EMCLHO', 'EMCLHO1', '호닝[Cleaning]', '호닝[Cleaning]', '서운공장', '9', 'O', 'O', 'O', 'O' 
# https://school.programmers.co.kr/learn/courses/30/lessons/42894
# 블록 게임


def det(board,blacks) :
    # 주어진 blacks 좌표들 위(0~y) 열에 블록이 존재하는지 확인
    # 하나라도 존재하면 False, 모두 비어 있으면 True 반환
    for i in blacks :
        x,y=i
        for j in range(y+1) :
            if board[x][j]!=0 :
                return False
    return True
        


def solution(board):
    # 제거한 블록 개수를 저장
    answer = 0
    # 편의상 보드를 전치(transpose)하여 (행, 열) -> (x, y) 좌표계로 전환
    board=list(map(list, zip(*board)))
    
    # dic : 블록 번호 -> 해당 블록이 차지하는 좌표 리스트
    dic={}
    n=len(board)
    for i in range(n) :
        for j in range(n) :
            if board[i][j]!=0 :
                if board[i][j] in dic :
                    dic[board[i][j]].append((i,j))
                else :
                    dic[board[i][j]]=[(i,j)]
                    
    # tip : 블록 번호 -> 블록의 좌상단 최소 좌표
    tip={}
    for i in dic :
        tip[i]=[51,51]
        for j in dic[i] :
            tip[i][0]=min(tip[i][0],j[0])
            tip[i][1]=min(tip[i][1],j[1])
    
    # dic2 : 블록 번호 -> {'block': 실제 블록 좌표 4칸, 'black': 검은칸 2칸}
    dic2={}
    for i in tip :
        dic2[i]={}
        x,y=tip[i]
        temp1=0
        
        l1=[]  # 블록이 차지하는 칸
        l2=[]  # 블록을 제거하기 위해 위가 비어있어야 하는 검은칸
        # 3행 2열(세로) 형태 검사
        for n in range(3) :
            for m in range(2) :
                if (x+n,y+m) in dic[i] :
                    temp1+=1
                    l1.append((x+n,y+m))
                else :
                    l2.append((x+n,y+m))
                    
        if temp1==4 :  # 4칸이 모두 존재하면 3x2 형태로 확정
            dic2[i]['block']=l1
            dic2[i]['black']=l2
            continue
        
        # 2행 3열(가로) 형태 검사
        temp2=0
        l1=[]
        l2=[]
        for n in range(2) :
            for m in range(3) :
                if (x+n,y+m) in dic[i] :
                    temp2+=1
                    l1.append((x+n,y+m))
                else :
                    l2.append((x+n,y+m))
                    
        dic2[i]['block']=l1
        dic2[i]['black']=l2

    step=0  # 안전 장치(무한 루프 방지)를 위한 반복 횟수 카운터
    
    while True :
        l=[]  # 이번 단계에서 제거할 블록 번호 저장
        if step==200 :  # 200회를 초과하면 종료
            break
        for i in dic2 :
            # 검은칸 위가 모두 비어 있으면 블록 제거 가능
            if det(board,dic2[i]['black']) :
                l.append(i)
                # 검은칸과 블록 좌표를 모두 0으로 덮어 삭제
                for j in dic2[i]['black'] :
                    x,y=j
                    board[x][y]=0
                for j in dic2[i]['block'] :
                    x,y=j
                    board[x][y]=0
                answer+=1
        # dic2에서 제거한 블록 삭제
        for i in l :
            del dic2[i]
        step+=1
        
    return answer

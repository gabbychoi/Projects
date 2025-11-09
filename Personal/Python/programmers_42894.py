# https://school.programmers.co.kr/learn/courses/30/lessons/42894
# 블록 게임



def det(board,blacks) :
    for i in blacks :
        x,y=i
        for j in range(y+1) : # 위로 블록을 빼서 부딪히는지 테스트
            if board[x][j]!=0 : # 위로빼다가 다른 블록에 부딪히면 False
                return False
    return True
        




def solution(board):
    answer = 0
    board=list(map(list, zip(*board)))
    dic={} # Board 의 블록 숫자 위치를 기록하기 위한 Dictionary
    n=len(board)
    for i in range(n) :
        for j in range(n) :
            if board[i][j]!=0 :
                if board[i][j] in dic :
                    dic[board[i][j]].append((i,j))
                else :
                    dic[board[i][j]]=[(i,j)]
                    
    tip={} # 블록별 tip : 포함하는 최소 직사각형의 가장 왼쪽 상단 위치로 정의하여 이 tip  을 기록한다.
    for i in dic :
        tip[i]=[51,51] # 초기 tip 을 최대치로 기록한 뒤
        for j in dic[i] :
            tip[i][0]=min(tip[i][0],j[0]) # x 축에 대한 tip 값을 min 으로 기록하여 tip 을 찾는다
            tip[i][1]=min(tip[i][1],j[1]) # 나머지 축에 대해서도 동일 작업 수행.
    
    dic2={}
    for i in tip :
        dic2[i]={}
        x,y=tip[i]
        temp1=0
        
        l1=[]
        l2=[]
        # 우선 세로로 긴 모양의 블록으로 가정 세로로 긴 모양의 경우 반드시 4칸을 차지하게 된다. 가로로 긴 모양은 3칸 이하를 차지
        for n in range(3) :
            for m in range(2) :
                
                if (x+n,y+m) in dic[i] :
                    temp1+=1
                    l1.append((x+n,y+m))
                else :
                    l2.append((x+n,y+m))
        # 4칸을 차지하는게 확인되면
        if temp1==4 :
            dic2[i]['block']=l1 ## 블록 칸과
            dic2[i]['black']=l2 ## 비어있는 칸은 black 으로 등록한다.
            continue # 이후 과정은 건너뛰게 처리
        
        #  continue 되지 않으면 가로로 긴 모양이므로 가로로 긴 모양에 대한 수행을 마찬가지로 한다.
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
    
    
    #step 을 정의해준다. 블록은 200개 이하이므로 200회에서 break 를 걸 것이다.
    step=0
    
    while True :
        l=[] # 이번 스텝에서 뺄 수 있는 블록을 정의
        if step==200 : # block 갯수는 200개 이하이므로 최대2 00회만 진행하면 충분하다.
            break
        for i in dic2 : # 모든 블록에 대해 테스트 과정
            if det(board,dic2[i]['black']) : # 테스트를 마치면
                l.append(i) 
                for j in dic2[i]['black'] :
                    x,y=j
                    board[x][y]=0 # 빠지는 블록이므로 채운 블록을 0 처리
                for j in dic2[i]['block'] :
                    x,y=j
                    board[x][y]=0 # 마찬가지로 블록부분도 0 처리
                answer+=1
        for i in l :
            del dic2[i] # Dictionary 에서도 l 에서 포함시킨 블록을 제거
        step+=1 # 스텝을 지행시킨다.
        
    
    
    return answer
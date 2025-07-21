# https://school.programmers.co.kr/learn/courses/30/lessons/42888
# 오픈채팅방


def solution(record) :
    answer=[]
    
    # 문자열을 공백 기준으로 분리 → [명령, uid, (닉네임)]
    record=[i.split() for i in record]

    User={}
    # ----------------------------- 1단계: uid별 '최종 닉네임' 저장 -----------------------------
    # Enter·Change 명령에서 닉네임을 갱신해 두면,
    # 이후 출력 메시지에서 항상 최신 닉네임을 쓸 수 있다.
    for i in record :
        if i[0] != 'Leave':           # 'Enter' 또는 'Change'만 해당
            User[i[1]] = i[2]         # uid → nickname 최신화
            
    # ----------------------------- 2단계: 채팅방 로그 재생성 -----------------------------
    # 실제 출력은 'Enter'와 'Leave'만 대상
    for i in record :
        if i[0] == 'Enter':
            answer.append(User[i[1]] + '님이 들어왔습니다.')
        if i[0] == 'Leave':
            answer.append(User[i[1]] + '님이 나갔습니다.')
    
    return answer
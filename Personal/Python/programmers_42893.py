# https://school.programmers.co.kr/learn/courses/30/lessons/42893
# 매칭 점수


import re  # 정규 표현식을 위한 모듈

def getScore(word, page):
    import re
    # (1) 알파벳(a~z) 이외의 문자는 모두 '.'으로 치환
    # (2) '.' 기준으로 split → 단어 리스트
    # (3) 검색어(word) 소문자 기준 등장 횟수 반환
    return re.sub('[^a-z]+', '.', page.lower()).split('.').count(word.lower())

def solution(word, pages):
    Score = {}  # 각 페이지의 점수·링크·인덱스를 저장할 딕셔너리
    
    # ----------------------------- 1단계: 기본 점수 계산 -----------------------------
    for i, j in enumerate(pages):              # i: 페이지 인덱스, j: HTML 원문
        # [URL 추출] <meta property="og:url" content="URL" ...> 태그에서 URL만 뽑기
        pagetitle = j.split('<meta property=\"og:url\" content=\"')[1].split('\"')[0]
        Score[pagetitle] = {}
        Score[pagetitle]['index'] = i          # 이후 동일 점수 시, 작은 인덱스 우선
    
        # [본문 추출] <body> ... </body> 사이만 사용
        bodyp = j.split('<body>')[1].split('</body>')[0]
    
        # [외부 링크 추출] <a href="링크"> 형태
        body = bodyp.split('<a href=\"')
        links = []
        for j in body[1:]:                     # body[0]은 본문, 이후 조각이 링크 포함
            links.append(j.split('\">')[0])    # "링크"> 까지 중 URL만 남김
    
        # [기본 점수] 검색어 등장 횟수
        score = getScore(word, bodyp)
    
        # 점수 및 링크 정보 저장
        Score[pagetitle]['Score'] = score
        Score[pagetitle]['link'] = links
    
        # [링크 점수] 기본 점수 ÷ 외부 링크 수 (링크 없으면 0)
        try:
            Score[pagetitle]['linkscore'] = score / len(links)
        except:
            Score[pagetitle]['linkscore'] = 0
    
    # ----------------------------- 2단계: 링크 점수 전파 -----------------------------
    for i in Score:                            # i: 현재 페이지 URL
        for j in Score[i]['link']:             # j: i 페이지가 가리키는 외부 URL
            try:
                # 대상 페이지가 존재하면 링크 점수를 더해줌
                Score[j]['Score'] += Score[i]['linkscore']
            except:
                # 외부 URL이 주어진 목록에 없을 때는 건너뜀
                pass
    
    # ----------------------------- 3단계: 최종 답 도출 -----------------------------
    x = 0
    for i in Score:                            # 최고 점수 계산
        x = max(x, Score[i]['Score'])
    
    for i in Score:                            # 동일 점수면 인덱스가 작은 페이지가 먼저 저장돼 있으므로
        if Score[i]['Score'] == x:             # 최초로 만난 최고 점수 페이지의 인덱스 반환
            return Score[i]['index']
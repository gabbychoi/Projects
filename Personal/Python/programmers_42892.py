# https://school.programmers.co.kr/learn/courses/30/lessons/42892
# 길 찾기 게임

import sys  # 재귀 깊이 제한 조정을 위해 사용

sys.setrecursionlimit(10**6)  # 깊은 재귀(최대 노드 수 10 000+)를 대비해 스택 한도를 넉넉히 올려 둔다.


class Node:
    # 이진 트리 노드를 표현하는 간단한 클래스
    def __init__(self, x, id, leftbound, rightbound):
        self.x = x                  # 현재 노드의 x 좌표(부모-자식 방향 결정에 사용)
        self.id = id                # 문제에서 요구하는 노드 번호
        self.leftbound = leftbound  # 현재 노드가 담당하는 x 구간의 왼쪽 경계
        self.rightbound = rightbound  # 현재 노드가 담당하는 x 구간의 오른쪽 경계
        self.left = None            # 왼쪽 자식
        self.Right = None           # 오른쪽 자식(※ 대문자 R 주의)


# 전위·후위 순회 결과를 저장하는 전역 리스트
preorderresult = []
postorderresult = []


def preorder(node):
    """전위(pre-order) 순회"""
    preorderresult.append(node.id)     # (1) 자기 자신
    if node.left is not None:          # (2) 왼쪽 서브트리
        preorder(node.left)
    if node.Right is not None:         # (3) 오른쪽 서브트리
        preorder(node.Right)


def postorder(node):
    """후위(post-order) 순회"""
    if node.left is not None:          # (1) 왼쪽 서브트리
        postorder(node.left)
    if node.Right is not None:         # (2) 오른쪽 서브트리
        postorder(node.Right)
    postorderresult.append(node.id)    # (3) 자기 자신


def solution(nodeinfo):
    """
    nodeinfo: [[x, y], ...]  (1 ≤ x, y ≤ 100 000)
    y가 클수록 트리에서 높은 레벨(부모)에 위치,
    y가 같으면 x가 작은 노드가 왼쪽에 온다는 조건으로
    이진 트리를 구성한 뒤 전위·후위 순회 결과를 반환.
    """
    # ------------------------------------------------------------------
    # 1) 노드 번호(id) 부여 및 y 좌표 내림차순 정렬
    # ------------------------------------------------------------------
    nodeinfo = [j + [i + 1] for i, j in enumerate(nodeinfo)]  # j = [x, y] → [x, y, id]
    nodeinfo.sort(key=lambda x: x[1], reverse=True)           # y 기준 내림차순

    # ------------------------------------------------------------------
    # 2) 같은 y 값을 가진 노드끼리 레벨 배열(array)로 묶기
    #    array[level] = [(x, id), ...]  (x 오름차순 정렬)
    # ------------------------------------------------------------------
    array = []
    now = -1
    for i in nodeinfo:
        y = i[1]
        if y != now:          # 새 레벨 시작
            array.append([])
            now = y
        array[-1].append((i[0], i[2]))  # (x, id) 저장
    for i in range(len(array)):
        array[i] = sorted(array[i])     # 같은 레벨은 x 오름차순

    # ------------------------------------------------------------------
    # 3) 루트 노드 생성
    #    (가장 높은 레벨에서 x가 가장 작은 노드가 트리의 루트)
    #    전체 x 범위를 0~100 000으로 가정
    # ------------------------------------------------------------------
    root = Node(array[0][0][0], array[0][0][1], 0, 100000)

    # 레벨별 부모 탐색을 돕기 위한 리스트
    nodelist = [[]]
    nodelist[0].append(root)

    # ------------------------------------------------------------------
    # 4) 레벨을 내려가며 각 노드를 부모에게 연결
    #    부모의 x·경계(leftbound/rightbound)에 따라 왼·오른쪽 자식 결정
    # ------------------------------------------------------------------
    for level in range(1, len(array)):
        nodelist.append([])           # 현재 레벨 노드 저장용
        for data in array[level]:
            x, id = data
            # 해당 노드를 품을 부모를 찾으면 break (부모는 유일)
            for parentnode in nodelist[level - 1]:
                # 왼쪽 자식 조건: 부모 leftbound ≤ x < 부모.x
                if parentnode.leftbound <= x and parentnode.x > x:
                    nownode = Node(x, id, parentnode.leftbound, parentnode.x)
                    parentnode.left = nownode
                    nodelist[level].append(nownode)
                    break
                # 오른쪽 자식 조건: 부모.x < x ≤ 부모 rightbound
                elif parentnode.rightbound >= x and parentnode.x < x:
                    nownode = Node(x, id, parentnode.x, parentnode.rightbound)
                    parentnode.Right = nownode
                    nodelist[level].append(nownode)
                    break

    # ------------------------------------------------------------------
    # 5) 순회 결과 도출
    #    문제는 [전위, 후위] 결과를 요구하므로
    #    postorder → preorder 호출 후 [preorder, postorder] 순서로 반환
    # ------------------------------------------------------------------
    postorder(root)   # 후위 순회
    preorder(root)    # 전위 순회
    return [preorderresult, postorderresult]
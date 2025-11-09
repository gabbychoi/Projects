**ADF Linked Service를 이용한 주요 DBMS 연결 문서화**

---

# 1. 목적

Azure Data Factory (ADF) Linked Service를 통해 주요 메이저 데이터베이스(DBMS)와 안전하고 효율적으로 연결하기 위한 기본 설정 방안을 문서화한다.

# 2. 주요 DBMS별 연결 방식 요약

| DBMS/연결유형  | 연결 방식                                                              | 필수 정보                                                | 주의 사항                              |
| ---------- | ------------------------------------------------------------------ | ---------------------------------------------------- | ---------------------------------- |
| Oracle     | ADF "Oracle Database" Linked Service                               | Host, Port(1521), Service Name, Username, Password   | SSL 필요 시 추가 설정, TNS 지원 안 됨         |
| SQL Server | ADF "Azure SQL Database" 또는 "SQL Server" Linked Service            | Host, Port(1433), Database Name, Username, Password  | 퍼블릭 IP 필요, VNet Integration 가능     |
| MySQL      | ADF "Azure Database for MySQL" 또는 "MySQL" Linked Service           | Host, Port(3306), Database Name, Username, Password  | SSL 인증서 적용 권장                      |
| PostgreSQL | ADF "Azure Database for PostgreSQL" 또는 "PostgreSQL" Linked Service | Host, Port(5432), Database Name, Username, Password  | VNet 설정 가능, SSL 기본 사용              |
| SAP HANA   | ADF "SAP HANA" Linked Service                                      | Host, Port(30015), Database Name, Username, Password | HANA 버전 호환성 확인                     |
| OData      | ADF "OData" Linked Service                                         | Service URL, Authentication Type, Username, Password | 인증 방식(OAuth2, Basic) 선택 필요         |
| ODBC       | ADF "ODBC" Linked Service                                          | Connection String, Username, Password                | 드라이버 설치 및 설정 필요, Self-hosted IR 필수 |
| JDBC       | ADF "Generic JDBC" Linked Service                                  | JDBC URL, Driver Class Name, Username, Password      | 드라이버 업로드 필요, Self-hosted IR 필수     |

# 3. 기본 연결 절차

## 3.1 Linked Service 생성

- ADF Studio > Manage > Linked Services > New > 해당 DBMS 선택

## 3.2 입력해야 할 주요 파라미터

- Server Name (IP or FQDN)

- Port Number

- Database Name

- Authentication (Username, Password)

- (필요 시) SSL 설정 및 인증서 업로드

## 3.3 Self-hosted Integration Runtime 필요 여부

- DB가 사내망에 위치한 경우: **Self-hosted IR 설치 필수**

- 퍼블릭 IP로 접근 가능한 경우: Azure Hosted IR 사용 가능

# 4. 데이터 추출 시나리오

## 4.1 데이터 전체 적재 (Full Load)

- 설명: 데이터베이스의 전체 데이터를 주기적으로 모두 추출하여 적재하는 방식.

- 고려 조건:
  
  - 데이터 볼륨이 상대적으로 작고 ETL 소요 시간이 짧은 경우
  
  - 데이터 구조 변경이 자주 발생하는 경우
  
  - 변경 데이터 추적이 어려운 경우

- 장점:
  
  - 구현이 간단하지만 비용이 과다할 가능성
  
  - 검증 시나리오 작성이 쉬움

- 단점:
  
  - 데이터 중복 저장 위험
  
  - 대용량 데이터 환경에서는 비효율적

## 4.2 증분 적재 (Incremental Load)

- 설명: 이전 추출 이후 변경되거나 추가된 데이터만 추출하여 적재하는 방식.

- 고려 조건:
  
  - 데이터 볼륨이 크거나 ETL 비용이 높은 경우
  
  - 변경 이력 관리가 필요한 경우

- 구현 방법:
  
  - 타임스탬프 컬럼 기반 추출 (LastModifiedDate 등)
  
  - CDC(Change Data Capture) 또는 로그 기반 복제 활용

- 장점:
  
  - 데이터 전송량 감소
  
  - 처리 시간 및 비용 절감

- 단점:
  
  - 초기 구현 복잡성 증가
  
  - 누락/오류 발생 시 복구 전략 필요

---

# 5. SAP 경영 실적 관련 주요 키 & 마스터 테이블

| 분류    | 주요 키 필드   | 설명            | 대표 마스터 테이블                                                    | 타임스탬프 컬럼                   |
| ----- | --------- | ------------- | ------------------------------------------------------------- | -------------------------- |
| 회사 조직 | **BUKRS** | 회사 코드 (법인 단위) | T001 (Company Codes)                                          | AEDAT (변경일자)               |
| 사업장   | **WERKS** | 플랜트/사업장 코드    | T001W (Plants/Branches)                                       | AEDAT (변경일자)               |
| 영업조직  | **VKORG** | 영업 조직 코드      | TVKO (Sales Organizations)                                    | AEDAT (변경일자)               |
| 구매조직  | **EKORG** | 구매 조직 코드      | T024E (Purchasing Organizations)                              | AEDAT (변경일자)               |
| 코스트센터 | **KOSTL** | 비용 발생 단위      | CSKS (Cost Center Master Data)                                | AEDAT (변경일자)               |
| 품목    | **MATNR** | 제품/품목 코드      | MARA (General Material Data), MARC (Plant-specific Data)      | ERSDA (생성일자), LAEDA (변경일자) |
| 제품계층  | **PRDHA** | 제품 분류 체계 코드   | MARA (Material Master, PRDHA 필드)                              | LAEDA (변경일자)               |
| 고객    | **KUNNR** | 고객 코드         | KNA1 (General Customer Master)                                | ERDAT (생성일자), AEDAT (변경일자) |
| 공급업체  | **LIFNR** | 공급업체 코드       | LFA1 (General Vendor Master)                                  | ERDAT (생성일자), AEDAT (변경일자) |
| 계정    | **SAKNR** | 일반원장 계정 번호    | SKA1 (Chart of Accounts Master), SKB1 (Company Code-specific) | AEDAT (변경일자)               |
| 통화    | **WAERS** | 통화 코드         | TCURC (Currency Codes)                                        | (타임스탬프 없음)                 |
| 환율유형  | **KURST** | 환율 적용 유형      | TCURV (Exchange Rate Types)                                   | (타임스탬프 없음)                 |
| 계획버전  | **VERSN** | 계획 데이터 버전     | TKA09 (CO Version Settings)                                   | (타임스탬프 없음)                 |

---

# 6. 트랜잭션 뷰

| 트랜잭션 유형   | 원천 테이블명 | 설명                                              | 타임스탬프 컬럼               |
| --------- | ------- | ----------------------------------------------- | ---------------------- |
| 매출 송장 헤더  | VBRK    | Sales Billing Document Header                   | FKDAT (회계전표일자)         |
| 매출 송장 아이템 | VBRP    | Sales Billing Document Items                    | FKDAT (회계전표일자)         |
| 구매 오더 헤더  | EKKO    | Purchase Order Header                           | AEDAT (구매오더 생성일자)      |
| 구매 오더 아이템 | EKPO    | Purchase Order Items                            | AEDAT (구매오더 생성일자)      |
| 비용 발생 데이터 | COEP    | CO Line Items (Cost Centers, Internal Orders 등) | BUDAT (전기일자)           |
| 회계 문서 헤더  | BKPF    | Accounting Document Header                      | BUDAT (전기일자)           |
| 회계 문서 아이템 | BSEG    | Accounting Document Line Item                   | BUDAT (전기일자) (BKPF 연계) |
| 예산 계획 데이터 | BPJA    | CO-OM Planning Data (Cost Center Level)         | (타임스탬프 없음)             |
| 예산 실행 데이터 | BPGE    | CO-OM Planning Line Items                       | (타임스탬프 없음)             |

---

# 증분 전략

| 증분 유형    | 처리 방법                    | 상세 설명                                                                      |
| -------- | ------------------------ | -------------------------------------------------------------------------- |
| 월 마감 기준  | 매월 1일에 이전 월 데이터 삭제 후 재적재 | 데이터 양이 적으면 Upsert, 데이터 양이 많으면 월 단위 파티션 Truncate 후 Append (기준: 50~80만 건 이상) |
| 연 마감 기준  | 1년 전체 데이터 재적재            | 연간 단위로 전체 데이터 삭제 후 재적재                                                     |
| 일일 증분 기준 | 2일 전 데이터까지 증분 처리         | 운영 안정성을 위해 2일 전 데이터 기준으로 증분 추출 및 적재                                        |

---

# SAP 기준정보 ETL 전략

경영정보의 경우 ETL 전략은 다음과 같이 구분된다:

- SAP ERP가 ABAP 기반으로 테이블을 생성하고 관리하는 경우, BUKRS(회사코드), MATNR(품목코드), KOSTL(코스트센터), KUNNR(고객코드) 등 주요 식별자 키를 그대로 활용할 수 있다.

- 따라서 **OData 서비스가 제공되는 경우**, 원 테이블 또는 표준 View를 통해 OData API 호출하여 필요한 식별자와 데이터를 가져오는 방식이 가능하다.

- 그러나 OData 성능이나 API 제공 범위 제한이 있을 경우, **원본 테이블에서 필요한 식별자 키(BUKRS, MATNR 등)를 직접 조합하여 데이터 모델링 후 추출**하는 방법이 더 일반적이다.

- ABAP CDS View 기반이라면, 기존 ERP 테이블을 조합한 View를 활용하여 ETL 효율성을 높일 수 있다.

### 요약

- 가능하면 **표준 OData 서비스**를 우선 활용.

- 필요 시 **원본 테이블에서 주요 키를 조합**하여 ETL 파이프라인 구성.

- 식별자 조합 및 관리 기준은 BUKRS, MATNR, KOSTL, KUNNR 등 SAP ERP 핵심 키를 기준으로 한다.

# SAP 데이터 ETL 전략

| 구분    | 기준정보          | 트랜잭션 데이터                               |
| ----- | ------------- | -------------------------------------- |
| 증분 컬럼 | AEDAT, LAEDA  | FKDAT, BUDAT 등                         |
| 처리 전략 | Key 기반 UPSERT | 비즈니스 날짜 기반 DELSERT(or Truncate Append) |
| 특징    | 변경 중심 관리      | 변동 가능성 높은 이벤트 중심 관리                    |

---

# 고객사 협조 사항

SAP 기준정보의 정확한 해석과 정제 작업을 위해 고객사의 다음 항목에 대한 협조가 필요하다:

- 기준정보의 **사용 여부 및 유효 범위** (예: 불용 품목, 폐기된 계정 등)

- **코드 설명/텍스트 매핑 테이블** 제공 (예: 고객명, 품목명, 조직명 등)

- **조직도/계층 구조 정보** 제공 (예: 코스트센터 → 본부 → 사업부)

- 실제 사용하는 항목만 필터링할 수 있는 기준 정의 (예: 최근 1년 사용된 KOSTL만)

- SAP 내 **데이터 추출 필터 조건 합의** 및 테스트 검증 참여

위 항목은 추출된 기준정보가 실질적인 분석 및 리포팅에 활용될 수 있도록 하기 위한 필수적 협업이다.

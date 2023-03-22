/* 20230322 */

/* 전일자 : CREATE TABLE 해보기  */
 CREATE TABLE DEPT_TEMP 
	   	AS (SELECT * FROM DEPT) ;
	   	--CREATE / ALTER / DROP : 우측 명령어 입력되면 자동 커밋
	   	--COMMIT ; --TO CONFIRM의 의미

--INSERT : 이 데이터를 어디로 입력할지 주소가 꼭 필요하다
	  -- VALUES (데이터1,데이터2, ---)
INSERT INTO DEPT_TEMP (DEPTNO, DNAME, LOC)
	VALUES (50, 'DATABASE', 'SEOUL')
;

--테이블 안에 데이터 조회해보기
SELECT *
FROM DEPT_TEMP ;

--NULL 입력 : 가능
INSERT INTO DEPT_TEMP (DEPTNO, DNAME, LOC)
	VALUES (70, 'WEB', NULL)
;
--공백도 : 가능
INSERT INTO DEPT_TEMP (DEPTNO, DNAME, LOC)
	VALUES (80, 'MOBILE', '')
;
--컬럼은 적어놓고 데이터 없는건 :  불가
INSERT INTO DEPT_TEMP (DEPTNO, DNAME, LOC)
	VALUES (90, 'INCHEON')
;
--컬럼 개수와 맞추면 가능
INSERT INTO DEPT_TEMP (DEPTNO, DNAME)
	VALUES (90, 'INCHEON')
;

/* 컬럼 복사해서 새로운 테이블 생성해보기 : 새로운 테이블명 EMP_TEMP */
--WHERE 조건절에 1 <> 1
CREATE TABLE EMP_TEMP AS
SELECT * FROM EMP 
	WHERE 1 <> 1
	;
--HIREDATE : '2021/01/01' 처럼 문자형식으로 INSERT하면 원래 에러가 정상 -> TO_DATE로 바꿔서 입력해주자.
INSERT INTO EMP_TEMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
	VALUES(9997, '홍길동', 'PRESIDENT', NULL, TO_DATE('2001/01/01', 'YYYY/MM/DD'), 6000, 500, 10)
;
INSERT INTO EMP_TEMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
	VALUES(2111, '이순신', 'MANAGER', 9999, TO_DATE('07/01/1999', 'DD/MM/YYYY'), 4000, NULL, 20)
;
--날짜를 문자형으로 입력해도 규격에 맞지 않으면 자동변환 안됨. DD/MM/YYYY(오류)
INSERT INTO EMP_TEMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
	VALUES(2112, '이순신순신', 'MANAGER', 9999, '07/01/1999', 4000, NULL, 20)
;
--오늘 입사했다 가정 -> SYSDATE 사용 가능
INSERT INTO EMP_TEMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
	VALUES(3111, '심청이', 'MANAGER', 9999, SYSDATE, 4000, NULL, 30)
;
-- SMART 방법으로 INSERT하기 : 가지고 있는 기존 테이블의 데이터 중 일부를 가져다 붙이기.
INSERT INTO EMP_TEMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
	SELECT E.EMPNO 
			, E.ENAME 
			, E.JOB 
			, E.MGR 
			, E.HIREDATE 
			, E.SAL , E.COMM , E.DEPTNO 
	FROM EMP E, SALGRADE S
	WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL
		AND S.GRADE = 1
;

/*  'UPDATE..SET..WHERE절 필수**' : 필터된 필요한 데이터에 대해서만 레코드 값을 수정하고 싶을 때 사용 */
--*WHERE이 없으면, 모든 데이터 값이 다 바뀐다.
--먼저 테이블 새로 생성
CREATE TABLE DEPT_TEMP2 AS
	(SELECT * FROM DEPT) ; --테스트 테이블 생성

--부서 구분기준이 담긴 테이블 내용 일부 변경 (지역이 DALLAS -> SEOUL로 변경 )
UPDATE DEPT_TEMP2
	SET LOC = 'DALLAS'
	WHERE LOC = 'SEOUL'
;
--부서명이 OPERATIONS 일 경우 서울로 근무지역 바뀌고 부서명도 바꾸자.
UPDATE DEPT_TEMP2
	SET	DNAME = 'DATABASE'
		,LOC = 'SEOUL'
	WHERE DEPTNO = 40
;

/* 또 다른 방식 : 서브쿼리를 이용하여 UPDATE */
--서울로 발령낸 OPERATIONS 부서 다시 원위치로 돌아왔다. DEPT 테이블(기존데이터) 다시 입힘.
UPDATE DEPT_TEMP2 
SET (DNAME, LOC) = (SELECT DNAME, LOC
					FROM DEPT
					WHERE DEPTNO = 40)
WHERE DEPTNO = 40; --다시 원위치로 돌려

ROLLBACK; --롤백 해보았지만, 안돌아간다 서브쿼리로 변경한건.
COMMIT;

/* DELETE 구문으로 테이블에서 값을 제거할 때
 * DELETE 말고 UPDATE 구문으로 상태 값을 변경해주자.
 * 
 * 작성 : DELETE FROM...
 * 		WHERE절... 조건 필수!!
 * 
 * 예시) 근무/휴직/퇴사 등의 유형으로 값을 변경 */
 CREATE TABLE EMP_TEMP2 --테스트 테이블 먼저 생성
	   	AS (SELECT * FROM EMP) ;
	   COMMIT;
	  
--인사발령으로 매니저 삭제 예정
DELETE FROM EMP_TEMP2
WHERE JOB = 'MANAGER'
;
ROLLBACK; --결재 대기중...
COMMIT; --결재취소상태로 확정

--상황 : EMP_TEMP2 에서 삭제할 직원 EMPNO 7499, 7844
DELETE
FROM EMP_TEMP2
WHERE EMPNO IN (
			SELECT EMPNO 
			FROM EMP_TEMP2 E, SALGRADE S
			WHERE E.SAL BETWEEN S.LOSAL  AND S.HISAL
						AND S.GRADE = 3
						AND E.DEPTNO = 30)
;

/* CREATE 문을 정의해보기 : 기존에 없던 테이블 구조를 생성 
 * 데이터는 없고 테이블의 컬럼과 데이터 타입, 제약 조건을 생성해보기 */

CREATE TABLE EMP_NEW (
		EMPNO  NUMBER(4)
		, ENAME VARCHAR(10)
		, JOB VARCHAR(9)
		, MGR NUMBER(4)
		, HIREDATE DATE
		, SALGRADE NUMBER(7,2)
		, COMM NUMBER(7,2)
		, DEPTNO NUMBER(2)
);

SELECT *
FROM EMP
WHERE ROWNUM <= 5;

--테이블에 새로운 컬럼을 추가해보기(ADD)
ALTER TABLE EMP_NEW
	 ADD HP VARCHAR(20) ;

--컬럼 이름 바꾸기(RENAME COLUMN)
ALTER TABLE EMP_NEW 
RENAME COLUMN HP TO TEL_NO ; --바꿀 컬럼명 TO 바뀐 후 컬럼명

--컬럼명 바꾸고 쓰려했는데, 기존 TYPE이 안맞아서 바꿔줄 땐 MODIFY
--직원 수가 많아져서, 직원관리번호를 5자리로 변경
ALTER TABLE EMP_NEW 
MODIFY EMPNO NUMBER(5) ;

--관리하던 직원 휴대폰번호 컬럼 삭제
ALTER TABLE EMP_NEW 
DROP COLUMN TEL_NO
;
ROLLBACK;

/* SEQUENCE(일련번호) : 일련번호 생성해서 테이블 관리해보기*/

CREATE SEQUENCE SEQ_DEPTSEQ
	INCREMENT BY 1 --증가 값 
	START WITH 1 --일련번호의 시작값
	MAXVALUE 999 --일련번호 최대로 입력가능한 값
	MINVALUE 1 --최소값
	NOCYCLE NOCACHE --노사이클 : 999 최대값에 도착하면 멈추기 ㅎ (디폴트 : 20)
	;

CREATE TABLE DEPTSEQ AS --테스트용 테이블 생성
	SELECT *
	FROM DEPT;

/* 만든 SEQUENCE 를 사용하여 INSERT 해보기 */
--부서번호를 수기로 입력하지 않아도, 순차적으로 +1씩 증가하면서 데이터가 들어간다.
INSERT INTO DEPTSEQ (DEPTNO, DNAME, LOC)
	VALUES (SEQ_DEPTSEQ.NEXTVAL, 'DATABASE', 'SEOUL')
	;
INSERT INTO DEPTSEQ (DEPTNO, DNAME, LOC)
	VALUES (SEQ_DEPTSEQ.NEXTVAL, 'WEB', 'BUSAN')
	;
INSERT INTO DEPTSEQ (DEPTNO, DNAME, LOC)
	VALUES (SEQ_DEPTSEQ.NEXTVAL, 'MOBILE', 'SEOGSU')
	;

/* 테이블의 제약조건을 설정 CONSTRAINTS */
CREATE TABLE LOGIN (
	LOG_ID     VARCHAR2(20) NOT NULL
	, LOG_PWD  VARCHAR2(20) NOT NULL
	, TEL      VARCHAR2(20) 
);
--테이블에 데이터 채우기
INSERT INTO LOGIN (LOG_ID, LOG_PWD)
 VALUES ('TEST01', '1235')
 ;
--조회
SELECT *
FROM LOGIN;

/*TEL 컬럼의 중요성을 나중에 인지하고, NOT NULL 제약조건을 설정하기로 했다. */
--후거래 실시!
ALTER TABLE LOGIN 
	MODIFY TEL NOT NULL
;

--선거래 : TEL 없는 고객이 테이블에 있어서, 제약조건 설정이 선거래가 안된다. 데이터부터 바꾸자.
UPDATE LOGIN 
SET TEL = '010-3106-2939'
WHERE LOG_ID = 'TEST01'
;

--오라클이 사용자를 위해 만들어 놓은 제약조건 설정값 테이블 :  CONSTRAINTS

SELECT OWNER
	, CONSTRAINT_NAME
	, CONSTRAINT_TYPE
	, TABLE_NAME
	FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'LOGIN'
;

SELECT OWNER
		, CONSTRAINT_NAME
		, CONSTRAINT_TYPE
		, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'LOGIN'
;
--
ALTER TABLE LOGIN
MODIFY (TEL CONSTRAINT TEL_NN NOT NULL)
;
--제약조건 삭제(DROP CONSTRANINT)
ALTER  TABLE LOGIN 
DROP CONSTRAINT SYS_C007040 --제약조건 이름이 없어서 주어진 이름을 그대로 사용함.
;

/*유니크 키워드 사용한 테이블 만들기 */
CREATE TABLE LOG_UNIQUE (
	LOG_ID VARCHAR2(20) UNIQUE 
	,LOG_PWD VARCHAR2(20) NOT NULL
	,TEL VARCHAR2(20)
);


--상위 2개 행 보여줘
SELECT *
FROM EMP 
WHERE ROWNUM <= 3;
	
SELECT *
FROM USER_CONSTRAINTS 
WHERE TABLE_NAME = 'LOG_UNIQUE';

INSERT INTO LOG_UNIQUE (LOG_ID, LOG_PWD, TEL)
	VALUES ('TEST01', 'PWD12', '010-0000-0000');

INSERT INTO LOG_UNIQUE (LOG_ID, LOG_PWD, TEL)
	VALUES ('TEST02', 'PWD12', '010-0000-0001');

INSERT INTO LOG_UNIQUE (LOG_ID, LOG_PWD, TEL)
	VALUES ('TEST03', 'PWD13', '010-0000-0002');

INSERT INTO LOG_UNIQUE (LOG_ID, LOG_PWD, TEL)
	VALUES ('', 'PWD13', '010-0000-0002');

SELECT *
FROM LOG_UNIQUE;



UPDATE LOG_UNIQUE
SET LOG_ID = 'TEST_ID_NEW' --사용자가 변경요청한 ID
WHERE LOG_ID IS NULL;

ALTER TABLE LOG_UNIQUE 
	MODIFY (TEL UNIQUE);

--
CREATE TABLE LOG_PK
( 	LOG_ID   VARCHAR2(20) PRIMARY KEY
	,LOG_PWD  VARCHAR2(20) NOT NULL
	, TEL 	VARCHAR2(20)
);

INSERT INTO LOG_PK (LOG_ID , LOG_PWD , TEL)
	VALUES('ID01', 'PWD01', '010-1111-2222');

--기존 데이터와 동일한 ID입력 시 에러발생 정상
INSERT INTO LOG_PK (LOG_ID , LOG_PWD , TEL)
	VALUES('ID01', 'PWD03', '010-1111-2222');

INSERT INTO  LOG_PK (LOG_ID , LOG_PWD , TEL)
	VALUES('ID02', 'PWD02', '010-1111-2222');

--FK
--존재하지 않는 부서번호를 테이블에 입력했을 때를 시도해보자
SELECT *
FROM EMP_TEMP;
--EMP_TEMP 테이블에 입력
INSERT INTO EMP_TEMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
	VALUES (3333, 'VINGO', 'DD', 9999, '2020/01/01', 3333, 100, 99);

/* 인덱스를 활용한 빠른 검색  */
--장점 : 순식간에 써치가능
--단점 : 입 출력이 많으면 인덱스 설정으로 속도 저하
CREATE INDEX IDX_EMP_JOB
	ON EMP(JOB)
	;
	
--설정해둔 인덱스 리스트를 출력해보기
SELECT *
FROM USER_INDEXES 
WHERE TABLE_NAME IN ('EMP', 'DEPT');

/* VIEW 생성 : 가상테이블로 사용한다 */
CREATE VIEW VW_EMP
	AS (SELECT EMPNO, ENAME, JOB, DEPTNO
		FROM EMP 
		WHERE DEPTNO = 10); --EMP테이블에서 직원번호 10인 사람을 모두 가져와줘~

SELECT *
FROM USER_VIEWS 
WHERE VIEW_NAME = 'VW_EMP' ;

/* ROWNUM 사용해보기 : 상위 N개출력 */
SELECT ROWNUM
		, E.*
	FROM EMP E
	ORDER BY SAL DESC ;

--다른 표현방법
SELECT ROWNUM, A.*
FROM (SELECT  *
	FROM EMP E
	ORDER BY SAL DESC) A --괄호 안에를 A
	;

--SAL을 기준으로 상위 5개 행 출력
SELECT ROWNUM, E.*
	FROM( SELECT *
		FROM EMP E
		ORDER BY SAL DESC
	) E
	WHERE ROWNUM <= 5 ;

/* 데이터 사전조회 */
SELECT *
FROM DICT
WHERE table_name LIKE 'USER_CON%' ; --USER_ 가 포함된 모든~ 단어 다 찾아줘! 와일드카드
-- 데이터 존재하는지 찾아보기
SELECT *
	FROM DBA_TABLES 
WHERE TABLE_NAME LIKE 'EMP%' ;




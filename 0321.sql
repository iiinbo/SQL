--2023/03/21
SELECT COUNT(ENAME)  
FROM EMP;

SELECT SUM(SAL)
 FROM EMP;
 
--EMP 테이블의 직원명을 나타내는 데이터와 월급 합계를 출력
SELECT ENAME, SUM(SAL)
FROM EMP;

SELECT SUM(COMM)
FROM EMP;

--DISTINCT : 중복값은 제거하기 때문에, ALL SUM과 결과가 다르다.
SELECT SUM(DISTINCT SAL) 
	,SUM(ALL SAL)
	,SUM(SAL)
	,AVG(SAL) 
	,COUNT(ENAME) 
	FROM EMP;

/* 실제론 COMM에 NULL값이 포함되어 있지만~ COUNT에 개수 안된다. */
SELECT COUNT(COMM)
FROM EMP;

SELECT COUNT(COMM)
FROM EMP
WHERE DEPTNO = 10;

--30이란 부서에서 최대 월급 얼마?
SELECT MAX(SAL)
FROM EMP
WHERE DEPTNO = 30;

SELECT MIN(SAL)
FROM EMP
WHERE DEPTNO = 30;

--입사일자가 가장 최근인 값
SELECT MAX(HIREDATE)
FROM EMP
WHERE DEPTNO = 30;

--추가수당이 있는 직원의 수 (NULL인 사람 빼고)
SELECT COUNT(COMM)
FROM EMP 
WHERE COMM = 0;

SELECT COUNT(ENAME)
FROM EMP 
WHERE COMM IS NOT NULL;

SELECT COUNT(ENAME)
FROM EMP 
WHERE NVL(COMM, 0) > 0
; --COMM이 0으로 되어있는 사람이 있다.(0와 NULL은 다름)

--30 부서 소속인 직원들의 월급 평균
SELECT AVG(SAL)
FROM EMP
WHERE DEPTNO = 30;

--GROUP BY : 카테고리별로 집계하고 싶을 때 사용하기 그룹바이 뒤에 HAVING이 있다면 그룹바이에서 정한 카테코리별 조건을 부여가 가능하다.
--각 부서 / 직무별 / 월급의 평균
SELECT DEPTNO, COUNT(ENAME), JOB, AVG(SAL)
FROM EMP
HAVING ENAME IS NOT NULL /* 다른 표현방법 : HAVING COUNT(ENAME) > 0  */
GROUP BY DEPTNO, ENAME , JOB ;

--테이블 정규화로 분할된 테이블 컬럼을 다시 합치는 방법 : JOIN
--아래 예시는 잘못된 JOIN방법 : 직원의 이름이 SMITH인 직원의 정보를 가져오기 / DEPTNO가 두 테이블에 모두 있는데, 맞지않는 정보까지 다 붙음
SELECT *
FROM EMP E, DEPT D 
WHERE E.ENAME = 'SMITH'
ORDER BY E.EMPNO 
;

--INNER JOIN으로 교집합(중복되는 값만 가져오는) 컬럼 연결해보기
--1
SELECT *
	FROM EMP, DEPT 
	WHERE EMP.DEPTNO = DEPT.DEPTNO --포인트 : 컬럼명이 같아서가 아니라, 실제 담긴 값이 같기에! 조인한다. FK키를 통해 같은지 알 수 있다.
	ORDER BY EMPNO ;
--2
SELECT E.EMPNO 
	, D.DNAME 
	, E.JOB 
	, E.HIREDATE 
	, E.SAL 
	FROM EMP E JOIN DEPT D  --테이블 두개를 붙인다.
	ON E.DEPTNO = D.DEPTNO ; --ON키워드 뒤에 값을 비교한다.

/*자바에 적용시킬 때 변수만들고 사용하는 법*/
var_deptno ; --사용자로부터 입력받은 부서 번호

var_sql = "SELECT E.EMPNO 
	, D.DNAME 
	, E.JOB 
	, E.HIREDATE 
	, E.SAL 
	FROM EMP E JOIN DEPT D
	USING ($var_deptno) ;"

SELECT E.EMPNO 
	, D.DNAME 
	, E.JOB 
	, E.HIREDATE 
	, E.SAL 
	FROM EMP E JOIN DEPT D
	USING (DEPTNO) ; --USING을 사용하면 이 키워드 하나로 동일한 컬럼을 비교할 수 있다. 그러나 컬럼명이 동일해야 한다.
	--& 나중에 이 작성한 문구 그대로 자바에 붙일 수 있다. 만국공통 문장이라.
	
SELECT E.EMPNO 
	--, E.HIREDATE : 입사일자가, 시스템날짜라서 시간까지 나오는데 필요없는 자료라 아래처럼 뽑아냈다.
	, TO_CHAR(E.HIREDATE, 'YYYY-MM-DD') AS HDATE --제일깔끔
	, EXTRACT (YEAR FROM HIREDATE) AS YYYY --개별도 가능
	, EXTRACT (MONTH FROM HIREDATE) AS MM
	, EXTRACT (DAY FROM HIREDATE) AS DD
	, E.ENAME 
	, D.DEPTNO 
	, D.LOC 
	FROM EMP E, DEPT D
	WHERE E.DEPTNO = D.DEPTNO --오라클에서 조인할 때 
	ORDER BY D.DEPTNO , E.EMPNO ;
	
SELECT D.DNAME 
	,COUNT(E.SAL) 
	, AVG(E.SAL) 
	, SUM(E.SAL)
	, SUM(E.SAL)
	, MAX(E.SAL)
	, MIN(E.SAL) 
	FROM EMP E, DEPT D
	WHERE E.DEPTNO = D.DEPTNO AND E.SAL < 2000 --조건을 추가해줄 땐 AND로
	GROUP BY D.DNAME ;
	
SELECT E.ENAME 
	,E.EMPNO 
	,E.JOB 
	,E.SAL
	,S.GRADE 
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL  AND S.HISAL ; 

SELECT E.ENAME 
	, E.DEPTNO 
	, E.JOB 
	, S.GRADE 
	, E.SAL 
	, S.LOSAL 
	, S.HISAL 
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL  AND S.HISAL ; 

/* JOIN함수로 SALGRADE를 부여하고 GRADE로 그룹별 직원 수를 출력 */
SELECT 
	 COUNT(E.ENAME) --직원 수 
	, S.GRADE 
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL  AND S.HISAL
GROUP BY S.GRADE  --이 기준으로 그룹 지정 : 등급이 기준이라, 부서NO를 함께 출력해낼 수가 없음.
ORDER BY COUNT(E.ENAME) ; --

/*셀프조인 : 자기 자신의 릴레이션을 이용해서 컬럼을 조작한다 */
--한 테이블 내에서 VLOOKUP 한다고 생각하면 쉬움
--똑같은 의미를 가지고 있는 컬럼이 있다면 가능 (직원번호 와 매니저번호)
SELECT E1.EMPNO AS EMP_NO 
	,E1.MGR AS MGR_NO_E1
	, E1.ENAME AS EMP_NAME
	, E2.ENAME AS MGR_NAME
FROM EMP E1, EMP E2 --SELF JOIN을 위해 한테이블 두번 사용하기
WHERE E1.EMPNO = E2.MGR --번호체계가 같아서
; 

SELECT E1.EMPNO --상사의 사번 
	,E1.ENAME --상사의 이름
	,E1.MGR --상사의 사번
	,E2.EMPNO --직원의 사번
	,E2.ENAME --직원의 이름
FROM EMP E1, EMP E2
WHERE E1.MGR = E2.EMPNO ;

/* 왼쪽 테이블의 값은 다 가져오고, JOIN하는 테이블에선 일부만 붙이기 */
--활용예 : 내가 가지고 있는 테이블에 추가로 먼가 하나씩 붙이고 싶을 때
--오라클 SQL 사용법
SELECT E1.EMPNO --상사의 사번 
	,E1.ENAME --상사의 이름
	,E1.MGR --상사의 사번
	,E2.EMPNO --직원의 사번
	,E2.ENAME --직원의 이름
FROM EMP E1, EMP E2
WHERE E1.MGR = E2.EMPNO(+) --(+) 의 의미는 왼쪽 테이블에 ADD 추가 한다는 개념.
;

--표준 SQL 사용법
SELECT E1.EMPNO --상사의 사번 
	,E1.ENAME --상사의 이름
	,E1.MGR --상사의 사번
	,E2.EMPNO --직원의 사번
	,E2.ENAME --직원의 이름
FROM EMP E1 LEFT OUTER JOIN EMP E2
			ON E1.MGR = E2.EMPNO ;

/* FULL-OUTER-JOIN */
SELECT E1.EMPNO --상사의 사번 
	,E1.ENAME --상사의 이름
	,E1.MGR --상사의 사번
	,E2.EMPNO --직원의 사번
	,E2.ENAME --직원의 이름
FROM EMP E1 FULL OUTER JOIN EMP E2
			ON E1.MGR  = E2.EMPNO  
			ORDER BY E1.EMPNO ;
		
/* 4개 테이블 활용해서 SELF JOOIN하기 */
--1
SELECT D.DEPTNO
	, D.DNAME
	, E1.EMPNO
	, E1.ENAME
	, E1.MGR
	, E1.SAL
	, S.LOSAL
	, S.HISAL
	, S.GRADE
	, E2.EMPNO AS E2_NO
	, E2.ENAME AS E2_NAME
FROM EMP E1, DEPT D, SALGRADE S, EMP E2
		WHERE E1.DEPTNO(+) = D.DEPTNO --RIGHT JON했다.
		AND E1.SAL BETWEEN S.LOSAL(+) AND S.HISAL(+)
		AND E1.MGR = E2.EMPNO(+) ;

	/* 테이블 일부 데이터를 오라클 SQL로 출력 */
	SELECT D.DEPTNO
	, D.DNAME
	, E1.EMPNO
	, E1.ENAME
	, E1.MGR
	, E1.SAL
	FROM EMP E1, DEPT D
	WHERE E1.EMPNO = D.DEPTNO ;
--2
	SELECT E1.EMPNO
	, E1.ENAME
	, E1.MGR
	, E1.SAL
	, S.LOSAL
	, S.HISAL
	, S.GRADE
	FROM EMP E1, SALGRADE S
	WHERE E1.SAL BETWEEN S.LOSAL(+) AND S.HISAL(+);

-- 3
	SELECT  E1.EMPNO
	, E1.ENAME
	, E1.MGR
	, E1.SAL
	, E2.EMPNO AS E2_NO
	, E2.ENAME AS E2_NAME
FROM EMP E1,  EMP E2
WHERE E1.MGR = E2.EMPNO(+);
	
--표준SQL
--EMP E1, DEPT D, SALGRADE S, EMP E2
	SELECT D.DEPTNO
	, D.DNAME
	, E1.EMPNO
	, E1.ENAME
	, E1.MGR
	, E1.SAL
	, S.LOSAL
	, S.HISAL
	, S.GRADE
	, E2.EMPNO AS E2NO
	, E2.ENAME AS E2NAME
	FROM EMP E1, RIGHT JOIN DEPT D 
			ON E1.DEPTNO = D.DEPTNO 
			LEFT OUTER JOIN SALGRADE S 
			ON (E1.SAL >= S.LOSAL) AND E1.SAL <= S.HISAL 
			LEFT OUTER JOIN EMP E2
			ON (E1.MGR = E2.EMPNO ) ;
		
	/* 단일행 서브 쿼리 - 쿼리 안에 쿼리문장 사용 
	 * SELECT 쿼리의 결과는 -> 1개의 값이 출력된다. */
	SELECT SAL
	FROM EMP E
	WHERE E.ENAME = 'SMITH';

--
SELECT *
FROM EMP E, DEPT D
	WHERE E.DEPTNO = D.DEPTNO 
	AND E.DEPTNO = 20
	AND E.SAL > (SELECT AVG(SAL) --직원의 평균 월급
			FROM EMP) ;
		
	/* 다중행 서브 쿼리 - 쿼리 안에 쿼리문장 사용 
	 * SELECT 쿼리의 결과는 -> 2개 이상의 값이 출력된다 */		
--
		SELECT *
		FROM EMP 
		WHERE SAL < ANY(SELECT SAL --ANY : 어느하나라도 TRUE면 TRUE 
			FROM EMP 
			WHERE DEPTNO = 30) ;
			
		/*다중 열 서브 쿼리 - 서브쿼리 결과가 2개 이상의 컬럼으로 구성된 값 */
		SELECT DEPTNO , SAL, EMPNO , ENAME 
		FROM EMP 
		WHERE (DEPTNO, SAL) IN (SELECT DEPTNO , MAX(SAL)
								FROM EMP 
								GROUP BY DEPTNO) ;
		
		/* FROM절에 사용되는 서브쿼리 */
	    SELECT A.ENAME
	    	, A.SAL
	    	, B.DNAME 
	    	, B.LOC 
	    FROM (SELECT * FROM EMP WHERE DEPTNO = 30) A --테이블 안에서도 부서번호 30인것 만 가져와서 쓸래 A라는 이름으로 
	    , (SELECT * FROM DEPT ) B --DEPT D 이렇게 해서 가져왔던걸 다른 표현방법으로 사용해보는 것
	    WHERE A.DEPTNO = B.DEPTNO  ;
	    
	   /* WITH 구문 사용 - 편리한 가상 테이블  */
	   WITH E AS (SELECT * FROM EMP WHERE DEPTNO = 20)
	   		, D AS (SELECT * FROM DEPT)
	   		, S AS (SELECT * FROM SALGRADE)
	   	SELECT  E.ENAME
	   			, D.DNAME
	   			, D.LOC
	   			, S.GRADE
	   		FROM E, D, S 
	   		WHERE E.DEPTNO = D.DEPTNO --SMITH가 4명 나오면,, WHERE조건으로 한명만 나오게 해주기
	   		AND E.SAL BETWEEN S.LOSAL AND S.HISAL
	   		;
		   		
	   /* CREATE TABLE 해보기  */
	   	CREATE TABLE DEPT_TEMP 
	   		AS (SELECT * FROM DEPT) ;
	   	
	   	--CREATE / ALTER / DROP : 우측 명령어 입력되면 자동 커밋
	   	--COMMIT ; --TO CONFIRM의 의미
/* 20230321 정인보 5조 */
/* 이론과제 2일차 단답형 */
-- Q2-1
--(1) : 테이블
--(2) : 외래키(FK)
--(3) : NULL

-- Q2-2
--(1) : 문자셋(CharacterSet)
--(2) : 문자셋(CharSet)

-- Q2-3
--(1) : VARCHAR2
--(2) : CHAR
 
-- Q2-4
--(1) : 제약조건
--(2) : 기본키(PRIMARY KEY)
--(3) : 외래키(FOREIGN KEY)

 -- Q2-5
--(1) : 무결성(INTEGRITY)
--(2) : 무결성
--(3) : 무결성

 -- Q2-6
--(1) : UNIQUE
--(2) : NOT NULL
--(3) : INDEX

/* 이론과제 2일차 구문작성형 */
--8 ~ 9페이지
--1 : OK
SELECT E.DEPTNO AS 부서번호
		, ROUND(AVG(E.SAL), 0) AS 평균급여 --소수점 없이 출력
		, MAX(E.SAL) AS 최고급여
		, MIN(E.SAL) AS 최저급여
		, COUNT(E.ENAME) AS 사원수
FROM EMP E
GROUP BY E.DEPTNO
;

--2 : 인원이 3명 이상인 것만 HAVING OK
SELECT E.JOB AS 직책직무
		, COUNT(*) AS 인원수
FROM EMP E
HAVING COUNT(E.JOB) >= 3
GROUP BY E.JOB 
;

--3 : OK
SELECT TO_CHAR(E.HIREDATE, 'YYYY') AS 입사년도
		, E.DEPTNO 
		, COUNT(*) AS 부서인원 
FROM EMP E
GROUP BY TO_CHAR(E.HIREDATE, 'YYYY'), E.DEPTNO
;

--4 : OK
SELECT NVL2(COMM, 'Y', 'N')
		, COUNT(*)
FROM EMP 
GROUP BY NVL2(COMM, 'Y', 'N')
;

--5 : OK
SELECT E.DEPTNO
		, TO_CHAR(E.HIREDATE, 'YYYY') AS 입사년도
		, COUNT(*) AS CNT
		, MAX(E.SAL)
		, SUM(E.SAL)
		, AVG(E.SAL) 
FROM EMP E
GROUP BY ROLLUP (E.DEPTNO, TO_CHAR(E.HIREDATE, 'YYYY')) ;

--10 ~ 11페이지 : 
--1 (1) : 오라클 SQL 방식 OK
SELECT 	E.DEPTNO 
		, D.DNAME 
		, E.EMPNO 
		, E.ENAME 
		, E.SAL 
FROM EMP E, DEPT D --테이블 2개 INNER JOIN
WHERE E.DEPTNO = D.DEPTNO 
	AND E.SAL > 2000
;

--1 (2) : 표준 SQL 방식 OK
SELECT 	E.DEPTNO 
		, D.DNAME 
		, E.EMPNO 
		, E.ENAME 
		, E.SAL 
FROM EMP E JOIN DEPT D --테이블 2개 INNER JOIN
	ON E.DEPTNO = D.DEPTNO 
WHERE E.SAL > 2000
;

--2 : NATURAL JOIN OK
SELECT DEPTNO 
		, D.DNAME  AS 부서명
		, ROUND(AVG(E.SAL), 0) AS 평균급여
		, MAX(E.SAL)  AS 최대급여
		, MIN(E.SAL)AS 최소급여
		, COUNT(*) AS CNT
FROM EMP E
NATURAL JOIN DEPT D
GROUP BY DEPTNO, D.DNAME 
;

--3 : RIGHT JOIN OK
SELECT D.DEPTNO 
		, D.DNAME 
		, E.EMPNO 
		, E.ENAME 
		, E.JOB 
		, E.SAL 
FROM EMP E RIGHT OUTER JOIN DEPT D --표준SQL방법
	ON E.DEPTNO(+) = D.DEPTNO 
;

--4 : 직속상관 정보 OK
SELECT D.DEPTNO --
		, D.DNAME 
		, E.EMPNO 
		, E.ENAME 
		, E.MGR 
		, E.SAL 
		--, E.DEPTNO
		, S.LOSAL
		, S.HISAL
		, S.GRADE 
		, M.EMPNO  AS MGR_EMPNO --
		, M.ENAME AS MGR_ENAME --
FROM EMP E, DEPT D, SALGRADE S, EMP M
	WHERE E.DEPTNO(+) = D.DEPTNO -- 부서정보 동일해서 두테이블끼리 RIGHT JOIN 
	AND E.SAL BETWEEN S.LOSAL(+) AND S.HISAL(+) --(+)로 ADD해야 누락되는 행 없음
	AND E.MGR = M.EMPNO(+) 
ORDER BY D.DEPTNO, D.DNAME, E.ENAME , E.MGR 
;

--12 ~ 13페이지 : OK
-- 1 : ALLEN과 같은 직책인 직원들의 사원명, 사원정보, 부서정보를 출력
SELECT E.JOB, E.EMPNO, E.ENAME, E.SAL, D.DEPTNO, D.DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND JOB = (SELECT JOB
FROM EMP
WHERE ENAME = 'ALLEN')
;
 -- 2 : 전체 사원의 평균 급여보다 높은 급여를 받는 사원정보, 부서정보, 급여 출력
SELECT E.EMPNO, E.ENAME, D.DNAME, E.HIREDATE, D.LOC, E.SAL, S.GRADE
FROM EMP E, DEPT D, SALGRADE S
WHERE E.DEPTNO = D.DEPTNO
AND E.SAL BETWEEN S.LOSAL AND S.HISAL
AND SAL > (SELECT AVG(SAL)
FROM EMP)
ORDER BY E.SAL DESC, E.EMPNO
;
 -- 3 : 부서코드가 10인 부서에 근무하는 사원 중 부서코드 30번 부서에 존재하지 않는 직책을 가진 사원들의 사원 정보를 출력
SELECT E.EMPNO, E.ENAME, E.JOB, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND E.DEPTNO = 10
AND JOB NOT IN (SELECT DISTINCT JOB
FROM EMP
WHERE DEPTNO =30)
;
 -- 4 : 직책이 SALESMAN인 사람들의 최고 급여보다 높은 급여를 받는 사원들의 사원 정보를 출력
-- 다중행 함수를 사용한 경우 MAX() 사용
SELECT E.EMPNO, E.ENAME, E.SAL, S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL
AND SAL > ALL(SELECT SAL
FROM EMP
WHERE JOB = 'SALESMAN')
ORDER BY EMPNO
;
 -- 5 : 다중행 함수를 사용하지 않고 ALL 키워드를 사용하여 결과를 출력
SELECT E.EMPNO, E.ENAME, E.SAL, S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL
AND SAL > ALL(SELECT MAX(SAL)
FROM EMP
WHERE JOB = 'SALESMAN')
ORDER BY EMPNO
;

/* 20230324 */
/*  JOIN ~ ON : 두 개 테이블의 컬럼을 연결  */

--INNER JOIN : 1:1 연결하여 추가정보를 제공하는 목적
SELECT *
FROM EMP E JOIN DEPT D 
	ON E.DEPTNO = D.DEPTNO
	;

--테이블명(또는 별칭명) (컬럼명) 으로 해보기
SELECT E.EMPNO 
		, E.ENAME 
		, E.JOB 
		, E.HIREDATE 
		, E.SAL 
		, E.COMM 
		, D.DEPTNO 
		, D.DNAME 
		, D.LOC 
FROM EMP E JOIN DEPT D --INNER JOIN 교집합
	ON E.DEPTNO = D.DEPTNO --직원과 부서를 1:1로
	;
	
/* SAL구간을 이용하여 해당 구간에 해당되는 직원을 연결 (1:1관계) */
--방법 1
SELECT E.EMPNO 
		, E.ENAME 
		, E.JOB 
		, E.HIREDATE 
		, E.SAL 
		, E.COMM 
		, S.GRADE 
		, S.LOSAL 
		, S.HISAL 
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL  AND S.HISAL 
--GROUP BY S.GRADE 여기에 그룹바이 하고 싶으면, SELECT에 들어가있는 E.SAL에다가, 집계함수 넣어줘야한다~(SUM이나 AVG 등)
;

--방법 2 : 아래 방법으로 하면, 여러개의 테이블을 동일하게 붙여서 여러번 조인이 가능하다~ (맨 밑에 FROM 절에 테이블명을 계속 추가해주면 된다)

WITH EMP_SAL AS (
SELECT E.EMPNO 
		, E.ENAME 
		, E.JOB 
		, E.HIREDATE 
		, E.SAL 
		, E.COMM 
		, S.GRADE 
		, S.LOSAL 
		, S.HISAL 
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL  AND S.HISAL 
)
SELECT *
FROM EMP_SAL;

/* SELF-JOIN : 하나의 테이블에 성질이 동일한 2개 이상의 컬럼 관계를 엮어서 데이터 추출  */
--13개 행
SELECT E1.EMPNO 
		, E1.ENAME 
		, E1.MGR 
		, E2.EMPNO --매니저의 사번!
		, E2.ENAME --가져온 매니저 사번의 이름!!
FROM EMP E1 JOIN EMP E2
ON E1.MGR = E2.EMPNO --EMP 테이블에 사번 이름은 있지만, 매니저의 이름이 없다. 매니저 이름 가져오고 싶어서 MGR(숫자)을 왼쪽에 집어넣었다.
;--그러나, 여기서 킹 빠진다! 가장 최 상위 매니저라, 하위 매니저가 없다보니ㅠ 

-- 그래서~ LEFT 조인으로 해야 누락이 안된다.(14개 행)
SELECT E1.EMPNO 
		, E1.ENAME 
		, E1.MGR 
		, E2.EMPNO --매니저의 사번!
		, E2.ENAME --가져온 매니저 사번의 이름!!
FROM EMP E1 LEFT JOIN EMP E2
ON E1.MGR = E2.EMPNO;

--RIGHT JOIN
SELECT E1.EMPNO 
		, E1.ENAME 
		, E1.MGR 
		, E2.EMPNO --매니저의 사번!
		, E2.ENAME --가져온 매니저 사번의 이름!!
FROM EMP E1 RIGHT JOIN EMP E2
ON E1.MGR = E2.EMPNO;

--FULL JOIN
SELECT E1.EMPNO 
		, E1.ENAME 
		, E1.MGR 
		, E2.EMPNO --매니저의 사번!
		, E2.ENAME --가져온 매니저 사번의 이름!!
FROM EMP E1 FULL OUTER JOIN EMP E2
ON E1.MGR = E2.EMPNO;

SELECT *
FROM EMP E1 RIGHT JOIN DEPT D
			ON E1.DEPTNO = D.DEPTNO 
		LEFT JOIN SALGRADE S
			ON E1.SAL BETWEEN S.LOSAL  AND S.HISAL 
		LEFT JOIN EMP E2
			ON E1.MGR = E2.EMPNO 
;


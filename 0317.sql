--137P
SELECT 100 + 5, 10-3, 30*2, 10/3 FROM DUAL;


SELECT dbms_random.value() * 100 AS randomnum FROM DUAL; --컬럼명을 AS로 별칭사용

SELECT ENAME FROM EMP AS employee;

SELECT ENAME AS "employee name" FROM EMP employee;

--정렬
SELECT * FROM EMP ORDER BY SAL; --오름차순

SELECT * FROM EMP ORDER BY SAL DESC; --내림차순

SELECT * FROM EMP ORDER BY DEPTNO ASC, SAL DESC; --DEPTNO 오름차순, SAL 내림차순

SELECT * FROM NLS_DATABASE_PARAMETERS ;

SELECT * FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER = 'NLS_CHARACTERSET';

SELECT * FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER LIKE '%LANGUAGE';

SELECT ENAME FROM EMP WHERE DEPTNO = '20'; --자동으로 ''안에 들어간 문자형을 숫자형으로 변환시킨다.장점이자 주의사항

SELECT ENAME FROM EMP WHERE DEPTNO = 20 AND JOB = 'CLERK';

SELECT * FROM EMP WHERE SAL IN (3000, 5000);

SELECT * FROM EMP
 WHERE ENAME LIKE 'M%';
 
SELECT * FROM EMP
 WHERE ENAME LIKE '_L%';
 
SELECT * FROM EMP
 WHERE ENAME LIKE '%AM%';
 
SELECT * FROM EMP
 WHERE ENAME LIKE '%S';
 
SELECT * FROM EMP WHERE MGR IS NULL;

--UNION 키워드 사용 . 합집합 실행 후 중복되는 값 제거.

SELECT EMPNO, ENAME, SAL, DEPTNO, JOB FROM EMP WHERE JOB = 'CLERK'

UNION 

SELECT EMPNO, ENAME, SAL, DEPTNO, JOB FROM EMP WHERE JOB = 'SALESMAN';

--컬럼명이 서로 일치하지 않을 경우
SELECT EMPNO, ENAME, SAL, DEPTNO FROM EMP WHERE DEPTNO  = 10

UNION 

SELECT EMPNO, ENAME, SAL  FROM EMP WHERE  DEPTNO  = 20;
--
SELECT  * FROM V$SQLFN_METADATA; --오라클 함수 리스트를 볼 수 있다.

SELECT * FROM EMP WHERE UPPER(ENAME) = UPPER('scott'); --소문자를 대문자로 변환   


SELECT INSTR('HELLO, ORACLE!', 'L')AS INSTR_1,
INSTR('HELLO, ORACLE!', 'L', 5)AS INSTR_2,
INSTR('HELLO, ORACLE!', 'L', 2, 2)AS INSTR_3
FROM DUAL;

--문자열 왼편에서 채우기(LPAD) 문자열, 개수, 채울문자-채울문자 입력 안하면 기본값은 공란으로 나온다. . 문자열 왼편부터 채움
-- 오른쪽부터 채우기 (RPAD)
SELECT 'ORACLE', 
LPAD('ORACLE', 10, '#') AS LPAD_1
, RPAD('ORACLE', 10, '*') AS RPAD_1
, LPAD('ORACLE', 10) AS LPAD_2 
, RPAD('ORACLE', 10) AS RPAD_2
FROM DUAL;

SELECT RPAD('970923-', 14, '*') AS RPAD_INBO
,RPAD('010-3106-', 13, '*') AS RPAD_INBOPHONE
FROM DUAL;

--현재 시스템의 년월일 시분초 구하는 함수
SELECT SYSDATE AS NOW
,SYSDATE-1 AS YESTERDAY
,SYSDATE+1 AS TOMORROW
FROM DUAL;
--현재 날짜, 3개월 뒤 날짜
SELECT SYSDATE , ADD_MONTHS(SYSDATE, 3) FROM DUAL; 
--입사일로부터 12개월 * 20년 했을 때 나오는 일자
SELECT EMPNO, ENAME, HIREDATE,
ADD_MONTHS(HIREDATE, 12 * 20) AS WORK10TEAR FROM EMP; 

SELECT ADD_MONTHS('2015-07-27', 12*10) AS WORK10YEAR FROM DUAL;

--날짜에 ROUND 반올림을 한 함수
SELECT SYSDATE , ROUND(SYSDATE, 'CC') AS FORMAT_CC, --연도 4자리 끝 두자리 기준 반올림실행
 ROUND(SYSDATE, 'YYYY') AS FORMAT_YYYY, --년도ㄹ
  ROUND(SYSDATE, 'Q') AS FORMAT_Q, --분기의 두번째 달(지금 1분기인데, 2월 16일 기준이 딱 절반이다.)
   ROUND(SYSDATE, 'DDD') AS FORMAT_DDD, --일자
    ROUND(SYSDATE, 'HH') AS FORMAT_HH FROM DUAL; --시간
    
 --형 변환 방법 : 암묵적 형변환 / 명시적 형변환(사용자)
 --암묵적 형변환, 사원코드에 500 이란 문자열을 더함
 SELECT EMPNO, ENAME, EMPNO + '500' FROM EMP WHERE ENAME = 'SCOTT';
 
SELECT 1300- '1500','1300'+1500 FROM DUAL;
--명시적 형 변환
SELECT TO_NUMBER('1,500', '9,999') - 1300 FROM DUAL;

--NULL 처리 함수
--NVL(값1, 값2) : 값1(컬럼)이 NULL이면 그자리에 값2(0)을 입력하겠다.
SELECT SUM(COMM) FROM EMP; --NULL이 포함되면 연산 자체가 진행이 안됨.
SELECT EMPNO, ENAME, SAL, COMM, SAL+COMM, 
NVL(COMM, 0)
, SAL+NVL(COMM, 0) FROM EMP; 

--NVL2(값1, 값2, 값3) : 입력값 3개를 순서대로
SELECT EMPNO, ENAME, COMM
,NVL2(COMM, 'O','X')
,NVL2(COMM, SAL*12+COMM, SAL*12) AS ANNSAL
FROM EMP;

--조인
--교집합 INNER-JOIN
SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
ORDER BY EMPNO;

--조인~ON으로 등가교환(이너조인), SQL문법
SELECT *
FROM EMP E JOIN DEPT D 
ON (E.DEPTNO = D.DEPTNO)
ORDER BY EMPNO ;

--USING구문을 활용한 조인 SQL문법 (잘 안씀)
SELECT *

--컬럼명이 구분되지 않는 경우엔 아래처럼 에러난다.//DEPTNO 컬럼이 E와 D에 모두 있는데, SELECT에서 어떤 테이블의 컬럼을 사용할지 정해주지 않아서.
SELECT EMPNO, ENAME, DEPTNO, DNAME, LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO ;
FROM EMP E JOIN DEPT D 
USING (DEPTNO)
ORDER BY E.EMPNO ;
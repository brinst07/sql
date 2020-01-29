--orderby4
--10번 혹은 30번 부서에 속하는 사람

SELECT *
FROM emp
WHERE deptno in (10,30) AND SAL > 1500
ORDER BY ename DESC;

--ROWNUM -> 페이징, 정렬과 관련된 것을 할 때 중요하다. 보통 rn이라고 alias를 붙임
SELECT ROWNUM, empno, ename
FROM emp
WHERE deptno IN (10,30)
AND sal > 1500;

--ROWNUM을 WHERE절에서도 사용가능하다.
--동작하는 것 =  ROWNUM =1, ROWNUM <=2 --> ROWNUM =1, ROWNUM <=N
--동작하지 않는것 =ROWNUM =2, ROWNUM >=2 --> ROWNUM=N(N은 1이 아닌 정수), ROWNUM >= N(N은 1이 아닌 정수)
--ROWNUM 이미 읽은데이터에다가 순서를 부여
--  **유의점1. 읽지 않은 상태의 값들(ROWNUM이 부여되지 않는 행)은 조회할 수가 없다.
--  **유의점2. ORDER BY 절은 SELECT 절 이후에 실행
--사용용도 : 페이징 처리(1page의 1~15번처럼 부여)
--테이블에 있는 모든 행을 조회하는 것이 아니라 우리가 원하는 페이지에 해당하는 행 데이터만 조회한다.
--페이징 처리시 고려사항 : 1페이지당 긴수, 정렬 기준
--emp데이블 중 row 건수 : 14
--페이징당 5건의 데이터를 조회
--1page : 1~5
--2page : 6~10
--3page : 11~15
SELECT ROWNUM rn, empno, ename
FROM emp
ORDER BY ename;

--정렬된 결과에 ROWNUM을 부여 하기 위해서는 IN-LINE VIW를 사용한다. 197
--요점정리 : 1. 정렬 ,2. ROWNUM 부여
--SELECT에 *를 기술할 경우 다른 EXPRESSION을 표기하기 위해서 테이블명.*로 표기해야한다.
SELECT ROWNUM, emp.*
FROM emp;

SELECT ROWNUM, e.*
FROM emp e;

--ROWNUM -> rn
-- *page size : 5, 정렬기준은 ename
-- 1page : rn 1~5
-- 2page : rn 6~10
-- 3page : rn 11~15
-- npage : rn (page-1)*pageSize+1 ~ page * pagesize
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) a)
WHERE rn BETWEEN (1-1)*5+1 AND 1*5;

--ROWNUM 1
SELECT *
FROM(SELECT ROWNUM rn, empno, ename
FROM EMP)
WHERE rn <=10;

SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM <=10;
-- WHERE rn <=10; 은 안된다. 특수한 경우

--ROWNUM2
SELECT *
FROM
    (SELECT ROWNUM rn, empno, ename
    FROM emp)
WHERE rn BETWEEN 11 AND 20;

--ROWNUM3
SELECT *
FROM
    (SELECT ROWNUM rn, e.*
    FROM
        (SELECT empno, ename
        FROM emp 
        ORDER BY ename) 
    e)
WHERE rn between (:page-1)*:pageSize+1 AND :page*10;
--바인딩 변수는 자바와 연동할때 많이 사용하고, SQL을 개발할 때는 바인딩을 잘 사용하지는 않는다.


--DUAL 테이블 : 데이터와 관계없이 함수를 테스트 해볼 목적으로 사용
--다른 DBMS에서는SQL SERVER에서는 SELECT 절만으로도 수행가능하도록 정의되었다.
SELECT *
FROM dual;

--문자열의 대소문자 : LOWER, UPPER, INITCAP -> 잘사용하지 않는다. 자바에서 이러한 문자열의 처리가 가능하기 때문
--FROM에 emp를 넣으면 emp의 행만큼 출력된다. 왜냐하면 행단위 함수이기 때문이다. WHERE절에 조건을 넣으면 조건을 만족하는 행만큼 출력
SELECT LOWER('Hello, World!') , UPPER('Hello, World!'), INITCAP('hello, World!')
FROM dual;

--함수는 WHERE 절에서도 사용이 가능하다.
--사원 이름이 SMITH인 사원만 조회

--SQL작성시 아래 형태는 지양 해야한다.
--테이블의 컬럼을 가공하지 않는 형태로 SQL을 작성한다.
SELECT *
FROM emp
WHERE LOWER(ename) = :ename;

SELECT CONCAT('Hello', ', World!') CONCAT,
        SUBSTR('Hello, World',1,5)  SUBSTR, --1~5
        LENGTH('Hello, World') len,
        INSTR('Hello, World','o') ins,
        INSTR('Hello, World','o',6) ins2,
        LPAD('Hello, World',15, '*') lpad,
        RPAD('Hello, World',15, '*') rpad,
        REPLACE('Hello, World', 'Hello', 'SAMSUNG') replace,
        TRIM('   Hello, Wolrd   ') trim ,--공백을
        TRIM('d' FROM 'Hello, Wolrd') trim1 --공백이 아닌 소문자 d를 제거한다.
FROM dual;

-- 숫자 함수
-- ROUND : 반올림(10.6을 소수점 첫번째 자리에서 반올림 -> 11),
-- TRUNC : 절삭(버림) (10.6을 소수점 첫번째 자리에서 절삭 --> 10)
-- MOD : 나머지 (몫이 아니라 나누기 연산을 한 나머지 값) (13/5 -> 몫:2 나머지 : 3)
-- ROUND, TRUNC : 몇번쨰 자리에서 반올림/절삭


--ROUND
SELECT ROUND(105.54, 1) round, --반올림 결과가 소수점 첫번째 자리까지 나오도록 --> 두번째 자리에서 반올림한다.
        ROUND(105.55, 1) round,
        ROUND(105.54, 0) round, -- 반올림 결과가 정수부분만, --> 소수점 첫번째 자리에서 반올림한다.
        ROUND(105.54, -1) round, -- 반올림 결과가 십의 자리까지 --> 일의 자리에서 반올림한다.
        ROUND(105.55) -- 두번째 인자를 입력하지 않을 경우 0이 적용한다. 즉 기본값은 0이다.
FROM DUAL;

--TRUNC
SELECT TRUNC(105.54,1) trunc,-- 절삭의 결과가 소수점 첫번째 자리까지 나오도록 --> 두번째 자리에서 절삭
    TRUNC(105.555,2) trunc, -- 절삭의 결과가 소주점 두번째 자리까지 나오도록 --> 세번째 자리에서 절삭
    TRUNC(105.55, 0) trunc, -- 절삭의 겨로가가 정수부(일의 자리)까지 나오도록 --> 소수점 첫번쨰 자리에서 절삭
    TRUNC(105.55, -1) trunc, -- 절삭의 결과가 10의자리까지 나오도록 --> 일의 자리에서 절삭
    TRUNC(105.55) --두번쨰 인자를 입력하지 않을 경우 0이 적용
FROM dual;

--emp 테이블에서 사원의 급여(sal)를 1000으로 나눴을때 몫

SELECT TRUNC(sal/1000), -- 몫을 구해보세요
        MOD(sal,1000) --mod의 결과는 divisor보다 항상 작다.
FROM emp;

DESC emp;

--년도2자리/월2자리/일자2자리 --> 표현되는 형태가 툴에 의존적이다.
SELECT ename, hiredate
FROM emp;

--SYSDATE : 현재 오라클 서버의 시분초가 포함된 날짜 정보를 리턴하는 특수 함수
-- 함수명(인자1, 인자2)
-- date + 정수 = 일자 연산
-- 1 = 하루
-- 1시간 = 1/24
-- 2020/01/28 + 5 -> 02/02

-- 숫자 표기 : 숫자
-- 문자 표기 : 싱글 쿼테이션 + 싱글 쿼테이션 --> '문자열'
-- 날짜 표기 : TO_DATE('문자열 날짜 값', '문자열 날짜 값의 표기 형식') --> TO_DATE('2020/01/28', 'YYYY/MM/DD')
SELECT SYSDATE + 5, SYSDATE + 1/24
FROM dual;

--fn1
SELECT TO_DATE('2019/12/31','YYYY/MM/DD') LASTDAY, TO_DATE('2019/12/31','YYYY/MM/DD')-5 AS LASTDAYE_BEFORE, 
       SYSDATE now, SYSDATE -3 NOW_BEFORE
FROM dual;







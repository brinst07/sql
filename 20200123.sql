--WHERE2
--WHERE 절에 기술하는 조건에 순서는 조회 결과에 영향을 미치지 않는다.
--SQL은 집합의 개념을 가지고 있다.
--집합 : 키가 185이상이고 몸무게가 70이상인 사람들의 모임
--      몸무게가 70이상이고 키가 185이상인 사람들의 모임 위아래가 같음
--      잘생긴 사람들의 모임 --> 집합 x
--집합의 특징 : 집합에는 순서가 없다.
--(1,5,10) --> (10,5,1) : 두 집합은 서로 동일하다.
--테이블에는 순서가 보장되지 않음
--SELECT 결과가 순서가 다르더라도 값이 동일하면 정답
-->정렬기능 제공(ORDER BY)

SELECT ename, hiredate
FROM emp
WHERE hiredate>=TO_DATE('19820101','YYYYMMDD') AND hiredate<=TO_DATE('19830101','YYYYMMDD');

SELECT ename, hiredate
FROM emp
WHERE hiredate<=TO_DATE('19830101','YYYYMMDD') AND hiredate>=TO_DATE('19820101','YYYYMMDD');

-- IN 연산자
-- 특정 집합에 포함되는지 여부를 확인
-- 부서번호가 10번 혹은(or) 20번에 속하는 직원을 조회

SELECT empno, ename, deptno
FROM emp
WHERE deptno IN (10,20);

--IN 연산자를 사용하지 않고 OR 연산자 사용
SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10 OR deptno = 20;

--emp테이블에서 사원이름이 SMITH JONES 인 직원만 조회
SELECT empno, ename, deptno
FROM emp
--WHERE ename IN('SMITH', 'JONES');
WHERE ename = 'SMITH' or ename = 'JONES';

--where 절에 1=2라는 false 값이 들어가면 어떠한 값도 나오지 않는다.
SELECT *
FROM users
WHERE 1=1;

SELECT USERID AS 아이디 , USERNM AS 이름, ALIAS AS 별명
FROM users
WHERE userid IN ('brown','cony','sally');

--문자열 매칭 연산자 : LIKE, %, _
--위에서 연습한 조건은 문자열 일치에 대해서 다룸
--이름이 BR로 시작하는 사람만 조회
--이름에 R 문자열이 들어가는 사람만 조회


SELECT *
FROM emp
ORDER BY ENAME DESC;

--사원 이름이 s로 시작하는 사원 조회
--SMITH, SMILE, SKC
--% 어떤 문자열(한글자, 글자 없을수도 있고, 여러 문자열이 올수도 있다.)
SELECT *
FROM emp
WHERE ename LIKE 'S%';

--글자수를 제한한 패턴 매칭
-- _가 정확히 한 문자
--직원 이름이 s로 시작하고 이름의 전체 길이가 5글자 인 직원
-- S____

SELECT *
FROM emp
WHERE ename LIKE 'S____';

--사원 이름에 S글자가 들어가는 사원 조회
--ename LIKE '%S%'

SELECT *
FROM emp
WHERE ename LIKE '%S%';

SELECT MEM_ID, MEM_NAME
FROM member
WHERE MEM_NAME LIKE '신%';

--where5
SELECT mem_id, mem_name
FROM member
WHERE mem_name Like '%이%';

-- null 비교 연산 (is)
-- comm 컬럼의 값이 null인 데이터를 조회 (WHERE=null)
SELECT *
FROM emp
WHERE COMM = null;

SELECT *
FROM emp
WHERE COMM = '';

SELECT *
FROM emp
WHERE COMM IS NULL;

--where6

SELECT *
FROM emp
WHERE comm IS NOT NULL;

SELECT *
FROM emp
WHERE comm>=0;

--사원의 관리자가 7698, 7839 그리고 null이 아닌 직원만 조회
--NOT IN에 null이 조건에 만족을해도 포함하지 않는다.
--NOT IN 연산자에서는 NULL 값을 포함시키면 안된다.
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839,NULL);


SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839)
AND mgr IS NOT NULL;

--WHERE7
SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--WHERE8
SELECT *
FROM emp
WHERE deptno != 10 AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--WHERE9
SELECT *
FROM emp
WHERE deptno NOT IN 10 AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--WHERE10
SELECT*
FROM emp
WHERE deptno IN (20, 30) AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--WHERE11
SELECT*
FROM emp
WHERE job='SALESMAN' OR hiredate >= TO_DATE('19810601','YYYYMMDD');

--WHERE12
SELECT*
FROM emp
WHERE job='SALESMAN' OR empno LIKE '78%';

--WHERE13
SELECT*
FROM emp
WHERE job = 'SALESMAN' OR (empno >= 7800 AND empno<7900);

-- 연산자 우선순위
-- *,/ 연산자가 +,- 보다 우선순위가 높다.
-- 1+5*2 = 11 
-- 우선순위 변경 : ()
-- AND > OR

-- emp 테이블에서 사원 이름이 SMITH 이거나 사원 이름이 ALLEN이면서 담당업무가 SALESMAN인 사원 조회

SELECT *
FROM emp
WHERE ename = 'SMITH' OR ename = 'ALLEN' AND job = 'SALESMAN';

--사원이름이 SMITH 이거나 ALLEN이면서 담덩업무가 SLAESMAN인 사원조회
SELECT*
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN') AND job = 'SALESMAN';

--where14
SELECT*
FROM emp
WHERE job = 'SALESMAN' or empno LIKE '78%' AND hiredate>=TO_DATE('19810601','YYYYMMDD');

--정렬
-- SELECT*
-- FROM table
-- [WHERE]
-- ORDER BY {컬럼|별칭|컬럼인덱스 [ASC | DESC], .......}

-- emp 테이블의 모든 사원을 ename 컬럼 값을 기준으로 오름 차순 정렬한 결과를 조회하세요

SELECT *
FROM emp
ORDER BY ename DESC;

--DESC emp; -- DESC : DESCRIBE
--ORDER BY ename DESC; -- DESC : DESCENDING (내림)

--  emp 테이블에서 사원 정보를 ename컬럼으로 내림차순, ename 값이 같을경우 mgr 컬럼으로 오름차순
SELECT *
FROM emp
ORDER BY ename DESC, mgr ASC;

--정렬시 별칭을 사용
SELECT empno, ename nm, sal*12 year_sal
FROM emp
ORDER BY year_sal;


--컬럼 인덱스로 정렬
--java array[0]
--SQL COLUMN INDEX : 1부터 시작
SELECT empno, ename nm, sal*12 year_sal
FROM emp
ORDER BY 3;

--ORDER BY 실습
SELECT *
FROM dept
ORDER BY DNAME;

SELECT *
FROM dept
ORDER BY LOC DESC;

--ORDER BY1
SELECT *
FROM dept;

--ORDER BY2
SELECT*
FROM emp
WHERE comm IS NOT NULL AND comm != 0 
ORDER BY comm DESC, empno;

--ORDER BY3
SELECT *
FROM emp
WHERE mgr is not null
ORDER BY job, EMPNO DESC;

SELECT *
FROM emp
WHERE ename LIKE '[a-c]%';

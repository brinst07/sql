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


